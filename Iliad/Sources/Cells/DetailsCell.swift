//
//  DetailsCell.swift
//  Iliad
//
//  Created by Luigi Aiello on 30/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {

    // Mark - Outlets
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!

    // Mark - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Mark - Setup
    func setup(country: String?, type: String?, phoneNumber: String?, date: String?, volume: String?) {
        setupLabel(label: countryLabel, text: country)
        setupLabel(label: typeLabel, text: type)
        setupLabel(label: phoneNumberLabel, text: phoneNumber)
        setupLabel(label: dateLabel, text: date)
        setupLabel(label: volumeLabel, text: volume)
    }

    private func setupLabel(label: UILabel, text: String?) {
        if let text = text {
            label.isHidden = false
            label.text = text
        } else {
            label.isHidden = true
        }
    }

    // Mark - Helpers
    private func reset() {
        countryLabel.text = nil
        typeLabel.text = nil
        phoneNumberLabel.text = nil
        dateLabel.text = nil
        volumeLabel.text = nil
    }
}
