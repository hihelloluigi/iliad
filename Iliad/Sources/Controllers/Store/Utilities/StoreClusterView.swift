//
//  StoreCluster.swift
//  IliadProd
//
//  Created by Luigi Aiello on 11/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation
import MapKit

class StoreClusterView: MKAnnotationView {

    init(annotation: MKAnnotation?, reuseIdentifier: String?, numberOfItemInCluster items: UInt) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        image = #imageLiteral(resourceName: "ic_round").textToImage(drawText: "\(items)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
