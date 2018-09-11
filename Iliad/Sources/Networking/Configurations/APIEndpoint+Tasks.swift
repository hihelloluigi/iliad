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
        // Login/Logout
        case .getToken(let username, let password):
            return .requestParameters(parameters: ["userid": username, "password": password], encoding: parameterEncoding)
        case .login(let username, let password):
            return .requestParameters(parameters: ["userid": username, "password": password, "token": accessToken], encoding: parameterEncoding)
        case .logout:
            return .requestParameters(parameters: ["token": accessToken], encoding: parameterEncoding)

        // Recover password
        case .recoverPassword(let username, let email):
            return .requestParameters(parameters: ["userid": username, "email": email, "token": accessToken], encoding: parameterEncoding)
        case .recoverPasswordForgetUsername(let name, let surname, let email):
            return .requestParameters(parameters: ["name": name, "surname": surname, "email": email, "token": accessToken], encoding: parameterEncoding)

        // Store location
        case .getStore(let location):
            return .requestParameters(parameters: ["location": location ?? ""], encoding: parameterEncoding)

        // Informations
        case .getGeneralInformations:
            return .requestParameters(parameters: ["info": "true", "token": accessToken], encoding: parameterEncoding)
        case .getPuk:
            return .requestParameters(parameters: ["puk": "true", "token": accessToken], encoding: parameterEncoding)
        case .changeEmail(let email, let emailConfirm, let password):
            return .requestParameters(parameters: ["email": email, "email_confirm": emailConfirm, "password": password, "token": accessToken], encoding: parameterEncoding)
        case .changePassword(let newPassword, let newPasswordConfirm, let actualPassword):
            return .requestParameters(parameters: ["new_password": newPassword,
                                                   "new_password_confirm": newPasswordConfirm,
                                                   "password": actualPassword, "token": accessToken], encoding: parameterEncoding)

        // Credit
        case .getNationalConsumption:
            return .requestParameters(parameters: ["credit": "true", "token": accessToken], encoding: parameterEncoding)
        case .getAbroudConsumption:
            return .requestParameters(parameters: ["estero": "true", "token": accessToken], encoding: parameterEncoding)
        case .getConsumptionDetails:
            return .requestParameters(parameters: ["details": "true", "token": accessToken], encoding: parameterEncoding)

        // Services
        case .getServices:
            return .requestParameters(parameters: ["services": "true", "token": accessToken], encoding: parameterEncoding)
        case .changeService(let activate, let service):
            return .requestParameters(parameters: ["change_services": "true", "activate": activate, "update": service, "token": accessToken], encoding: parameterEncoding)
        case .serviceInfo(let service):
            return .requestParameters(parameters: ["info": "true", "type": service, "token": accessToken], encoding: parameterEncoding)

        // Options
        case .getOptions:
            return .requestParameters(parameters: ["option": "true", "token": accessToken], encoding: parameterEncoding)
        case .changeOption(let activate, let option):
            return .requestParameters(parameters: ["change_options": "true", "activate": activate, "update": option, "token": accessToken], encoding: parameterEncoding)
        }
    }
}
