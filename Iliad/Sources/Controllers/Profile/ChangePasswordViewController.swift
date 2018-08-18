//
//  ChangePasswordViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 16/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import TransitionButton

protocol ChangePasswordDelegate: NSObjectProtocol {
    func changePasswordSucess()
}

class ChangePasswordViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var customNavigationBar: UINavigationBar!

        // Image Views
    @IBOutlet weak var passwordImageView: UIImageView!

        // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

        // Text Views
    @IBOutlet weak var newPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordConfirmationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var actualPasswordTextField: SkyFloatingLabelTextField!

        // Buttons
    @IBOutlet weak var changePasswordButton: TransitionButton!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    // Mark - Variables
    let notification = UINotificationFeedbackGenerator()

    // Mark - Delegate
    weak var delegate: ChangePasswordDelegate?

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

        newPasswordTextField.delegate = self
        newPasswordConfirmationTextField.delegate = self
        actualPasswordTextField.delegate = self
    }

    private func configurationUI() {
        passwordImageView.tintColor = .iliadRed
        customNavigationBar.shadowImage = UIImage()
    }

    private func configurationText() {
        titleLabel.text = "ChangePassword" ~> "TITLE"
        subtitleLabel.text = "ChangePassword" ~> "SUBTITLE"
        newPasswordTextField.placeholder = "ChangePassword" ~> "NEW_PASSWORD_PLACEHOLDER"
        newPasswordConfirmationTextField.placeholder = "ChangePassword" ~> "NEW_PASSWORD_CONFIRMATION_PLACEHOLDER"
        actualPasswordTextField.placeholder = "ChangePassword" ~> "ACTUAL_PASSWORD_PLACEHOLDER"
        changePasswordButton.setTitle("ChangePassword" ~> "CHANGE_PASSWORD_BUTTON", for: .normal)
        cancelBarButton.title = "Commons" ~> "CANCEL"
    }

    // Mark - Helpers
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func showError(title: String, message: String) {
        self.changePasswordButton.stopAnimation(animationStyle: .normal) {
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
    private func changePassword(newPassword: String, newPasswordConfirmation: String, actualPassword: String) {
        changePasswordButton.startAnimation()
        self.view.isUserInteractionEnabled = false

        API.InformationClass.changePassword(newPassword: newPassword, newPasswordConfirm: newPasswordConfirmation, actualPassword: actualPassword) { (success) in
            guard success else {
                self.showError(title: "Commons" ~> "ERROR", message: "ChangePassword" ~> "CHANGE_PASSWORD_ERROR")
                return
            }
            self.changePasswordButton.stopAnimation()
            self.view.isUserInteractionEnabled = true

            self.dismiss(animated: true, completion: {
                self.delegate?.changePasswordSucess()
            })
        }
    }

    // Mark - Actions
    @IBAction func changePasswordDidTap(_ sender: Any) {
        guard
            let newPasswordText = newPasswordTextField.text,
            let newPasswordConfirmationText = newPasswordConfirmationTextField.text,
            let actualPasswordText = actualPasswordTextField.text
        else {
            return
        }

        guard !newPasswordText.isEmpty else {
            showTextFieldError(textField: newPasswordTextField, error: "ChangePassword" ~> "NEW_PASSWORD_TEXTFIELD_ERROR")
            return
        }
        newPasswordTextField.errorMessage = nil

        guard !newPasswordConfirmationText.isEmpty else {
            showTextFieldError(textField: newPasswordConfirmationTextField, error: "ChangePassword" ~> "NEW_PASSWORD_CONFIRMATION_TEXTFIELD_ERROR")
            return
        }
        newPasswordConfirmationTextField.errorMessage = nil

        guard !actualPasswordText.isEmpty else {
            showTextFieldError(textField: actualPasswordTextField, error: "ChangePassword" ~> "ACTUAL_PASSWORD_TEXTFIELD_ERROR")
            return
        }
        actualPasswordTextField.errorMessage = nil

        guard newPasswordText == newPasswordConfirmationText else {
            showTextFieldError(textField: newPasswordConfirmationTextField, error: "ChangePassword" ~> "PASSWORD_DIFFERENT_ERROR")
            return
        }

        let newPasswordBase64 = newPasswordText.toBase64()
        let newPasswordConfirmationBase64 = newPasswordConfirmationText.toBase64()
        let actualPasswordBase64 = actualPasswordText.toBase64()

        guard let password = Config.password(), actualPasswordBase64 == password else {
            self.showErrorMessage(title: "Commons" ~> "ERROR", message: "ChangePassword" ~> "WRONG_ACTUAL_PASSWORD_ERROR_MESSAGE")
            return
        }

        changePassword(newPassword: newPasswordBase64, newPasswordConfirmation: newPasswordConfirmationBase64, actualPassword: actualPasswordBase64)
    }

    @IBAction func cancelDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Mark - Text Field Delegate
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField else {
            textField.resignFirstResponder()
            return true
        }

        nextField.becomeFirstResponder()

        return false
    }
}
