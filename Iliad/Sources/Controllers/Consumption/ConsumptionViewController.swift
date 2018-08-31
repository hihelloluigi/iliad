//
//  TestViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 29/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol ConsumptionDelegate: NSObjectProtocol {
    func reloadData()
}

class ConsumptionViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

        // Buttons
    @IBOutlet weak var reloadButton: UIButton!

        // Calls
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var callSubLabel: UILabel!
    @IBOutlet weak var callImageView: UIImageView!

        // SMS
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var smsSubLabel: UILabel!
    @IBOutlet weak var smsImageView: UIImageView!

        // MMS
    @IBOutlet weak var mmsLabel: UILabel!
    @IBOutlet weak var mmsSubLabel: UILabel!
    @IBOutlet weak var mmsImageView: UIImageView!

        // Data
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataSubLabel: UILabel!
    @IBOutlet weak var dataImageView: UIImageView!

    // Mark - Variables
    var consumption: Consumption?

    // Mark - Delegate
    weak var delegate: ConsumptionDelegate?

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configurationUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        activityIndicator.tintColor = .iliadRed
        activityIndicator.type = .pacman
    }

    private func configurationUI() {
        activityIndicator.isHidden = true
        stackView.isHidden = true
    }

    func configurionData(consumption: Consumption?) {
        guard let consumption = consumption else {
            return
        }

        callLabel.text = consumption.calls
        callSubLabel.text = consumption.extraCalls
        callImageView.image = #imageLiteral(resourceName: "ic_call")
        smsLabel.text = consumption.sms
        smsSubLabel.text = consumption.extraSMS
        smsImageView.image = #imageLiteral(resourceName: "ic_sms")
        mmsLabel.text = consumption.mms
        mmsSubLabel.text = consumption.extraMMS
        mmsImageView.image = #imageLiteral(resourceName: "ic_mms")
        dataLabel.text = consumption.data
        dataSubLabel.text = consumption.extraData
        dataImageView.image = #imageLiteral(resourceName: "ic_internet")
    }

    // Mark - Helpers
    func load() {
        stackView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func finishLoad() {
        stackView.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    // Mark - Actions
    @IBAction func reloadDidTap(_ sender: Any) {
        delegate?.reloadData()
    }
}
