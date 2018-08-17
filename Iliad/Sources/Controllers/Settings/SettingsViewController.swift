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
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func configurationUI() {
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
        Defaults[.loginWithBiometric] = mySwitch.isOn
    }
}
