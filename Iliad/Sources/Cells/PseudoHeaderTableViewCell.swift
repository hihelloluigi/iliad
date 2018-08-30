//
//  PseudoHeaderTableViewCell.swift
//  Iliad
//
//  Created by Luigi Aiello on 30/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class PseudoHeaderTableViewCell: UITableViewCell {

    // Mark - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!

    // Mark - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        configurationUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configurationUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Mark - Setup
    private func configurationUI() {
        statusButton.tintColor = .iliadRed
    }

    // Mark - Helpers
    func setExpanded() {
        statusButton.setImage(#imageLiteral(resourceName: "ic_arrow_rotate"), for: .normal)
    }

    func setCollapsed() {
        statusButton.setImage(#imageLiteral(resourceName: "ic_arrow"), for: .normal)
    }
}
