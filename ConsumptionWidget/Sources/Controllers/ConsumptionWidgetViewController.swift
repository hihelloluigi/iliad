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
    @IBOutlet weak var SMSLabel: UILabel!
    @IBOutlet weak var MMSLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!

    // Mark - Variables
    let userDefaults = UserDefaults(suiteName: "group.com.luigiaiello.consumptionWidget")

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = updateData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        guard updateData() else {
            completionHandler(NCUpdateResult.noData)
            return
        }
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }

    // Mark - Helpers
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
}
