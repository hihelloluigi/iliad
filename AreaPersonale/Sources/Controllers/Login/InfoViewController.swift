//
//  InfoViewController.swift
//  IliadProd
//
//  Created by Luigi Aiello on 09/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import TransitionButton

class InfoViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var customNavigationBar: UINavigationBar!

        // Labels
    @IBOutlet weak var titleLabel: UILabel!

        // TextView
    @IBOutlet weak var descriptionTextView: UITextView!

        // Buttons
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var appCodeButton: UIButton!
    @IBOutlet weak var apiCodeButton: UIButton!
    @IBOutlet weak var readPolicyButton: TransitionButton!

    // Mark - Variables
    var showBackButton: Bool = true
    let appCodeUrl = "https://github.com/mo3bius/iliad"
    let apiCodeUrl = "https://github.com/Fast0n/iliad"

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationUI()
        configurationText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func configurationUI() {
        readPolicyButton.isEnabled = !Defaults[.readPolicy]
        readPolicyButton.backgroundColor = !Defaults[.readPolicy] ? .iliadRed : .lightGray
        customNavigationBar.hideShadowBar()

        Defaults[.readPolicy] ? backBarButton.show() : backBarButton.hidden()
    }
    private func configurationText() {
        titleLabel.text = "Info" ~> "TITLE"
        descriptionTextView.text = "Info" ~> "DESCRIPTION"
        backBarButton.title = "Commons" ~> "BACK"
        appCodeButton.setTitle("Info" ~> "APP_CODE_BUTTON", for: .normal)
        apiCodeButton.setTitle("Info" ~> "API_CODE_BUTTON", for: .normal)
    }

    // Mark - Actions
    @IBAction func appCodeDidTap(_ sender: Any) {
        Utility.link(url: appCodeUrl)
    }
    @IBAction func apiCodeDidTap(_ sender: Any) {
        Utility.link(url: apiCodeUrl)
    }
    @IBAction func backDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func readPolicyDidTap(_ sender: Any) {
        Defaults[.readPolicy] = true
        self.dismiss(animated: true, completion: nil)
    }
}
