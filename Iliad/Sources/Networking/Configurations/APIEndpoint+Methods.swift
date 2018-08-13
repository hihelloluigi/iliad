//
//  APIEndpoint+Methods.swift
//  My-Simple-Instagram
//
//  Created by Luigi Aiello on 30/10/17.
//  Copyright © 2017 Luigi Aiello. All rights reserved.
//

import Foundation
import Moya

extension APIEndpoint {
    var method: Moya.Method {
        switch self {
        case .getToken,
             .login,
             .recoverPassword,
             .recoverPasswordForgetUsername,
             .logout, .getGeneralInformations,
             .getPuk,
             .changeEmail,
             .changePassword,
             .getNationalConsumption,
             .getAbroudConsumption,
             .getServices,
             .changeService,
             .serviceInfo,
             .getOptions,
             .changeOption:
            return .get
        }
    }
}
