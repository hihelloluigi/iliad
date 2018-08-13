//
//  APIEndpoint.swift
//  My-Simple-Instagram
//
//  Created by Luigi Aiello on 30/10/17.
//  Copyright © 2017 Luigi Aiello. All rights reserved.
//

import Foundation

// Resource: https://github.com/Fast0n/iliad

/**
 Defines endpoints exposed by the remote APIs.
 */
enum APIEndpoint {
    
    // Login/Logout
    case getToken(username: String, password: String)
    case login(username: String, password: String)
    case logout()
    
    // Recover password
    case recoverPassword(username: String, email: String)
    case recoverPasswordForgetUsername(name: String, surname: String, email: String)

    // Informations
    case getGeneralInformations
    case getPuk
    case changeEmail(email: String, emailConfirm: String, password: String)
    case changePassword(newPassword: String, newPasswordConfirm: String, actualPassword: String)

    // Credit
    case getNationalCredit
    case getAbroudCredit

    // Services
    case getServices
    case changeService(activate: Bool, service: String)
    case serviceInfo(service: String)

    // Options
    case getOptions
    case changeOption(activate: Bool, option: String)
}
