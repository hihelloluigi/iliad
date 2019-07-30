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

    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        getToken(username: Config.username(), password: Config.password())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segue
    private func performLogin(user: User) {
        guard
            let tabBarController = R.storyboard.main.mainTabBarController(),
            let homeViewController = tabBarController.viewControllers?.first as? HomeViewController,
            let navigationController = tabBarController.viewControllers?.last as? UINavigationController,
            let profileVC = navigationController.viewControllers.first as? ProfileViewController
        else {
            return
        }

        homeViewController.user = user
        profileVC.user = user
        
        self.present(tabBarController, animated: true, completion: nil)
    }

    // MARK: - Setup
    private func setup() {
        activityIndicator.tintColor = .iliadRed
        activityIndicator.type = .pacman
    }

    // MARK: - Helpers
    private func loginError() {
        self.activityIndicator.stopAnimating()

        guard
            let window = UIApplication.shared.windows.first,
            let loginVC = R.storyboard.login.loginViewController()
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
    
    // MARK: - APIs
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
