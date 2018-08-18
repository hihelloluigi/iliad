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

    // Mark - Init
    init(calls: String?,
         extraCalls: String?,
         sms: String?,
         extraSMS: String?,
         mms: String?,
         extraMMS: String?,
         data: String?,
         maxData: String?,
         extraData: String?) {

        self.calls = calls
        self.extraCalls = extraCalls
        self.sms = sms
        self.extraSMS = extraSMS
        self.mms = mms
        self.extraMMS = extraMMS
        self.data = data
        self.extraData = extraData
    }

    init(json: JSON) {
        self.calls = json["1"]["0"].string
        self.extraCalls = json["1"]["1"].string
        self.sms = json["2"]["0"].string
        self.extraSMS = json["2"]["1"].string
        self.data = json["3"]["0"].string
        self.extraData = json["3"]["1"].string
        self.mms = json["4"]["0"].string
        self.extraMMS = json["4"]["1"].string
    }
}
