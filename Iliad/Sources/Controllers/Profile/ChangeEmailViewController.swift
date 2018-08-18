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

    // Mark - Variables
    let notification = UINotificationFeedbackGenerator()

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

    private func showError(title: String, message: String) {
        self.changeEmailButton.stopAnimation(animationStyle: .normal) {
            self.showErrorMessage(title: title, message: message)
            self.view.isUserInteractionEnabled = true
            self.notification.notificationOccurred(.error)
        }
    }

    private func showTextFieldError(textField: SkyFloatingLabelTextField, error: String) {
        textField.errorMessage = error
        notification.notificationOccurred(.error)
    }

    // Mark - APIs
    private func changeEmail(email: String, emailConfirmation: String, password: String) {
        changeEmailButton.startAnimation()
        self.view.isUserInteractionEnabled = false

        API.InformationClass.changeEmail(email: email, emailConfirm: emailConfirmation, password: password) { (success) in
            guard success else {
                self.showError(title: "Commons" ~> "ERROR", message: "ChangeEmail" ~> "CHANGE_EMAIL_ERROR")
                return
            }

            self.changeEmailButton.stopAnimation()
            self.view.isUserInteractionEnabled = true
            
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

        guard !emailText.isEmpty else {
            showTextFieldError(textField: emailTextField, error: "ChangeEmail" ~> "EMAIL_TEXTFIELD_ERROR")
            return
        }
        guard Utility.isValidEmail(testStr: emailText) else {
            showTextFieldError(textField: emailTextField, error: "RecoverPassword" ~> "EMAIL_FORMAT_TEXTFIELD_ERROR")
            return
        }
        emailTextField.errorMessage = nil

        guard !emailConfirmationText.isEmpty else {
            showTextFieldError(textField: emailConfirmationTextField, error: "ChangeEmail" ~> "EMAIL_CONFIRMATION_TEXTFIELD_ERROR")
            return
        }
        guard Utility.isValidEmail(testStr: emailConfirmationText) else {
            showTextFieldError(textField: emailConfirmationTextField, error: "RecoverPassword" ~> "EMAIL_FORMAT_TEXTFIELD_ERROR")
            return
        }
        emailConfirmationTextField.errorMessage = nil

        guard !passwordText.isEmpty else {
            showTextFieldError(textField: passwordTextField, error: "ChangeEmail" ~> "PASSWORD_TEXTFIELD_ERROR")
            return
        }
        passwordTextField.errorMessage = nil

        guard emailText == emailConfirmationText else {
            showTextFieldError(textField: emailConfirmationTextField, error: "ChangeEmail" ~> "EMAIL_DIFFERENT_ERROR")
            return
        }

        let passwordBase64 = passwordText.toBase64()
        guard let password = Config.password(), passwordBase64 == password else {
            self.showErrorMessage(title: "Commons" ~> "ERROR", message: "ChangeEmail" ~> "WRONG_ACTUAL_PASSWORD_ERROR_MESSAGE")
            return
        }
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
