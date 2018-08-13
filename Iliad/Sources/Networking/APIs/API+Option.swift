//
//  API+Option.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation

extension API {
    class OptionClass {
        class func getOptions(_ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getOptions) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }

        class func changeOption(activate: Bool, option: String, _ completionHandler: SuccessHandler?) {
            API.provider().request(.changeOption(activate: activate, option: option)) { (result) in
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
