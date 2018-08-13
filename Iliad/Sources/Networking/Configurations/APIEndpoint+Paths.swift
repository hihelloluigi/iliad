//
//  APIEndpoint+Paths.swift
//  My-Simple-Instagram
//
//  Created by Luigi Aiello on 30/10/17.
//  Copyright © 2017 Luigi Aiello. All rights reserved.
//

import Foundation

extension APIEndpoint {
    var path: String {
        switch self {
        // Login/Logout
        case .getToken:
            return ("/token")
        case .login:
            return ("/login")
        case .logout:
            return ("/logout")

        // Recover password
        case .recoverPassword:
            return ("/recover")
        case .recoverPasswordForgetUsername:
            return ("/recover")

        // Informations
        case .getGeneralInformations:
            return ("/information")
        case .getPuk:
            return ("/information")
        case .changeEmail:
            return ("/information")
        case .changePassword:
            return ("/information")

        // Credit
        case .getNationalConsumption:
            return ("/credit")
        case .getAbroudConsumption:
            return ("/credit")

        // Services
        case .getServices:
            return ("/services")
        case .changeService:
            return ("/services")
        case .serviceInfo:
            return ("/services")

        // Options
        case .getOptions:
            return ("/options")
        case .changeOption:
            return ("/options")
        }
    }
}
