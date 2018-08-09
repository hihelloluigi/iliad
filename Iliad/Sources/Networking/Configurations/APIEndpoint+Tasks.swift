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
        case .login(let username, let password):
            return .requestParameters(parameters: ["userid": username, "password": password, "token": accessToken], encoding: parameterEncoding)

        // Recover password
        case .recoverPassword(let username, let email):
            return .requestParameters(parameters: ["userid": username, "email": email, "token": accessToken], encoding: parameterEncoding)
        case .recoverPasswordForgetUsername(let name, let surname, let email):
            return .requestParameters(parameters: ["name": name, "surname": surname, "email": email, "token": accessToken], encoding: parameterEncoding)

        // Logout
        case .logout:
            return .requestParameters(parameters: ["token": accessToken], encoding: parameterEncoding)

        // Informations
        case .getGeneralInformations:
            return .requestParameters(parameters: ["info": true, "token": accessToken], encoding: parameterEncoding)
        case .getPuk:
            return .requestParameters(parameters: ["puk": true, "token": accessToken], encoding: parameterEncoding)

        // Actions
        case .changeEmail(let email, let emailConfirm, let password):
            return .requestParameters(parameters: ["email": email, "email_confirm": emailConfirm, "password": password, "token": accessToken], encoding: parameterEncoding)
        case .changePassword(let newPassword, let newPasswordConfirm, let actualPassword):
            return .requestParameters(parameters: ["new_password": newPassword, "new_password_confirm": newPasswordConfirm, "password": actualPassword, "token": accessToken], encoding: parameterEncoding)

        // Credit
        case .getNationalCredit:
            return .requestParameters(parameters: ["credit": true, "token": accessToken], encoding: parameterEncoding)
        case .getAbroudCredit:
            return .requestParameters(parameters: ["estero": true, "token": accessToken], encoding: parameterEncoding)
        }
    }
}
