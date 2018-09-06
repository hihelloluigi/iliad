//
//  File.swift
//  IliadProd
//
//  Created by Luigi Aiello on 05/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func hideShadowBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
}
