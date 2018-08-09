//
//  BasicCell.swift
//  Iliad
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {

    // Mark - Outlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var valueLabel: UILabel!

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
    func setup(value: String?, image: UIImage?) {
        valueLabel.text = value

        if let image = image {
            iconImageView.isHidden = false
            iconImageView.image = image
        } else {
            iconImageView.isHidden = true
        }
    }

    // Mark - Helpers
    private func reset() {
        iconImageView.image = nil
        valueLabel.text = nil
    }
}
