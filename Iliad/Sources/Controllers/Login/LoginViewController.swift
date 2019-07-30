//
//  LoginViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import BEMCheckBox
import TransitionButton
import iOSAuthenticator
import SwiftyUserDefaults

class LoginViewController: BaseViewController {

    // MARK: - Outlets
    // Views
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fieldsStackView: UIStackView!

    // Text fields
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!

    // ImageViews
    @IBOutlet weak var logoImageView: UIImageView!

    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var savePasswordLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var infoBarButton: UIBarButtonItem!
    @IBOutlet weak var storeLocationButton: UIBarButtonItem!

    // Mark - Variables
    private var showPasswordButton: UIButton?
    private let notification = UINotificationFeedbackGenerator()
    private let userDefaults = UserDefaults(suiteName: "group.com.luigiaiello.consumptionWidget")
    var logout = false

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configurationUI()
        configurationText()
        recoverUsername()

        if !logout {
            loginWithBiometric()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.scrollView.contentSize = self.fieldsStackView.frame.size
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        #if !DEV
            cheackIfUserReadPolicy()
        #endif
    }

    // MARK: - Segue
    private func performLogin(user: User) {
        guard
            let tabBarController = R.storyboard.main.mainTabBarController(),
            let homeVC = tabBarController.viewControllers?.first as? HomeViewController,
            let navigationController = tabBarController.viewControllers?.last as? UINavigationController,
            let profileVC = navigationController.viewControllers.first as? ProfileViewController
        else {
            return
        }

        Utility.setUserDefaults(userDefaults: userDefaults, values: ["kLoginSuccessful": true])

        homeVC.user = user
        profileVC.user = user

        DispatchQueue.main.async {
            self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                self.present(tabBarController, animated: true, completion: {
                    self.view.isUserInteractionEnabled = true
                })
            })
        }
    }
    
    // MARK: - Setup
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        usernameTextField.delegate = self
        passwordTextField.delegate = self

        #if DEV
            autoFill()
