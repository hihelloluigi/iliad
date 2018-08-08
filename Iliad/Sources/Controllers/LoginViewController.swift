//
//  LoginViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    // Mark - Outlets
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
    @IBOutlet weak var forgotPasswordButton: UIButton!

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        #if DEV
            autoLogin()
        #endif
    }

    // Mark - Helpers
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    private func autoLogin() {
        usernameTextField.text = Credentials.username
        passwordTextField.text = Credentials.password
    }

    // Mark - APIs
    private func getToken(username: String, password: String) {
        API.LoginClass.getToken(username: username, password: password) { (token, success) in
            guard success, let token = token else {
                return
            }
            print(token)
        }
    }
    // Mark - Actions
    @IBAction func loginDidTap(_ sender: Any) {
        guard
            let usernameText = usernameTextField.text,
            let passwordText = passwordTextField.text,
            !usernameText.isEmpty,
            !passwordText.isEmpty
        else {
            return
        }
        getToken(username: usernameText, password: passwordText)
    }

    @IBAction func forgotPasswordDidTap(_ sender: Any) {
    }
}
