//
//  TrackRecorder.swift
//  BikeApp
//
//  Created by Luigi Aiello on 08/01/18.
//  Copyright © 2017 Mindtek srl. All rights reserved.
//

import CoreLocation

public protocol MapDelegate: NSObjectProtocol {
    func trackError(_ recorder: MapManager, didFailWithError error: Error)
    func trackRecorder(_ recorder: MapManager, didUpdateToLocation newLocation: CLLocation)
    func trackHeading(_ recorder: MapManager, didUpdateHeading newHeading: CLLocationDirection)
}
extension MapDelegate {
    func trackError(_ recorder: MapManager, didFailWithError error: Error) { }
}

open class MapManager: NSObject, CLLocationManagerDelegate {

    // Mark - Delegate
    weak var delegate: MapDelegate?
    
    var userLocationIsAvailable: ((_ success: Bool) -> Void)?

    public var currentCoordinate: CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 2

        manager.headingFilter = 1

        return manager
    }()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func start() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    public func stop() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError\(error)")

        delegate?.trackError(self, didFailWithError: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard newHeading.headingAccuracy > 0 else {
            return
        }
        let heading: CLLocationDirection = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        
        delegate?.trackHeading(self, didUpdateHeading: heading)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        delegate?.trackRecorder(self, didUpdateToLocation: newLocation)
    }
    
    //Auth
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            userLocationIsAvailable?(true)
        case .denied, .notDetermined, .restricted:
            userLocationIsAvailable?(false)
        }
    }
    
    public func checkLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            userLocationIsAvailable?(true)
        case .denied, .notDetermined, .restricted:
            userLocationIsAvailable?(false)
        }
    }
}
