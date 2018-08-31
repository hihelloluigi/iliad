//
//  Utility.swift
//  IliadProd
//
//  Created by Luigi Aiello on 09/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

class Utility {
    static let tagCharacter: Character = "@"

    static func link(url: String?) {
        if let url = url {
            if !url.hasPrefix("http://") && !url.hasPrefix("https://") {
                self.open(url: "http://\(url.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))")
            } else {
                self.open(url: url.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            }
        }
    }

    static func open(url: String?, errorHandler : (() -> Void)? = nil) {
        if let urlString = url, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if !success {
                    errorHandler?()
                }
            }
        } else {
            errorHandler?()
        }
    }

    static func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
