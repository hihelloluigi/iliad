//
//  UIImage+XT.swift
//  Iliad
//
//  Created by Luigi Aiello on 11/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

extension UIImage {
    func textToImage(drawText text: String) -> UIImage {

        // Text
        let textFont = UIFont.boldSystemFont(ofSize: 14)
        let textColor = UIColor.white
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let textFontAttributes = [NSAttributedString.Key.font: textFont, NSAttributedString.Key.foregroundColor: textColor, kCTParagraphStyleAttributeName: paragraph] as! [NSAttributedString.Key: Any]

        //Image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        // Text Rect
        let textHeight = textFont.lineHeight
        let textY = (self.size.height - textHeight) / 2
        let textRect = CGRect(x: 0, y: textY, width: self.size.width, height: textHeight)
        text.draw(in: textRect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
