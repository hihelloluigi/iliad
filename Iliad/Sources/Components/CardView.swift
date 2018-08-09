//
//  CardView.swift
//  devisu-ios
//
//  Created by Luigi Aiello on 06/06/18.
//  Copyright © 2018 Aruba. All rights reserved.
//

import UIKit

@IBDesignable
open class CardView: UIView {

    // MARK: - Override
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    @IBInspectable
    public var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = self.shadowRadius
        }
    }

    @IBInspectable
    public var shadowOpacity: Float = 0.0 {
        didSet {
            self.layer.shadowOpacity = self.shadowOpacity
        }
    }

    @IBInspectable
    public var shadowOffSet: CGSize = CGSize.zero {
        didSet {
            self.layer.shadowOffset = self.shadowOffSet
        }
    }

    @IBInspectable
    public var shadowColor: UIColor = .clear {
        didSet {
            self.layer.shadowColor = self.shadowColor.cgColor
        }
    }

    @IBInspectable
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }

    @IBInspectable
    public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
}
