//
//  StoreViews.swift
//  Iliad
//
//  Created by Luigi Aiello on 11/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import MapKit

class StoreAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(#imageLiteral(resourceName: "ic_map"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton

            if let title = annotation?.title, let type = StoreType(label: title) {
                switch type {
                case .corner:
                    image = #imageLiteral(resourceName: "ic_corner_store")
                case .store:
                    image = #imageLiteral(resourceName: "ic_iliad_store")
                }
            } else {
                image = nil
            }
        }
    }
}
