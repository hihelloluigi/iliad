//
//  UIViewController+Utility.swift
//  FirmaDigitale
//
//  Created by Giorgio Fiderio on 17/03/17.
//  Copyright © 2017 Aruba S.p.A. All rights reserved.
//

import UIKit
import SwiftMessages

extension UIViewController {
    
    private func showMessage(title: String, message: String, color: UIColor, buttonTitle: String? = nil) {
        let view = MessageView.viewFromNib(layout: .cardView)
        var config = SwiftMessages.defaultConfig
        if let buttonTitle = buttonTitle {
            view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: buttonTitle, buttonTapHandler: { _ in SwiftMessages.hide()})
            config.duration = .forever
        } else {
            view.configureContent(title: title, body: message)
            config.duration = .seconds(seconds: 3)
            view.button?.isHidden = true
        }

        view.configureTheme(backgroundColor: color, foregroundColor: UIColor.white, iconImage: nil, iconText: nil)
//        config.dimMode = .gray(interactive: true)
        config.presentationContext = .viewController(self)
        // Show
        SwiftMessages.show(config: config, view: view)
    }
    
    public func showErrorMessage(title: String, message: String, buttonTitle: String? = nil) {
        self.showMessage(title: title, message: message, color: UIColor(hex: "#F44336"), buttonTitle: buttonTitle)
    }
    
    public func showErrorMessage(message: String) {
        self.showErrorMessage(title: NSLocalizedString("Errore", comment: "Error Alert Title"), message: message)
    }
    
    public func showSuccessMessage(title: String, message: String) {
        self.showMessage(title: title, message: message, color: UIColor(hex: "#4CAF50"))
    }
}
