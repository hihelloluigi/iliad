//
//  APIEndpoint.swift
//  My-Simple-Instagram
//
//  Created by Luigi Aiello on 30/10/17.
//  Copyright © 2017 Luigi Aiello. All rights reserved.
//

import Foundation

/**
 Defines endpoints exposed by the remote APIs.
 */
enum APIEndpoint {
    
    // Login
    case getToken(username: String, password: String)
    case login(username: String, password: String, token: String)

    // Recover password
    case recoverPassword(username: String, email: String, token: String)
    case recoverPasswordForgetUsername(name: String, surname: String, email: String, token: String)
}
