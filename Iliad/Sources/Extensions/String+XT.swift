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
        return Data(self.utf8).base64EncodedString()
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
}
