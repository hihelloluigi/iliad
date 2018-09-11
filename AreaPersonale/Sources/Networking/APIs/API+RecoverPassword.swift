//
//  API+RecoverPassword.swift
//  IliadProd
//
//  Created by Luigi Aiello on 09/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation

extension API {
    class RecoverPasswordClass {
        class func recoverPassword(username: String, email: String, _ completionHandler: SuccessHandler?) {
            API.provider().request(.recoverPassword(username: username, email: email)) { (result) in
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

        class func recoverPasswordForgetUsername(name: String, surname: String, email: String, _ completionHandler: SuccessHandler?) {
            API.provider().request(.recoverPasswordForgetUsername(name: name, surname: surname, email: email)) { (result) in
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
