//
//  AppConfig.swift
//  My-Simple-Instagram
//
//  Created by Luigi Aiello on 30/10/17.
//  Copyright © 2017 Luigi Aiello. All rights reserved.
//

import Foundation
import UIKit

class AppConfig {

    // Mark - Singleton instance
    static let shared = AppConfig()

    // Mark - Properties
    var apiBaseURL: String {
        return AppConfig.webserviceConfiguration.urlString
    }
    
    var target: DefaultConfiguration {
        return AppConfig.webserviceConfiguration
    }
}

enum DefaultConfiguration: String {
    case development = "Develop"
    case staging = "Staging"
    case production = "Production"
    
    init?(rawValue: String) {
        switch rawValue {
        case DefaultConfiguration.development.rawValue:
            self = .development
        case DefaultConfiguration.staging.rawValue:
            self = .staging
        case DefaultConfiguration.production.rawValue:
            self = .production
        default:
            return nil
        }
    }
    
    var urlString: String {
        switch self {
        case .development:
            return "http://192.168.1.144:8082"
        case .staging:
            return "https://areapersonale.herokuapp.com"
        case .production:
            return "https://areapersonale.herokuapp.com"
        }
    }
}