//            autoLogin()
        #endif
    }

    private func configurationUI() {
        passwordTextField.rightView = createShowPasswordButton()
        passwordTextField.rightViewMode = .always

        logoImageView.tintColor = .iliadRed

        customNavigationBar.hideShadowBar()
    }

    private func configurationText() {
        titleLabel.text = R.string.login.title()
        subtitleLabel.text = R.string.login.subtitle()
        usernameTextField.placeholder = R.string.login.username_placeholder()
        passwordTextField.placeholder = R.string.login.password_placeholder()
        savePasswordLabel.text = R.string.login.save_username()
        loginButton.setTitle(R.string.login.login_button(), for: .normal)
        forgotButton.setTitle(R.string.login.forgot_password_button(), for: .normal)
    }

    private func recoverUsername() {
        guard
            Defaults[.saveUsername],
            let username = Config.username()
        else {
            return
        }

        usernameTextField.text = username
        checkBox.setOn(true, animated: false)
    }

    private func loginWithBiometric() {
        guard
            Defaults[.loginWithBiometric],
            let username = Config.username(),
            let password = Config.password()
        else {
            return
        }

        iOSAuthenticator.authenticateWithBiometricsAndPasscode(reason: "Accedi alla tua area personale", success: {
            self.getToken(username: username, password: password)
        }, failure: { (error) in
            print(error)
        })
    }

    // MARK: - Helpers Dev
    #if DEV
    private func autoFill() {
        usernameTextField.text = Credentials.username
        passwordTextField.text = Credentials.password
    }
    private func autoLogin() {
        loginDidTap(loginButton)
    }
    #endif

    // Mark - Helpers
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func createShowPasswordButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_showPassowrd"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: passwordTextField.frame.height, height: passwordTextField.frame.height)
        button.tintColor = .lightGray

        showPasswordButton = button

        let singleTapGesture = SingleTouchDownGestureRecognizer(target: self, action: #selector(showPassword(sender:)))
        button.addGestureRecognizer(singleTapGesture)

        return button
    }

    @objc func showPassword(sender: UITapGestureRecognizer) {
        guard let showPasswordButton = showPasswordButton else {
            return
        }

        if sender.state == .began {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.tintColor = .iliadRed
        } else if sender.state == .ended {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.tintColor = .lightGray
        }
    }

    private func showError(title: String, message: String) {
        self.loginButton.stopAnimation(animationStyle: .normal) {
            self.showErrorMessage(title: title, message: message)
            self.view.isUserInteractionEnabled = true
            self.notification.notificationOccurred(.error)
        }
    }

    private func showTextFieldError(textField: SkyFloatingLabelTextField, error: String) {
        textField.errorMessage = error
        notification.notificationOccurred(.error)
    }

    private func saveValues(username: String, password: String) -> String {
        Defaults[.saveUsername] = checkBox.on

        let passwordBase64 = password.toBase64()
        Config.store(username: username)
        Config.store(password: passwordBase64)

        return passwordBase64
    }

    private func cheackIfUserReadPolicy() {
        if !Defaults[.readPolicy] {
            guard let infoVC = R.storyboard.login.infoViewController() else {
                return
            }

            infoVC.showBackButton = false
            
            self.present(infoVC, animated: true, completion: nil)
        }
    }
    
    // Mark - APIs
    private func getToken(username: String, password: String) {
        loginButton.startAnimation()
        view.isUserInteractionEnabled = false

        API.LoginClass.getToken(username: username, password: password) { (token, success) in
            guard success, let token = token else {
                self.showError(title: R.string.commons.error(), message: R.string.login.login_error_message())
                return
            }

            Config.token = token
            self.login(username: username, password: password)
        }
    }

    private func login(username: String, password: String) {
        API.LoginClass.login(username: username, password: password) { (json) in
            guard let json = json else {
                self.showError(title: R.string.commons.error(), message: R.string.login.login_error_message())
                return
            }

            let user = User(json: json["iliad"])
            self.performLogin(user: user)
        }
    }

    // MARK: - Actions
    @IBAction func loginDidTap(_ sender: Any) {
        guard
            let usernameText = usernameTextField.text,
            let passwordText = passwordTextField.text
        else {
            return
        }

        guard !usernameText.isEmpty else {
            showTextFieldError(textField: usernameTextField, error: R.string.login.username_textfield_error())
            return
        }
        usernameTextField.errorMessage = nil

        guard !passwordText.isEmpty else {
            showTextFieldError(textField: passwordTextField, error:  R.string.login.password_textfield_error())
            return
        }
        passwordTextField.errorMessage = nil

        let passwordBase64 = saveValues(username: usernameText, password: passwordText)

        getToken(username: usernameText, password: passwordBase64)
    }
    
    @IBAction func forgotPasswordDidTap(_ sender: Any) {
        guard let recoverPasswordVC = R.storyboard.login.recoverPasswordViewController() else {
            return
        }

        recoverPasswordVC.delegate = self
        
        self.present(recoverPasswordVC, animated: true, completion: nil)
    }
    
    @IBAction func checkBoxChanged(_ sender: Any) {
        guard let checkBox = sender as? BEMCheckBox else {
            return
        }

        Defaults[.saveUsername] = checkBox.on
    }

    @IBAction func infoDidTap(_ sender: Any) {
        guard let infoVC = R.storyboard.login.infoViewController() else {
            return
        }

        self.present(infoVC, animated: true, completion: nil)
    }
    
    @IBAction func storeLocationDidTap(_ sender: Any) {
        guard let storeVC = R.storyboard.store.storeViewController() else {
            return
        }

        self.present(storeVC, animated: true, completion: nil)
    }
}

// MARK: - Recover Password View Controller Delegate
extension LoginViewController: RecoverPasswordDelegate {
    func recoverEmailSend() {
        self.showSuccessMessage(title: R.string.commons.success(), message: R.string.login.reset_password_success_message())
    }
}
