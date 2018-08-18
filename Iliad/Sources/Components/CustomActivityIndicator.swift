//
//  MTActivityIndicator.swift
//  MiTwitProd
//
//  Created by Luigi Aiello on 22/11/17.
//  Copyright © 2017 MindTek. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class CustomActivityIndicator {
    
    static let activitySize: CGSize = CGSize(width: 70, height: 70)
    static let activityType: NVActivityIndicatorType = .pacman
    static let activityTint: UIColor = .iliadRed

    static func progress(activityData: ActivityData? = nil) {
        var data = ActivityData(size: activitySize, type: activityType, color: activityTint)
        if let programmerData = activityData {
            data = programmerData
        }
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(data, nil)
    }
    
    static func success(message: String = "", delay: TimeInterval = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
    
    static func hide() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    static func error(delay: TimeInterval = 0.0) {
    }
}
