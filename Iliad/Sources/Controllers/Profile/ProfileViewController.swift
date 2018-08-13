//
//  ProfileViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - APIs
    private func logout() {
        API.LoginClass.logout { (success) in
            guard success else {
                print("Impossible to do logout")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Mark - Actions
    @IBAction func settingsDidTap(_ sender: Any) {
    }
    @IBAction func logoutDidTap(_ sender: Any) {
        logout()
    }
}
