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
    @IBOutlet weak var loginButton: CustomButton!

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
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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

    private func autoFill() {
        usernameTextField.text = Credentials.username
        passwordTextField.text = Credentials.password
    }

    private func autoLogin() {
        loginDidTap(loginButton)
    }

    private func performLogin(user: User) {
        guard
            let navController = "Home" <%> "NavigationController" as? UINavigationController,
            let homeViewController = navController.viewControllers.first as? HomeViewController
            else {
                return
        }

        homeViewController.user = user
        self.present(navController, animated: true, completion: nil)
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

    // Mark - APIs
    private func getToken(username: String, password: String) {
        API.LoginClass.getToken(username: username, password: password) { (token, success) in
            guard success, let token = token else {
                return
            }

            Config.store(token: token)
            self.login(username: username, password: password, token: token)
        }
    }

    private func login(username: String, password: String, token: String) {
        API.LoginClass.login(username: username, password: password, token: token) { (json) in
            guard let json = json else {
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

        guard !usernameText.isEmpty else {
            
            return
        }
        guard !passwordText.isEmpty else {

            return
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

        self.navigationController?.pushViewController(recoverPasswordVC, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func checkBoxChanged(_ sender: Any) {
        guard let checkBox = sender as? BEMCheckBox else {
            return
        }

        if !checkBox.on {
            Config.removeUsername()
        }
    }
}
