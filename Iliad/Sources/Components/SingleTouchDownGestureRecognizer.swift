//
//  SingleTouchDownGestureRecognizer.swift
//  Iliad
//
//  Created by Luigi Aiello on 10/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class SingleTouchDownGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .began
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
    }
}
