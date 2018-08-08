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
            
        //Login
        case .getToken:
            return ("/token")
        case .login:
            return ("/login")
        }
    }
}
