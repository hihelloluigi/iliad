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

    // Mark - Helpers
    #if DEV
    private func autoFill() {
        // VERY IMPORTANT: If you want to run the app with DEV target you have to insert a file called Credentials.swift with default varibles
        firstTextField.text = Credentials.username
        secondTextField.text = Credentials.email
    }
    #endif

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

    // Mark - APIs
    private func recoverPassword(username: String, email: String, token: String) {
        recoverButton.startAnimation()
        API.RecoverPasswordClass.recoverPassword(username: username, email: email) { (success) in
            self.recoverButton.stopAnimation()
            guard success else {
                self.showErrorMessage(title: "Commons" ~> "ERROR", message: "RecoverPassword" ~> "RESET_PASSWORD_ERROR_MESSAGE")
                return
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.recoverEmailSend()
            })
        }
    }

    private func forgetUsernameRecoverPassword(name: String, surname: String, email: String, token: String) {
        recoverButton.startAnimation()
        API.RecoverPasswordClass.recoverPasswordForgetUsername(name: name, surname: surname, email: email) { (success) in
            self.recoverButton.stopAnimation()
            guard success else {
                self.showErrorMessage(title: "Commons" ~> "ERROR", message: "RecoverPassword" ~> "RESET_PASSWORD_ERROR_MESSAGE")
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
            let secondValue = secondTextField.text,
            let token = Config.token()
        else {
            return
        }

        if firstValue.isEmpty {
            firstTextField.errorMessage = forgetUsername ? "RecoverPassword" ~> "NAME_TEXTFIELD_ERROR" : "RecoverPassword" ~> "USERNAME_TEXTFIELD_ERROR"
            return
        } else {
            firstTextField.errorMessage = nil
        }

        if secondValue.isEmpty {
            secondTextField.errorMessage = forgetUsername ? "RecoverPassword" ~> "SURNAME_TEXTFIELD_ERROR" : "RecoverPassword" ~> "EMAIL_TEXTFIELD_ERROR"
            return
        } else {
            secondTextField.errorMessage = nil
        }

        if forgetUsername {
            if let thirdValue = thirdTextField.text, thirdValue.isEmpty {
                forgetUsernameRecoverPassword(name: firstValue, surname: secondValue, email: thirdValue, token: token)
            } else {
                thirdTextField.errorMessage = "RecoverPassword" ~> "EMAIL_TEXTFIELD_ERROR"
            }
        } else {
            recoverPassword(username: firstValue, email: secondValue, token: token)
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
