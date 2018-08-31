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

class LoginViewController: UIViewController {

    // Mark - Outlets
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

    // Mark - Variables
    var showPasswordButton: UIButton?
    let notification = UINotificationFeedbackGenerator()

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configurationUI()
        configurationText()
        recoverUsername()
        loginWithBiometric()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.scrollView.contentSize = self.fieldsStackView.frame.size
    }

    // Mark - Segue
    private func performLogin(user: User) {
        guard
            let tabBarController = "Main" <%> "MainTabBarController" as? MainTabBarController,
            let homeVC = tabBarController.viewControllers?.first as? HomeViewController,
            let navigationController = tabBarController.viewControllers?.last as? UINavigationController,
            let profileVC = navigationController.viewControllers.first as? ProfileViewController
        else {
            return
        }

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
    
    // Mark - Setup
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        usernameTextField.delegate = self
        passwordTextField.delegate = self

        #if DEV
            autoFill()
            autoLogin()
        #endif
    }

    private func configurationUI() {
        passwordTextField.rightView = createShowPasswordButton()
        passwordTextField.rightViewMode = .always

        logoImageView.tintColor = .iliadRed
        customNavigationBar.shadowImage = UIImage()
    }

    private func configurationText() {
        titleLabel.text = "Login" ~> "TITLE"
        subtitleLabel.text = "Login" ~> "SUBTITLE"
        usernameTextField.placeholder = "Login" ~> "USERNAME_PLACEHOLDER"
        passwordTextField.placeholder = "Login" ~> "PASSWORD_PLACEHOLDER"
        savePasswordLabel.text = "Login" ~> "SAVE_USERNAME"
        loginButton.setTitle("Login" ~> "LOGIN_BUTTON", for: .normal)
        forgotButton.setTitle("Login" ~> "FOROT_PASSWORD_BUTTON", for: .normal)
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

    // Mark - Helpers Dev
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
    
    // Mark - APIs
    private func getToken(username: String, password: String) {
        loginButton.startAnimation()
        view.isUserInteractionEnabled = false

        API.LoginClass.getToken(username: username, password: password) { (token, success) in
            guard success, let token = token else {
                self.showError(title: "Commons" ~> "ERROR", message: "Login" ~> "LOGIN_ERROR_MESSAGE")
                return
            }

            Config.token = token
            self.login(username: username, password: password)
        }
    }

    private func login(username: String, password: String) {
        API.LoginClass.login(username: username, password: password) { (json) in
            guard let json = json else {
                self.showError(title: "Commons" ~> "ERROR", message: "Login" ~> "LOGIN_ERROR_MESSAGE")
                return
            }

            let user = User(json: json["iliad"])
            self.performLogin(user: user)
        }
    }

    // Mark - Actions
    @IBAction func loginDidTap(_ sender: Any) {
        guard
            let usernameText = usernameTextField.text,
            let passwordText = passwordTextField.text
        else {
            return
        }

        guard !usernameText.isEmpty else {
            showTextFieldError(textField: usernameTextField, error: "Login" ~> "USERNAME_TEXTFIELD_ERROR")
            return
        }
        usernameTextField.errorMessage = nil

        guard !passwordText.isEmpty else {
            showTextFieldError(textField: passwordTextField, error: "Login" ~> "PASSWORD_TEXTFIELD_ERROR")
            return
        }
        passwordTextField.errorMessage = nil

        let passwordBase64 = saveValues(username: usernameText, password: passwordText)

        getToken(username: usernameText, password: passwordBase64)
    }
    
    @IBAction func forgotPasswordDidTap(_ sender: Any) {
        guard let recoverPasswordVC = "Login" <%> "RecoverPasswordViewController" as? RecoverPasswordViewController else {
            return
        }

        recoverPasswordVC.delegate = self
        recoverPasswordVC.modalTransitionStyle = .crossDissolve
        self.present(recoverPasswordVC, animated: true, completion: nil)
    }
    
    @IBAction func checkBoxChanged(_ sender: Any) {
        guard let checkBox = sender as? BEMCheckBox else {
            return
        }

        Defaults[.saveUsername] = checkBox.on
    }

    @IBAction func infoDidTap(_ sender: Any) {
        guard let infoVC = "Login" <%> "InfoViewController" as? InfoViewController else {
            return
        }

        self.present(infoVC, animated: true, completion: nil)
    }
}

// Mark - Text Field Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField else {
            textField.resignFirstResponder()
            return true
        }

        nextField.becomeFirstResponder()

        return false
    }
}

// Mark - Recover Password View Controller Delegate
extension LoginViewController: RecoverPasswordDelegate {
    func recoverEmailSend() {
        self.showSuccessMessage(title: "Commons" ~> "SUCCESS", message: "Login" ~> "RESET_PASSWORD_SUCCESS_MESSAGE")
    }
}
