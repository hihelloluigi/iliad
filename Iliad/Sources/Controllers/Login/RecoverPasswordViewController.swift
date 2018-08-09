//
//  RecoverPasswordViewController.swift
//  IliadProd
//
//  Created by Luigi Aiello on 09/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RecoverPasswordViewController: UIViewController {

    // Mark - Outlets
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
    @IBOutlet weak var recoverButton: CustomButton!
    @IBOutlet weak var forgetUsernameButton: UIButton!

    // Mark - Variables
    var forgetUsername: Bool = false

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configurationUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // Mark - Setup
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func configurationUI() {
        lockImageView.tintColor = .iliadRed
        changeFormLayout(forgetUsername: forgetUsername)
    }

    // Mark - Helpers
    private func changeFormLayout(forgetUsername: Bool) {
        if forgetUsername {
            // First
            firstTextField.placeholder = "Nome"
            firstTextField.textContentType = .name

            // Second
            secondTextField.placeholder = "Cognome"
            secondTextField.textContentType = .name

            // Third
            thirdTextField.placeholder = "Email"
            thirdTextField.textContentType = .emailAddress
            thirdTextField.keyboardType = .emailAddress
            thirdTextField.isHidden = false

            forgetUsernameButton.setTitle("Conosci il tuo id utente?", for: .normal)
        } else {
            // First
            firstTextField.placeholder = "Username"
            firstTextField.keyboardType = .numberPad

            // Second
            secondTextField.placeholder = "Email"
            secondTextField.textContentType = .emailAddress
            secondTextField.keyboardType = .emailAddress

            // Third
            thirdTextField.isHidden = true

            forgetUsernameButton.setTitle("Non conosci il tuo id utente?", for: .normal)
        }
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    // Mark - APIs
    private func recoverPassword(username: String, email: String, token: String) {
        API.RecoverPasswordClass.recoverPassword(username: username, email: email, token: token) { (success) in
            guard success else {
                return
            }
        }
    }

    private func forgetUsernameRecoverPassword(name: String, surname: String, email: String, token: String) {
        API.RecoverPasswordClass.recoverPasswordForgetUsername(name: name, surname: surname, email: email, token: token) { (success) in
            guard success else {
                return
            }
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

        guard !firstValue.isEmpty else {
            return
        }

        guard !secondValue.isEmpty else {
            return
        }

        if forgetUsername {
            recoverPassword(username: firstValue, email: secondValue, token: token)
        } else if let thirdValue = thirdTextField.text, !thirdValue.isEmpty {
            forgetUsernameRecoverPassword(name: firstValue, surname: secondValue, email: thirdValue, token: token)
        }
    }
    
    @IBAction func forgetUsernameDidTap(_ sender: Any) {
        forgetUsername = !forgetUsername
        changeFormLayout(forgetUsername: forgetUsername)
    }
}
