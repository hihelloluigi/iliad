//
//  UIBarButtonItem+XT.swift
//  IliadProd
//
//  Created by Luigi Aiello on 01/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    /**
     Hidden Bar Button
     */
    func hidden() {
        self.isEnabled = false
        self.tintColor = .clear
    }

    /**
     Show Bar Button
     - Parameters:
     - Color: UIColor -> Choose the tint color of the button
     */
    func show(color: UIColor? = nil) {
        self.isEnabled = true
        self.tintColor = color ?? tintColor
    }
}
