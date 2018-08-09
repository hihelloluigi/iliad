//
//  APIEndpoint+Tasks.swift
//  My-Simple-Instagram
//
//  Created by Luigi Aiello on 30/10/17.
//  Copyright © 2017 Luigi Aiello. All rights reserved.
//

import Foundation
import Moya

extension APIEndpoint {
    var task: Task {
        switch self {
        // Login
        case .getToken(let username, let password):
            return .requestParameters(parameters: ["userid": username, "password": password], encoding: parameterEncoding)
        case .login(let username, let password, let token):
            return .requestParameters(parameters: ["userid": username, "password": password, "token": token], encoding: parameterEncoding)

        // Recover password
        case .recoverPassword(let username, let email, let token):
            return .requestParameters(parameters: ["userid": username, "email": email, "token": token], encoding: parameterEncoding)
        case .recoverPasswordForgetUsername(let name, let surname, let email, let token):
            return .requestParameters(parameters: ["name": name, "surname": surname, "email": email, "token": token], encoding: parameterEncoding)
        }
    }
}
