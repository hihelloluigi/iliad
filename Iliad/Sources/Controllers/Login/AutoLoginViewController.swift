//
//  AutoLoginViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 17/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AutoLoginViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        getToken(username: Config.username(), password: Config.password())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        activityIndicator.tintColor = .iliadRed
        activityIndicator.type = .pacman
    }

    // Mark - Helpers
    private func loginError() {
        self.activityIndicator.stopAnimating()

        guard
            let window = UIApplication.shared.windows.first,
            let loginVC = "Login" <%> "LoginViewController" as? LoginViewController
        else {
            print("Impossible to do logout")
            return
        }
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = loginVC
        }, completion: { (success) in
            print(success)
        })
    }

    // Mark - Segue
    private func performLogin(user: User) {
        guard
            let tabBarController = "Main" <%> "MainTabBarController" as? MainTabBarController,
            let firstNavController = tabBarController.viewControllers?.first as? UINavigationController,
            let consumptionViewController = firstNavController.viewControllers.last as? ConsumptionViewController
        else {
            return
        }

        consumptionViewController.user = user

        self.present(tabBarController, animated: true, completion: nil)
    }

    // Mark - APIs
    private func getToken(username: String?, password: String?) {
        guard
            let username = username,
            let password = password
        else {
            return
        }
        activityIndicator.startAnimating()
        API.LoginClass.getToken(username: username, password: password) { (token, success) in
            guard success, let token = token else {
                self.loginError()
                return
            }

            Config.token = token
            self.login(username: username, password: password)
        }
    }

    private func login(username: String, password: String) {
        API.LoginClass.login(username: username, password: password) { (json) in
            self.activityIndicator.stopAnimating()
            guard let json = json else {
                self.loginError()
                return
            }

            let user = User(json: json["iliad"])
            self.performLogin(user: user)
        }
    }
}
