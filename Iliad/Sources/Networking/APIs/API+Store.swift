//
//  API+Store.swift
//  Iliad
//
//  Created by Luigi Aiello on 10/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation

extension API {
    class StoreClass {
        class func getStoreLocation(location: String?, _ completionHandler: JsonSuccessHandler?) {
            API.provider().request(.getStore(location: location)) { (result) in
                API.responseJson(result, { (json) in
                    completionHandler?(json)
                })
            }
        }
    }
}
