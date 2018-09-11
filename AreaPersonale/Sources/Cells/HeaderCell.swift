//
//  HeaderCell.swift
//  Iliad
//
//  Created by Luigi Aiello on 30/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    // Mark - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var idCodeLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    // Mark - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
        configurationUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
        configurationUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Mark - Setup
    func setup(name: String?, phoneNumber: String?, idCode: String?) {
        nameLabel.text = name
        phoneNumberLabel.text = phoneNumber
        idCodeLabel.text = idCode
    }

    private func configurationUI() {
        iconImageView.tintColor = .iliadRed
    }

    // Mark - Helpers
    private func reset() {
        nameLabel.text = nil
        phoneNumberLabel.text = nil
        idCodeLabel.text = nil
    }
}
