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
        class func recoverPassword(username: String, email: String, token: String, _ completionHandler: SuccessHandler?) {
            API.provider().request(.recoverPassword(username: username, email: email, token: token)) { (result) in
                API.responseSuccess(result, { (success) in
                    completionHandler?(success)
                })
            }
        }

        class func recoverPasswordForgetUsername(name: String, surname: String, email: String, token: String, _ completionHandler: SuccessHandler?) {
            API.provider().request(.recoverPasswordForgetUsername(name: name, surname: surname, email: email, token: token)) { (result) in
                API.responseSuccess(result, { (success) in
                    completionHandler?(success)
                })
            }
        }
    }
}
