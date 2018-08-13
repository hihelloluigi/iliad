//
//  API+Credit.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation

extension API {
    class CreditClass {
        class func getNationalCredit(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getNationalCredit) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }

        class func getAbroudCredit(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getAbroudCredit) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }
    }
}
