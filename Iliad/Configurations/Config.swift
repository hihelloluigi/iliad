//
//  Config.swift
//  IliadProd
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation
import KeychainAccess
import SwiftyUserDefaults
/**
 This class is used to access the local configuration of the app.
 */

extension DefaultsKeys {
    static let saveUsername = DefaultsKey<Bool>("kSaveUsername")
    static let autoLogin = DefaultsKey<Bool>("kAutoLogin")
    static let loginWithBiometric = DefaultsKey<Bool>("kLoginWithBiometric")
    static let readPolicy = DefaultsKey<Bool>("kReadPolicy")
}

class Config {

    // MARK: - Constants
    fileprivate static let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
    static var token: String?

    // Keychain
    fileprivate static let kUsername = "kUsername"
    fileprivate static let kPassword = "kPassword"

    // Mark - Username
    class func store(username: String) {
        keychain[kUsername] = username
    }

    class func username() -> String? {
        return keychain[kUsername]
    }

    class func removeUsername() {
        keychain[kUsername] = nil
    }

    // Mark - Password
    class func store(password: String) {
        keychain[kPassword] = password
    }

    class func password() -> String? {
        return keychain[kPassword]
    }

    class func removePassword() {
        keychain[kPassword] = nil
    }
}
