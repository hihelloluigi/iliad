//
//  ChangeEmailViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 16/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import TransitionButton

protocol ChangeEmailDelegate: NSObjectProtocol {
    func changeEmailSucess(_ email: String)
}

class ChangeEmailViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    
        // Image Views
    @IBOutlet weak var emailImageView: UIImageView!

        // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

        // Text Views
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailConfirmationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!

        // Buttons
    @IBOutlet weak var changeEmailButton: TransitionButton!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    // Mark - Delegate
    weak var delegate: ChangeEmailDelegate?

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configurationUI()
        configurationText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        emailTextField.delegate = self
        emailConfirmationTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func configurationUI() {
        emailImageView.tintColor = .iliadRed
        customNavigationBar.shadowImage = UIImage()
    }

    private func configurationText() {
        titleLabel.text = "ChangeEmail" ~> "TITLE"
        subtitleLabel.text = "ChangeEmail" ~> "SUBTITLE"
        emailTextField.placeholder = "ChangeEmail" ~> "EMAIL_PLACEHOLDER"
        emailConfirmationTextField.placeholder = "ChangeEmail" ~> "EMAIL_CONFIRMATION_PLACEHOLDER"
        passwordTextField.placeholder = "ChangeEmail" ~> "PASSWORD_PLACEHOLDER"
        changeEmailButton.setTitle("ChangeEmail" ~> "CHANGE_EMAIL_BUTTON", for: .normal)
        cancelBarButton.title = "Commons" ~> "CANCEL"
    }
    
    // Mark - Helpers
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    // Mark - APIs
    private func changeEmail(email: String, emailConfirmation: String, password: String) {
        API.InformationClass.changeEmail(email: email, emailConfirm: emailConfirmation, password: password) { (success) in
            guard success else {
                self.showErrorMessage(title: "Commons" ~> "ERROR", message: "ChangeEmail" ~> "CHANGE_EMAIL_ERROR")
                return
            }

            self.dismiss(animated: true, completion: {
                self.delegate?.changeEmailSucess(email)
            })
        }
    }

    // Mark - Actions
    @IBAction func changeEmailDidTap(_ sender: Any) {
        guard
            let emailText = emailTextField.text,
            let emailConfirmationText = emailConfirmationTextField.text,
            let passwordText = passwordTextField.text
        else {
            return
        }

        if emailText.isEmpty {
            emailTextField.errorMessage = "ChangeEmail" ~> "EMAIL_TEXTFIELD_ERROR"
            return
        } else {
            guard Utility.isValidEmail(testStr: emailText) else {
                emailTextField.errorMessage = "RecoverPassword" ~> "EMAIL_FORMAT_TEXTFIELD_ERROR"
                return
            }
            emailTextField.errorMessage = nil
        }

        if emailConfirmationText.isEmpty {
            emailConfirmationTextField.errorMessage = "ChangeEmail" ~> "EMAIL_CONFIRMATION_TEXTFIELD_ERROR"
            return
        } else {
            guard Utility.isValidEmail(testStr: emailConfirmationText) else {
                emailConfirmationTextField.errorMessage = "RecoverPassword" ~> "EMAIL_FORMAT_TEXTFIELD_ERROR"
                return
            }
            emailConfirmationTextField.errorMessage = nil
        }

        if passwordText.isEmpty {
            passwordTextField.errorMessage = "ChangeEmail" ~> "PASSWORD_TEXTFIELD_ERROR"
            return
        } else {
            passwordTextField.errorMessage = nil
        }

        guard emailText == emailConfirmationText else {
            emailConfirmationTextField.errorMessage = "ChangeEmail" ~> "EMAIL_DIFFERENT_ERROR"
            return
        }

        let passwordBase64 = passwordText.toBase64()
        changeEmail(email: emailText, emailConfirmation: emailConfirmationText, password: passwordBase64)
    }
    
    @IBAction func cancelDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Mark - Text Field Delegate
extension ChangeEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField else {
            textField.resignFirstResponder()
            return true
        }

        nextField.becomeFirstResponder()

        return false
    }
}
