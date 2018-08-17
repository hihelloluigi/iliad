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

    // Mark - Init
    init(id: String?,
         name: String?,
         phoneNumber: String?,
         isSimActive: Bool) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.isSimActive = isSimActive
    }

    init(json: JSON) {
        self.id = json["user_id"].string
        self.name = json["user_name"].string
        self.phoneNumber = json["user_numtell"].string
        self.isSimActive = json["sim"].bool
    }
}
