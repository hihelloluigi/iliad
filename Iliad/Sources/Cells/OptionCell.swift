//
//  OptionCell.swift
//  IliadProd
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {

    // Mark - Outlets
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var optionSwitch: UISwitch!

    // Mark - Handler
    var optionHandler: OptionHandler?
    var key: String?

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
    func setup(key: String?, isOn: Bool?, description: String?, handler: OptionHandler?) {
        descriptionLabel.text = description
        optionSwitch.isOn = isOn ?? false

        self.key = key
        optionHandler = handler
    }

    // Mark - Action
    @IBAction func switchDidChange(_ sender: Any) {
        optionHandler?(key, optionSwitch.isOn)
    }
    
    // Mark - Helpers
    private func reset() {
        key = nil
        descriptionLabel.text = nil
        optionSwitch.isOn = false
    }
}
