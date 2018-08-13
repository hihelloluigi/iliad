//
//  Consumption.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation
import SwiftyJSON

class Consumption {

    // Mark - Property
    var calls: String?
    var extraCalls: String?
    var sms: String?
    var extraSMS: String?
    var mms: String?
    var extraMMS: String?
    var data: String?
    var maxData: String?
    var extraData: String?
    var credit: String?
    var renewal: Date?

    // Mark - Init
    init(calls: String?,
         extraCalls: String?,
         sms: String?,
         extraSMS: String?,
         mms: String?,
         extraMMS: String?,
         data: String?,
         maxData: String?,
         extraData: String?,
         credit: String?,
         renewal: String?) {

        self.calls = calls
        self.extraCalls = extraCalls
        self.sms = sms
        self.extraSMS = extraSMS
        self.mms = mms
        self.extraMMS = extraMMS
        self.data = credit
        self.extraData = extraData
        self.credit = credit

        if let renewal = renewal {
            self.renewal = Date.from(string: renewal, withFormat: "dd/MM/yyyy")
        }
    }

    init(json: JSON) {
        self.calls = json["iliad"]["1"]["0"].string
        self.extraCalls = json["iliad"]["1"]["1"].string
        self.sms = json["iliad"]["2"]["0"].string
        self.extraCalls = json["iliad"]["2"]["1"].string
        self.data = json["iliad"]["3"]["0"].string
        self.extraData = json["iliad"]["3"]["1"].string
        self.mms = json["iliad"]["4"]["0"].string
        self.extraMMS = json["iliad"]["4"]["1"].string
        let creditRenewal = json["iliad"]["0"]["0"].string?.components(separatedBy: "&")
        self.credit = creditRenewal?[0]
        if let stringDate = creditRenewal?[1] {
            self.renewal = Date.from(string: stringDate, withFormat: "dd/MM/yyyy")
        }
    }
}
