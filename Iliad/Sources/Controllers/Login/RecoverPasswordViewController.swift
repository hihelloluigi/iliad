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

class RecoverPasswordViewController: BaseViewController {

    // MARK: - Outlets
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

    // MARK: - Variables
    var forgetUsername: Bool = false
    let notification = UINotificationFeedbackGenerator()

    // MARK: - Delegate
    weak var delegate: RecoverPasswordDelegate?

    // MARK: - Life Cycle
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

    // MARK: - Setup
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
        customNavigationBar.hideShadowBar()
    }

    private func configurationText() {
        titleLabel.text = R.string.recoverPassword.title()
        subtitleLabel.text = R.string.recoverPassword.subtitle()
        recoverButton.setTitle(R.string.recoverPassword.recover_button(), for: .normal)
        cancelBarButton.title = R.string.commons.cancel()
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
            firstTextField.placeholder = R.string.recoverPassword.name_placeholder()
            firstTextField.textContentType = .name

            // Second
            secondTextField.placeholder = R.string.recoverPassword.surname_placeholder()
            secondTextField.textContentType = .name

            // Third
            thirdTextField.placeholder = R.string.recoverPassword.email_placeholder()
            thirdTextField.textContentType = .emailAddress
            thirdTextField.keyboardType = .emailAddress
            thirdTextField.isHidden = false

            forgetUsernameButton.setTitle(R.string.recoverPassword.know_username(), for: .normal)
        } else {
            // First
            firstTextField.placeholder = R.string.recoverPassword.username_placeholder()
            firstTextField.keyboardType = .numberPad

            // Second
            secondTextField.placeholder = R.string.recoverPassword.email_placeholder()
            secondTextField.textContentType = .emailAddress
            secondTextField.keyboardType = .emailAddress

            // Third
            thirdTextField.isHidden = true

            forgetUsernameButton.setTitle(R.string.recoverPassword.missing_username(), for: .normal)
        }
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
                self.showError(title: R.string.commons.error(), message: R.string.recoverPassword.reset_password_error_message())
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
                self.showError(title: R.string.commons.error(), message: R.string.recoverPassword.reset_password_error_message())
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
            showTextFieldError(textField: firstTextField, error: forgetUsername ? R.string.recoverPassword.name_textfield_error() :
                R.string.recoverPassword.username_textfield_error())
            return
        }
        firstTextField.errorMessage = nil

        guard !secondValue.isEmpty else {
            showTextFieldError(textField: secondTextField, error: forgetUsername ? R.string.recoverPassword.surname_textfield_error() : R.string.recoverPassword.email_textfield_error())
            return
        }

        if forgetUsername {
            if let thirdValue = thirdTextField.text, thirdValue.isEmpty {
                guard Utility.isValidEmail(testStr: thirdValue) else {
                    showTextFieldError(textField: secondTextField, error: R.string.recoverPassword.email_format_textfield_error())
                    return
                }
                forgetUsernameRecoverPassword(name: firstValue, surname: secondValue, email: thirdValue)
            } else {
                showTextFieldError(textField: thirdTextField, error: R.string.recoverPassword.email_textfield_error())
            }
        } else {
            guard Utility.isValidEmail(testStr: secondValue) else {
                showTextFieldError(textField: secondTextField, error: R.string.recoverPassword.email_format_textfield_error())
                return
            }
            secondTextField.errorMessage = nil
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
