//
//  String+XT.swift
//  IliadProd
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    /**
     Convert string to boolean value.

     - Returns: a nullable boolean value.
     */
    public func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    func localized(withTableNamed tableName: String, bundle: Bundle = Bundle.main, comment: String = "") -> String {
        let translated = NSLocalizedString(self, tableName: tableName, comment: comment)
        return translated
    }
}

infix operator ~>
/**
 Returns the localized message for `localizationKey` in `tableName`;
 this function searches the strings table in the main bundle.

 - parameter tableName: the .strings file name that includes the translation of `localizationKey`
 - parameter localizationKey: the key for which a localized string should exist in file `tableName`.strings
 - returns: the localization for `localizationKey` in `tableName`
 */
func ~> (tableName: String, localizationKey: String) -> String {
    return localizationKey.localized(withTableNamed: tableName)
}
