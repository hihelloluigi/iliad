//
//  RowCell.swift
//  Iliad
//
//  Created by Luigi Aiello on 30/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class RowCell: UITableViewCell {

    // Mark - Outlets
    @IBOutlet private weak var firstValueLabel: UILabel!
    @IBOutlet private weak var secondValueLabel: UILabel!
    @IBOutlet private weak var thirdValueLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var editButton: UIButton!

    // Mark - Handler
    var handler: VoidHandler?

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
    func setup(row: ProfileRow) {
        setupLabel(label: firstValueLabel, text: row.firstValue)
        setupLabel(label: secondValueLabel, text: row.secondValue)
        setupLabel(label: thirdValueLabel, text: row.thirdValue)

        iconImageView.image = row.icon

        self.handler = row.handler
        
        if let editICon = row.editIcon {
            editButton.isHidden = false
            editButton.setImage(editICon, for: .normal)
        } else {
            editButton.isHidden = true
        }
    }

    private func configurationUI() {
        iconImageView.tintColor = .white
        editButton.tintColor = .white
    }

    // Mark - Helpers
    private func setupLabel(label: UILabel, text: String?) {
        if let text = text {
            label.isHidden = false
            label.text = text
        } else {
            label.isHidden = true
        }
    }

    @objc private func viewDidTap(_ sender: UITapGestureRecognizer) {
        handler?()
    }

    private func reset() {
        firstValueLabel.text = nil
        secondValueLabel.text = nil
        thirdValueLabel.text = nil
    }

    // Mark - Actions
    @IBAction func editDidTap(_ sender: Any) {
        handler?()
    }
}
