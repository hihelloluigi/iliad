//
//  File.swift
//  Iliad
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

extension API {
    class LoginClass {
        class func getToken(username: String, password: String, _ completionHandler: RefreshTokenHandler?) {
            API.provider().request(.getToken(username: username, password: password)) { (result) in
                API.response(result, responseHandler: { (response) in
                    guard let response = response else {
                        completionHandler?(nil, false)
                        return
                    }
                    completionHandler?(String(data: response.data, encoding: .utf8), true)
                })
            }
        }

        class func login(username: String, password: String, _ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.login(username: username, password: password)) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }

        class func logout(_ completionHandler: SuccessHandler?) {
            API.provider().request(.logout) { (result) in
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
