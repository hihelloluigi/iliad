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
        // Login
        case .getToken:
            return ("/token")
        case .login:
            return ("/login")

        // Recover password
        case .recoverPassword:
            return ("/recover")
        case .recoverPasswordForgetUsername:
            return ("/recover")

        // Logout
        case .logout:
            return ("/logout")

        // Informations
        case .getGeneralInformations:
            return ("/information")
        case .getPuk:
            return ("/information")

        // Actions
        case .changeEmail:
            return ("/information")
        case .changePassword:
            return ("/information")

        // Credit
        case .getNationalCredit:
            return ("/credit")
        case .getAbroudCredit:
            return ("/credit")
        }
    }
}
