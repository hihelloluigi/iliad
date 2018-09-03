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

        // Image View
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var telegramImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!

    // Mark - Varibles
    let paypal = "https://paypal.me/luigiaiello"

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
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func configurationUI() {
        alertImageView.tintColor = .iliadRed
        beerImageView.tintColor = .iliadRed
        telegramImageView.tintColor = .iliadRed
        emailImageView.tintColor = .iliadRed

        navigationController?.navigationBar.shadowImage = UIImage()
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

        if mySwitch.isOn {
            iOSAuthenticator.authenticateWithBiometricsAndPasscode(reason: "Accedi alla tua area personale", success: {
                Defaults[.loginWithBiometric] = mySwitch.isOn
            }, failure: { (error) in
                print(error)
                mySwitch.isOn = false
            })
        }
    }
}

// Mark - Table View Delegate
extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else {
            return
        }

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
    }
}
