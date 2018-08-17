//
//  ProfileViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!

    // Profile
    @IBOutlet weak var profileViewContainer: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profilePhoneNumberLabel: UILabel!

    // Credit
    @IBOutlet weak var creditViewContainer: UIView!
    @IBOutlet weak var creditImage: UIImageView!
    @IBOutlet weak var creditAvailableLabel: UILabel!
    @IBOutlet weak var creditRenewalLabel: UILabel!
    @IBOutlet weak var creditIdCodeLabel: UILabel!

    // Email
    @IBOutlet weak var emailViewContainer: UIView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var emailArrow: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!

    // Password
    @IBOutlet weak var passwordViewContainer: UIView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var passwordArrow: UIImageView!
    @IBOutlet weak var passwordLabel: UILabel!

    // Puk
    @IBOutlet weak var pukViewContainer: UIView!
    @IBOutlet weak var pukImage: UIImageView!
    @IBOutlet weak var pukArrow: UIImageView!
    @IBOutlet weak var pukLabel: UILabel!

    // Mark - User
    var user: User?

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotification()
        configurationUI()
        fillElements()
        addGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.contentSize = self.stackView.frame.size
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile(_:)), name: Notification.Name("profile"), object: nil)
    }

    private func configurationUI() {
        profileImage.tintColor = .iliadRed
        creditImage.tintColor = .white
        emailImage.tintColor = .white
        emailArrow.tintColor = .white
        passwordImage.tintColor = .white
        passwordArrow.tintColor = .white
        pukImage.tintColor = .white
        pukArrow.tintColor = .white
    }

    private func fillElements() {
        guard let user = user else {
            return
        }
        profileNameLabel.text = user.name
        profilePhoneNumberLabel.text = user.phoneNumber
        creditIdCodeLabel.text = user.id

        if let dateFormatted = user.renewal?.localizedString(dateWithStyle: .medium) {
            creditRenewalLabel.isHidden = false
            creditRenewalLabel.text = "Prossimo rinnovo: \(dateFormatted)"
        } else {
            creditRenewalLabel.isHidden = true
        }
        if let credit = user.credit {
            creditAvailableLabel.isHidden = false
            creditAvailableLabel.text = "Credito disponibile: \(credit)"
        } else {
            creditAvailableLabel.isHidden = true
        }
    }

    private func addGestures() {
        let changeEmailGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeEmail(_:)))
        emailViewContainer.addGestureRecognizer(changeEmailGesture)

        let changePasswordGesture = UITapGestureRecognizer(target: self, action: #selector(self.changePassword(_:)))
        passwordViewContainer.addGestureRecognizer(changePasswordGesture)

        let showPukGesture = UITapGestureRecognizer(target: self, action: #selector(self.showPuk(_:)))
        pukViewContainer.addGestureRecognizer(showPukGesture)
    }

    // Mark - Notifications
    @objc func updateProfile(_ notification: Notification) {
        guard let user = notification.userInfo?["user"] as? User else {
            return
        }
        self.user = user
        fillElements()
    }

    // Mark - APIs
    private func logout() {
        API.LoginClass.logout { (success) in
            guard success else {
                print("Impossible to do logout")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    // Mark - Gesture
    @objc func changeEmail(_ sender: UITapGestureRecognizer) {
        guard let changeEmailVC = "Profile" <%> "ChangeEmailViewController" as? ChangeEmailViewController else {
            return
        }

        changeEmailVC.delegate = self
        changeEmailVC.modalTransitionStyle = .crossDissolve
        self.present(changeEmailVC, animated: true, completion: nil)
    }

    @objc func changePassword(_ sender: UITapGestureRecognizer) {
        guard let changePasswordVC = "Profile" <%> "ChangePasswordViewController" as? ChangePasswordViewController else {
            return
        }

        changePasswordVC.delegate = self
        changePasswordVC.modalTransitionStyle = .crossDissolve
        self.present(changePasswordVC, animated: true, completion: nil)
    }
    
    @objc func showPuk(_ sender: UITapGestureRecognizer) {
        guard let showPuk = "Profile" <%> "ShowPukViewController" as? ShowPukViewController else {
            return
        }

        showPuk.modalTransitionStyle = .crossDissolve
        self.present(showPuk, animated: true, completion: nil)
    }

    // Mark - Actions
    @IBAction func settingsDidTap(_ sender: Any) {
    }
    @IBAction func logoutDidTap(_ sender: Any) {
        logout()
    }
}

// Mark - Change Email View Controller Delegate
extension ProfileViewController: ChangeEmailDelegate {
    func changeEmailSucess(_ email: String) {
        self.emailLabel.text = email
        self.showSuccessMessage(title: "Commons" ~> "SUCCESS", message: "ChangeEmail" ~> "CHANGE_EMAIL_SUCCESS_MESSAGE")
    }
}

// Mark - Change Password View Controller Delegate
extension ProfileViewController: ChangePasswordDelegate {
    func changePasswordSucess() {
        self.showSuccessMessage(title: "Commons" ~> "SUCCESS", message: "ChangePassword" ~> "CHANGE_PASSWORD_SUCCESS_MESSAGE")
    }
}
