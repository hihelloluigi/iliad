//
//  RecoverPasswordViewController.swift
//  IliadProd
//
//  Created by Luigi Aiello on 09/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import TransitionButton

protocol RecoverPasswordDelegate: NSObjectProtocol {
    func recoverEmailSend()
}

class RecoverPasswordViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldsStackView: UIStackView!

        // Image Views
    @IBOutlet weak var lockImageView: UIImageView!

        // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

        // Text Views
    @IBOutlet weak var firstTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var secondTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var thirdTextField: SkyFloatingLabelTextField!

        // Buttons
    @IBOutlet weak var recoverButton: TransitionButton!
    @IBOutlet weak var forgetUsernameButton: UIButton!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    // Mark - Variables
    var forgetUsername: Bool = false
    let notification = UINotificationFeedbackGenerator()

    // Mark - Delegate
    weak var delegate: RecoverPasswordDelegate?

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.contentSize = self.textFieldsStackView.frame.size
    }

    // Mark - Setup
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self

        #if DEV
//            autoFill()
        #endif
    }
    
    private func configurationUI() {
        lockImageView.tintColor = .iliadRed
        changeFormLayout(forgetUsername: forgetUsername)
        customNavigationBar.shadowImage = UIImage()
    }

    private func configurationText() {
        titleLabel.text = "RecoverPassword" ~> "TITLE"
        subtitleLabel.text = "RecoverPassword" ~> "SUBTITLE"
        recoverButton.setTitle("RecoverPassword" ~> "RECOVER_BUTTON", for: .normal)
        cancelBarButton.title = "Commons" ~> "CANCEL"
    }

    // Mark - Helpers Dev
    #if DEV
    private func autoFill() {
        firstTextField.text = Credentials.username
        secondTextField.text = Credentials.email
    }
    #endif

    // Mark - Helpers
    private func changeFormLayout(forgetUsername: Bool) {
        if forgetUsername {
            // First
            firstTextField.placeholder = "RecoverPassword" ~> "NAME_PLACEHOLDER"
            firstTextField.textContentType = .name

            // Second
            secondTextField.placeholder = "RecoverPassword" ~> "SURNAME_PLACEHOLDER"
            secondTextField.textContentType = .name

            // Third
            thirdTextField.placeholder = "RecoverPassword" ~> "EMAIL_PLACEHOLDER"
            thirdTextField.textContentType = .emailAddress
            thirdTextField.keyboardType = .emailAddress
            thirdTextField.isHidden = false

            forgetUsernameButton.setTitle("RecoverPassword" ~> "KNOWN_USERNAME", for: .normal)
        } else {
            // First
            firstTextField.placeholder = "RecoverPassword" ~> "USERNAME_PLACEHOLDER"
            firstTextField.keyboardType = .numberPad

            // Second
            secondTextField.placeholder = "RecoverPassword" ~> "EMAIL_PLACEHOLDER"
            secondTextField.textContentType = .emailAddress
            secondTextField.keyboardType = .emailAddress

            // Third
            thirdTextField.isHidden = true

            forgetUsernameButton.setTitle("RecoverPassword" ~> "MISSING_USERNAME", for: .normal)
        }
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func showError() {
        showError()
    }
    private func showError(title: String, message: String) {
        self.recoverButton.stopAnimation(animationStyle: .normal) {
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
    private func recoverPassword(username: String, email: String) {
        recoverButton.startAnimation()
        view.isUserInteractionEnabled = false

        API.RecoverPasswordClass.recoverPassword(username: username, email: email) { (success) in
            self.recoverButton.stopAnimation()
            guard success else {
                self.showError(title: "Commons" ~> "ERROR", message: "RecoverPassword" ~> "RESET_PASSWORD_ERROR_MESSAGE")
                return
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.recoverEmailSend()
            })
        }
    }

    private func forgetUsernameRecoverPassword(name: String, surname: String, email: String) {
        recoverButton.startAnimation()
        view.isUserInteractionEnabled = false

        API.RecoverPasswordClass.recoverPasswordForgetUsername(name: name, surname: surname, email: email) { (success) in
            self.recoverButton.stopAnimation()
            guard success else {
                self.showError(title: "Commons" ~> "ERROR", message: "RecoverPassword" ~> "RESET_PASSWORD_ERROR_MESSAGE")
                return
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.recoverEmailSend()
            })
        }
    }

    // Mark - Actions
    @IBAction func recoverDidTap(_ sender: Any) {
        guard
            let firstValue = firstTextField.text,
            let secondValue = secondTextField.text
        else {
            return
        }

        guard !firstValue.isEmpty else {
            showTextFieldError(textField: firstTextField, error: forgetUsername ? "RecoverPassword" ~> "NAME_TEXTFIELD_ERROR" :
                "RecoverPassword" ~> "USERNAME_TEXTFIELD_ERROR")
            return
        }
        firstTextField.errorMessage = nil

        guard !secondValue.isEmpty else {
            showTextFieldError(textField: secondTextField, error: forgetUsername ? "RecoverPassword" ~> "SURNAME_TEXTFIELD_ERROR" :
                                                                                "RecoverPassword" ~> "EMAIL_TEXTFIELD_ERROR")
            return
        }
        guard Utility.isValidEmail(testStr: secondValue) else {
            showTextFieldError(textField: secondTextField, error: "RecoverPassword" ~> "EMAIL_FORMAT_TEXTFIELD_ERROR")
            return
        }
        secondTextField.errorMessage = nil

        if forgetUsername {
            if let thirdValue = thirdTextField.text, thirdValue.isEmpty {
                guard Utility.isValidEmail(testStr: thirdValue) else {
                    showTextFieldError(textField: secondTextField, error: "RecoverPassword" ~> "EMAIL_FORMAT_TEXTFIELD_ERROR")
                    return
                }
                forgetUsernameRecoverPassword(name: firstValue, surname: secondValue, email: thirdValue)
            } else {
                showTextFieldError(textField: thirdTextField, error: "RecoverPassword" ~> "EMAIL_TEXTFIELD_ERROR")
            }
        } else {
            recoverPassword(username: firstValue, email: secondValue)
        }
    }
    
    @IBAction func forgetUsernameDidTap(_ sender: Any) {
        forgetUsername = !forgetUsername
        changeFormLayout(forgetUsername: forgetUsername)
    }

    @IBAction func cancelDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Mark - Text Field Delegate
extension RecoverPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField else {
            textField.resignFirstResponder()
            return true
        }

        nextField.becomeFirstResponder()

        return false
    }
}
