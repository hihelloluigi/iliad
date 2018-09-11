//
//  UIColor+XT.swift
//  Iliad
//
//  Created by Luigi Aiello on 09/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

private enum UIColorMask: CUnsignedInt {
    case red = 0xff000000
    case green = 0x00ff0000
    case blue = 0x0000ff00
    case alpha = 0x000000ff

    static func redValue(_ value: CUnsignedInt) -> Int {
        return Int((value & CUnsignedInt(red.rawValue)) >> 24)
    }

    static func greenValue(_ value: CUnsignedInt) -> Int {
        return Int((value & CUnsignedInt(green.rawValue)) >> 16)
    }

    static func blueValue(_ value: CUnsignedInt) -> Int {
        return Int((value & CUnsignedInt(blue.rawValue)) >> 8)
    }

    static func alphaValue(_ value: CUnsignedInt) -> CGFloat {
        return CGFloat(value & CUnsignedInt(alpha.rawValue))
    }
}

extension UIColor {

    static let iliadRed = UIColor(red: (202/255), green: (24/255), blue: (28/255), alpha: 1)

    /**
     Create a new color with HEX String value and Alpha component.

     - Parameter hex:       a String value that represents hex color.
     - Parameter alpha:     a Int value that represents the trasparency of the color. Value must be between 0 and 1.0.

     */
    public convenience init(hex: String?) {
        let normalizedHexString: String = UIColor.normalize(hex)

        var rgb: UInt32 = 0
        Scanner(string: normalizedHexString).scanHexInt32(&rgb)

        self.init(iRed: UIColorMask.redValue(rgb), iGreen: UIColorMask.greenValue(rgb), iBlue: UIColorMask.blueValue(rgb), alpha: (UIColorMask.alphaValue(rgb) / 255))
    }

    /**
     Create a new color with HEX Int value and Alpha component.

     - Parameter hex:       a Int value that represents hex color.
     - Parameter alpha:     a Int value that represents the trasparency of the color. Value must be between 0 and 1.0.
     */
    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        assert(alpha >= 0 && alpha <= 1, "Invalid apha component")

        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0x00FF00) >> 8
        let blue = (hex & 0x0000FF) >> 0

        self.init(iRed: red, iGreen: green, iBlue: blue, alpha: alpha)
    }

    /**
     Create a new color with RGB value and Alpha component.

     - Parameter iRed:      a Int value that represents RED color of RGB. Value must be between 0 and 255.
     - Parameter iGreen:    a Int value that represents GREEN color of RGB. Value must be between 0 and 255.
     - Parameter iBlue:     a Int value that represents BLUE color of RGB. Value must be between 0 and 255.
     - Parameter alpha:     a Int value that represents the trasparency of the color. Value must be between 0 and 1.0.
     */
    public convenience init(iRed: Int = 0, iGreen: Int = 0, iBlue: Int = 0, alpha: CGFloat = 1.0) {
        assert(iRed >= 0 && iRed <= 255, "Invalid red component")
        assert(iGreen >= 0 && iGreen <= 255, "Invalid green component")
        assert(iBlue >= 0 && iBlue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 1, "Invalid apha component")

        self.init(red: CGFloat(iRed) / 255.0, green: CGFloat(iGreen) / 255.0, blue: CGFloat(iBlue) / 255.0, alpha: alpha)
    }

    /**
     Returns a hex equivalent of this UIColor.

     - Parameter includeAlpha: Optional parameter to include the alpha hex.
     - Returns: A new string with `String` with the color's hexidecimal value.
     */
    public func hexDescription(_ includeAlpha: Bool = false) -> String {
        guard let components = self.cgColor.components, self.cgColor.numberOfComponents == 4 else {
            return "Color not RGB."
        }
        let maps = components.map { Int($0 * CGFloat(255)) }
        let color = String.init(format: "%02x%02x%02x", maps[0], maps[1], maps[2])
        if includeAlpha {
            let alpha = String.init(format: "%02x", maps[3])
            return "\(color)\(alpha)"
        }
        return color
    }

    // MARK: - Helpers
    private static func normalize(_ hex: String?) -> String {
        guard let hex = hex else {
            return "00000000"
        }

        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        if !(hexSanitized.count > 7) {
            hexSanitized += "ff"
        }

        return hexSanitized
    }
}
