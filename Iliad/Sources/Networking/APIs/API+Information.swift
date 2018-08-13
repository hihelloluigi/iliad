//
//  API+Informations.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation

extension API {
    class InformationClass {
        class func getGeneralInformations(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getGeneralInformations) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }
        
        class func getPuk(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getPuk) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }

        class func changeEmail(email: String, emailConfirm: String, password: String, _ completionHandler: SuccessHandler?) {
            API.provider().request(.changeEmail(email: email, emailConfirm: emailConfirm, password: password)) { (result) in
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

        class func changePassword(newPassword: String, newPasswordConfirm: String, actualPassword: String, _ completionHandler: SuccessHandler?) {
            API.provider().request(.changePassword(newPassword: newPassword, newPasswordConfirm: newPasswordConfirm, actualPassword: actualPassword)) { (result) in
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
    }
}
