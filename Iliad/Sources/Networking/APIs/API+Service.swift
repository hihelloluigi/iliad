//
//  API+Services.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation

extension API {
    class ServiceClass {
        class func getServices(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getServices) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }

        class func changeService(activate: Bool, service: String, _ completionHandler: SuccessHandler?) {
            API.provider().request(.changeService(activate: activate, service: service)) { (result) in
                API.responseJson(result, { (json) in
                    guard
                        result.value?.statusCode == 200,
                        let json = json,
                        let result = json["iliad"]["0"].string,
                        let boolResult = result.toBool()
                        else {
                            completionHandler?(false)
                            return
                    }
                    completionHandler?(boolResult)
                })
            }
        }

        class func serviceInfo(service: String, _ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.serviceInfo(service: service)) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }
    }
}
