//
//  AppDelegate.swift
//  Iliad
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyUserDefaults

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Variables
    var window: UIWindow?

    // MARK: - Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setup(application, launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

    // MARK: - Setup
    private func setup(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        // Firebase configurations
        AppConfig.configureFirebase()

        // Keyboard configurations
        IQKeyboardManager.shared.enable = true
        
        // App Inizialization
        setupRootViewController()
    }
    
    private func setupRootViewController() {
        if Defaults[.autoLogin] && !Defaults[.loginWithBiometric] {
            guard let autoLoginVC = "Login" <%> "AutoLoginViewController" as? AutoLoginViewController else {
                return
            }
            window?.rootViewController = autoLoginVC
        }
    }
}
