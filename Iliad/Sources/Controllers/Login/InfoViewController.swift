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

    // MARK: - Outlets
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

    // MARK: - Variables
    var showBackButton: Bool = true
    let appCodeUrl = "https://github.com/mo3bius/iliad"
    let apiCodeUrl = "https://github.com/Fast0n/iliad"

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationUI()
        configurationText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Setup
    private func configurationUI() {
        readPolicyButton.isEnabled = !Defaults[.readPolicy]
        readPolicyButton.backgroundColor = !Defaults[.readPolicy] ? .iliadRed : .lightGray
        customNavigationBar.hideShadowBar()

        Defaults[.readPolicy] ? backBarButton.show() : backBarButton.hidden()
    }
    
    private func configurationText() {
        titleLabel.text = R.string.info.title()
        descriptionTextView.text = R.string.info.description()
        backBarButton.title = R.string.commons.back()
        appCodeButton.setTitle(R.string.info.app_code_button(), for: .normal)
        apiCodeButton.setTitle(R.string.info.api_code_button(), for: .normal)
    }

    // MARK: - Actions
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
