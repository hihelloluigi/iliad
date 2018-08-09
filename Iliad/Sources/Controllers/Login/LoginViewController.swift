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

class LoginViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var checkBox: BEMCheckBox!
    
        // Text fields
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!

        // ImageViews
    @IBOutlet weak var logoImageView: UIImageView!

        // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

        // Buttons
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var infoButton: UIButton!

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configurationUI()
        recoverUsername()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showOnlyBackButton(animated)
    }

    // Mark - Setup
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        #if DEV
            autoFill()
//            autoLogin()
        #endif
    }

    private func configurationUI() {
        passwordTextField.rightView = createShowPasswordButton()
        passwordTextField.rightViewMode = .always

        logoImageView.tintColor = .iliadRed
        infoButton.tintColor = .iliadRed
    }

    private func recoverUsername() {
        guard let username = Config.username() else {
            return
        }
        usernameTextField.text = username
        checkBox.setOn(true, animated: false)
    }

    // Mark - Helpers
    private func showOnlyBackButton(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    #if DEV
    private func autoFill() {
        // VERY IMPORTANT: If you want to run the app with DEV target you have to insert a file called Credentials.swift with default username and password
        usernameTextField.text = Credentials.username
        passwordTextField.text = Credentials.password
    }
    private func autoLogin() {
        loginDidTap(loginButton)
    }
    #endif

    private func performLogin(user: User) {
        guard
            let navController = "Home" <%> "NavigationController" as? UINavigationController,
            let homeViewController = navController.viewControllers.first as? HomeViewController
            else {
                return
        }

        homeViewController.user = user
        view.isUserInteractionEnabled = true

        loginButton.stopAnimation(animationStyle: .expand) {
            self.present(navController, animated: true, completion: nil)
        }
    }

    private func createShowPasswordButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_showPassowrd"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: passwordTextField.frame.height, height: passwordTextField.frame.height)
        button.tintColor = .lightGray
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(showPassword(sender:)))
        button.addGestureRecognizer(longGesture)

        return button
    }

    // TODO - Small delay to fix
    @objc func showPassword(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            passwordTextField.isSecureTextEntry = false
        } else if sender.state == .ended {
            passwordTextField.isSecureTextEntry = true
        }
    }

    private func showError(title: String, message: String) {
        self.loginButton.stopAnimation()
        self.showErrorMessage(title: title, message: message)
        view.isUserInteractionEnabled = true
    }

    // Mark - APIs
    private func getToken(username: String, password: String) {
        loginButton.startAnimation()
        view.isUserInteractionEnabled = false

        API.LoginClass.getToken(username: username, password: password) { (token, success) in
            guard success, let token = token else {
                self.showError(title: "Errore", message: "Impossibile effettuare il login")
                return
            }

            Config.store(token: token)
            self.login(username: username, password: password)
        }
    }

    private func login(username: String, password: String) {
        API.LoginClass.login(username: username, password: password) { (json) in
            guard let json = json else {
                self.showError(title: "Errore", message: "Impossibile effettuare il login")
                return
            }

            let user = User(json: json)
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

        if usernameText.isEmpty {
            usernameTextField.errorMessage = "Inserisci username"
            return
        } else {
            usernameTextField.errorMessage = nil
        }

        if passwordText.isEmpty {
            passwordTextField.errorMessage = "Inserisci password"
            return
        } else {
            passwordTextField.errorMessage = nil
        }

        if checkBox.on {
            Config.store(username: usernameText)
        }

        let passwordBase64 = passwordText.toBase64()
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

        if !checkBox.on {
            Config.removeUsername()
        }
    }

    @IBAction func infoDidTap(_ sender: Any) {
        guard let infoVC = "Login" <%> "InfoViewController" as? InfoViewController else {
            return
        }

        infoVC.modalTransitionStyle = .crossDissolve
        self.present(infoVC, animated: true, completion: nil)
    }
}

extension LoginViewController: RecoverPasswordDelegate {
    func recoverEmailSend() {
        self.showSuccessMessage(title: "Successo", message: "Email di ripristino password inviata")
    }
}
