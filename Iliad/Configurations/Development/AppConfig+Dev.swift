//
//  AppConfig+Dev.swift
//  MiTwit
//
//  Created by Luigi Aiello on 16/11/17.
//  Copyright © 2017 MindTek. All rights reserved.
//

import Foundation
import Firebase

extension AppConfig {
    
    // MARK: - Constants
    static let webserviceConfiguration = DefaultConfiguration.development
    
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
