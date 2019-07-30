//
//  AppConfig+Testing.swift
//  Iliad Testing
//
//  Created by Luigi Aiello on 30/07/2019.
//  Copyright © 2019 Luigi Aiello. All rights reserved.
//

import Foundation
import Firebase

extension AppConfig {
    
    // MARK: - Constants
    static let webserviceConfiguration = DefaultConfiguration.testing
    
    // MARK: - Configurations
    class func configureFirebase() {
        guard
            let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: filePath)
            else {
                return
        }
        
        FirebaseApp.configure(options: options)
    }
}
