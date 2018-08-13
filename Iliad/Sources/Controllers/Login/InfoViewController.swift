//
//  InfoViewController.swift
//  IliadProd
//
//  Created by Luigi Aiello on 09/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    // Mark - Outlets
        // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

        // Buttons
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var appCodeButton: UIButton!
    @IBOutlet weak var apiCodeButton: UIButton!

    // Mark - Variables
    let appCodeUrl = "https://github.com/mo3bius/iliad"
    let apiCodeUrl = "https://github.com/Fast0n/iliad"

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Actions
    @IBAction func backDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func appCodeDidTap(_ sender: Any) {
        Utility.link(url: appCodeUrl)
    }
    @IBAction func apiCodeDidTap(_ sender: Any) {
        Utility.link(url: apiCodeUrl)
    }
}
