//
//  SettingsViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 17/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import iOSAuthenticator

class SettingsViewController: UITableViewController {

    // Mark - Outlets
        // Switch
    @IBOutlet weak var switchAutoLogin: UISwitch!
    @IBOutlet weak var switchBiometric: UISwitch!

        // Labels
    @IBOutlet weak var autoLoginLabel: UILabel!
    @IBOutlet weak var biometricLabel: UILabel!
    @IBOutlet weak var iliadFirstNumberLabel: UILabel!
    @IBOutlet weak var iliadSecondNumberLabel: UILabel!
        // Image View
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var telegramImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var iliadFirstNumberImageView: UIImageView!
    @IBOutlet weak var iliadSecondNumberImageView: UIImageView!

    // Mark - Varibles
    let paypal = "https://paypal.me/luigiaiello"
    let iliadFirtNumber = "177"
    let iliadSecondNumber = "3518995177"

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupTableView()
        configurationUI()
        configurationText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        switchAutoLogin.isOn = Defaults[.autoLogin]
        switchBiometric.isOn = Defaults[.loginWithBiometric]
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func configurationUI() {
        alertImageView.tintColor = .iliadRed
        beerImageView.tintColor = .iliadRed
        telegramImageView.tintColor = .iliadRed
        emailImageView.tintColor = .iliadRed
        iliadFirstNumberImageView.tintColor = .iliadRed
        iliadSecondNumberImageView.tintColor = .iliadRed

        self.navigationController?.navigationBar.hideShadowBar()
    }

    private func configurationText() {
        autoLoginLabel.text = "Settings" ~> "AUTO_LOGIN"
        biometricLabel.text = "\("Settings" ~> "BIOMETRIC_LOGIN") \(iOSAuthenticator.biometricType())"
    }

    // Mark - Actions
    @IBAction func autoLoginDidChange(_ sender: Any) {
        guard let mySwitch = sender as? UISwitch else {
            return
        }
        Defaults[.autoLogin] = mySwitch.isOn
    }
    @IBAction func biometricDidChange(_ sender: Any) {
        guard let mySwitch = sender as? UISwitch else {
            return
        }

        iOSAuthenticator.authenticateWithBiometricsAndPasscode(reason: "Accedi alla tua area personale", success: {
            Defaults[.loginWithBiometric] = mySwitch.isOn
        }, failure: { (error) in
            print(error)
            mySwitch.isOn = Defaults[.loginWithBiometric]
            Utility.showAlert(title: "Settings" ~> "BIOMETRIC_LOGIN_ERROR_TITLE",
                              message: "\("Settings" ~> "BIOMETRIC_LOGIN_ERROR_MESSAGE") \(mySwitch.isOn ? "Disattivare" : "Attivare") \(iOSAuthenticator.biometricType())")
        })
    }
}

// Mark - Table View Delegate
extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                guard let infoVC = "Login" <%> "InfoViewController" as? InfoViewController else {
                    return
                }

                self.present(infoVC, animated: true, completion: nil)
            case 1:
                Utility.open(url: paypal)
            default:
                print("What?")
            }
        case 2:
            switch indexPath.row {
            case 0:
                Utility.open(url: "tel://\(iliadFirtNumber)")
            case 1:
                Utility.open(url: "tel://\(iliadSecondNumber)")
            default:
                print("What?")
            }
        default:
            break
        }
    }
}
