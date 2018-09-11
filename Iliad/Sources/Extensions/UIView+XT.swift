//
//  UIView+XT.swift
//  Iliad
//
//  Created by Luigi Aiello on 11/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
