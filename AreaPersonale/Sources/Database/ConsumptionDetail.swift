//
//  ConsumptionDetail.swift
//  Iliad
//
//  Created by Luigi Aiello on 29/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation
import SwiftyJSON
class ConsumptionDetail {
    var country: String?
    var type: String?
    var phoneNumber: String?
    var date: String?
    var volume: String?
    var price: String?

    init(json: JSON) {
        self.country = json["0"].string
        self.type = json["1"].string
        if let text = json["2"].string, let phoneNumber = json["3"].string {
            self.phoneNumber = "\(text): \(phoneNumber)"
        }
        self.date = json["4"].string
        self.volume = json["5"].string
        self.price = json["6"].string
    }
}
