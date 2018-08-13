//
//  ServicesViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController {

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
}
