//
//  API+Credit.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation

extension API {
    class ConsumptionClass {
        class func getNationalConsumption(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getNationalConsumption) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }

        class func getAbroudConsumption(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getAbroudConsumption) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }

        class func getConsumptionDetails(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getConsumptionDetails) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }
    }
}
