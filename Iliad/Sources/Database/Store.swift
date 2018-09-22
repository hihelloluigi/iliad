//
//  Store.swift
//  Iliad
//
//  Created by Luigi Aiello on 10/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit
import Contacts
import ClusterKit

enum StoreType: String {
    case store = "Iliad Store"
    case corner = "Iliad Corner"

    init?(label: String?) {
        guard let label = label else {
            return nil
        }
        switch label {
        case StoreType.store.rawValue:
            self = .store
        case StoreType.corner.rawValue:
            self = .corner
        default:
            return nil
        }
    }
}

class Store: NSObject, MKAnnotation {
    let address: String?
    let CAP: String?
    let city: String?
    let openingTime: String?
    let idTeachesLabel: Int?
    let teachesLabel: StoreType?
    
    var title: String? {
        return teachesLabel?.rawValue
    }

    var subtitle: String? {
        return city
    }

    var coordinate: CLLocationCoordinate2D

    init(address: String?, CAP: String?, city: String, coordinate: CLLocationCoordinate2D, openingTime: String?, idTeachesLabel: Int?, teachesLabel: StoreType?) {
        self.address = address
        self.CAP = CAP
        self.city = city
        self.coordinate = coordinate
        self.openingTime = openingTime
        self.idTeachesLabel = idTeachesLabel
        self.teachesLabel = teachesLabel
    }

    init(json: JSON) {
        self.address = json["adresse"].string
        self.CAP = json["cp"].string
        self.city = json["localite"].string
        if let latitude = json["latitude"].string, let doubleLat = Double(latitude),
            let longitude = json["longitude"].string, let doubleLong = Double(longitude) {
            self.coordinate = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
        self.openingTime = json["horaire"].string
        if let idTeachesLabel = json["id_enseigne"].string {
            self.idTeachesLabel = Int(idTeachesLabel)
        } else {
            self.idTeachesLabel = nil
        }
        self.teachesLabel = StoreType(label: json["enseigne_label"].string)
    }

    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: city]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict as [String: Any])
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = teachesLabel?.rawValue

        return mapItem
    }

    static func uniq<S: Sequence, E: Hashable>(_ source: S) -> [E] where E == S.Iterator.Element {
        var seen = Set<E>()
        return source.filter { seen.update(with: $0) == nil }
    }
}

func == (left: Store, right: Store) -> Bool {
    return left.coordinate.latitude == right.coordinate.latitude && left.coordinate.longitude == right.coordinate.longitude
}
