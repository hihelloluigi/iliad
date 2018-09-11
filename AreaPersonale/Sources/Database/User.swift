//
//  User.swift
//  Iliad
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {

    // Mark - Property
    var id: String?
    var name: String?
    var phoneNumber: String?
    var isSimActive: Bool?
    var credit: String?
    var renewal: Date?
    var email: String?

    // Mark - Init
    init(id: String?,
         name: String?,
         phoneNumber: String?,
         isSimActive: Bool,
         credit: String?,
         renewal: Date?,
         email: String?) {
        
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.isSimActive = isSimActive
        self.credit = credit
        self.renewal = renewal
        self.email = email
    }

    init(json: JSON) {
        self.id = json["user_id"].string
        self.name = json["user_name"].string
        self.phoneNumber = json["user_numtell"].string
        self.isSimActive = json["sim"].string?.toBool()
    }
}
