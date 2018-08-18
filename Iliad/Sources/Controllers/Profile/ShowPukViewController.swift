//
//  ShowPukViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 16/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import TransitionButton

class ShowPukViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var customNavigationBar: UINavigationBar!

    // Image Views
    @IBOutlet weak var showPukImageView: UIImageView!

        // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

        // Buttons
    @IBOutlet weak var showPukButton: TransitionButton!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

        // Text fields
    @IBOutlet weak var pukTextField: UITextField!

    // Mark - Variables
    private var isPukVisible: Bool = false

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationUI()
        configurationText()
        showPuk()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func configurationUI() {
        showPukImageView.tintColor = .iliadRed
        customNavigationBar.shadowImage = UIImage()
        pukTextField.textAlignment = .center
    }

    private func configurationText() {
        titleLabel.text = "Puk" ~> "TITLE"
        showPukButton.setTitle("Puk" ~> "SHOW_PUK_BUTTON", for: .normal)
    }

    // Mark - APIs
    private func showPuk() {
        CustomActivityIndicator.progress()
        API.InformationClass.getPuk { (json) in
            CustomActivityIndicator.hide()
            guard let json = json, let puk = json["iliad"]["0"].string else {
                return
            }

            self.pukTextField.text = puk
        }
    }

    // Mark - Actions
    @IBAction func showPukDidTap(_ sender: Any) {
        pukTextField.isSecureTextEntry = isPukVisible
        isPukVisible = !isPukVisible
        showPukButton.setTitle(isPukVisible ? "Puk" ~> "HIDE_PUK_BUTTON" : "Puk" ~> "SHOW_PUK_BUTTON", for: .normal)
    }
    
    @IBAction func cancelDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
