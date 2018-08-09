//
//  Config.swift
//  IliadProd
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation
/**
 This class is used to access the local configuration of the app.
 */
class Config {

    // MARK: - Constants
    fileprivate static let kToken = "kToken"
    fileprivate static let kUsername = "kUsername"

    /**
     Stores a user token in user defaults.
     - parameter token: the token that should be stored
     */
    class func store(token: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(token, forKey: kToken)

        defaults.synchronize()
    }

    /**
     Remove a user token in user defaults.
     */
    class func removeToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: kToken)

        defaults.synchronize()
    }

    /**
     Returns the user token currently stored in user defaults.
     - returns: the token currently stored in the user defaults or `nil` if no token can be found
     */
    class func token() -> String? {
        guard let token = UserDefaults.standard.value(forKey: kToken) as? String else {
            return nil
        }

        return token
    }

    /**
     Stores a user token in user defaults.
     - parameter token: the token that should be stored
     */
    class func store(username: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(username, forKey: kUsername)

        defaults.synchronize()
    }

    /**
     Remove a user token in user defaults.
     */
    class func removeUsername() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: kUsername)

        defaults.synchronize()
    }

    /**
     Returns the user token currently stored in user defaults.
     - returns: the token currently stored in the user defaults or `nil` if no token can be found
     */
    class func username() -> String? {
        guard let username = UserDefaults.standard.value(forKey: kUsername) as? String else {
            return nil
        }

        return username
    }
}
