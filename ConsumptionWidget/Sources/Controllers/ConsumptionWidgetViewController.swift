//
//  TodayViewController.swift
//  ConsumptionWidget
//
//  Created by Luigi Aiello on 03/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import NotificationCenter

class ConsumptionWidgetViewController: UIViewController, NCWidgetProviding {

    // Mark - Outlets
    @IBOutlet weak var callsLabel: UILabel!
    @IBOutlet weak var callsImageView: UIImageView!

    @IBOutlet weak var SMSLabel: UILabel!
    @IBOutlet weak var SMSImageView: UIImageView!

    @IBOutlet weak var MMSLabel: UILabel!
    @IBOutlet weak var MMSImageView: UIImageView!

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataImageView: UIImageView!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var loginButton: CustomButton!

    // Mark - Variables
    let userDefaults = UserDefaults(suiteName: "group.com.luigiaiello.consumptionWidget")
    let mainApp: String = "areapersonale://"

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationUI()
        configurationText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        guard
            let loginSuccessful = userDefaults?.value(forKey: "kLoginSuccessful") as? Bool,
            loginSuccessful
        else {
            showLoginMessage()
            completionHandler(NCUpdateResult.failed)
            return
        }
        loginButton.isHidden = true
        guard updateData() else {
            completionHandler(NCUpdateResult.noData)
            return
        }
        stackView.isHidden = false
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }

    // Mark - Setup
    private func configurationUI() {
        callsImageView.tintColor = .iliadRed
        SMSImageView.tintColor = .iliadRed
        MMSImageView.tintColor = .iliadRed
        dataImageView.tintColor = .iliadRed
    }
    private func configurationText() {
        loginButton.setTitle("Extension" ~> "LOGIN_BUTTON", for: .normal)
        callsLabel.text = "--"
        SMSLabel.text = "--"
        MMSLabel.text = "--"
        dataLabel.text = "--"
    }

    // Mark - Helpers
    private func showLoginMessage() {
        stackView.isHidden = true
        loginButton.isHidden = false
    }

    private func updateData() -> Bool {
        guard
            let calls = userDefaults?.value(forKey: "kCalls") as? String,
            let SMS = userDefaults?.value(forKey: "kSMS") as? String,
            let MMS = userDefaults?.value(forKey: "kMMS") as? String,
            let data = userDefaults?.value(forKey: "kData") as? String
        else {
            return false
        }
        callsLabel.text = calls
        SMSLabel.text = SMS
        MMSLabel.text = MMS
        dataLabel.text = data

        return true
    }

    // Mark - Actions
    @IBAction func loginDidTap(_ sender: Any) {
        guard let url = URL(string: mainApp) else {
            return
        }

        extensionContext?.open(url, completionHandler: { (success) in
            print(success)
        })
    }
}
