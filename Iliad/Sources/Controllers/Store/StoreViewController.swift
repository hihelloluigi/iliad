//
//  StoreViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 10/09/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import ClusterKit

class StoreViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var mapView: MKMapView!

        // Buttons
    @IBOutlet weak var changeMapTypeButton: UIButton!
    @IBOutlet weak var centerLocationButton: UIButton!
    @IBOutlet weak var dismissButton: CustomButton!

    // Mark - Default
    private let annotationViewReuseIdentifier = "annotation"
    private let clusterAnnotationViewReuseIdentifier = "cluster"

    // Mark - Variables
    var store = [Store]()
    var initialCoordinate = CLLocationCoordinate2D(latitude: 42.504154, longitude: 12.646361) // Center of Italy
    var regionRadius: CLLocationDistance = 1000000 // 1000 km
    let mapManager = MapManager()

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        getStore(location: nil)
    }
    private func setupMap() {
        mapManager.userLocationIsAvailable = { success in
            if success, let currentCoordinate = self.mapManager.currentCoordinate {
                self.initialCoordinate = currentCoordinate
                self.regionRadius = 20000 // 20 km
                self.mapView.showsUserLocation = true
                self.mapView.tintColor = .iliadRed
            } else {
                self.mapView.showsUserLocation = false
            }
            
            self.mapView.delegate = self
            self.centerMapOnLocation(coordinate: self.initialCoordinate)
        }
        mapManager.checkLocationAuthorization()

        // Cluster
        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        algorithm.cellSize = 200

        mapView.clusterManager.algorithm = algorithm
        mapView.clusterManager.marginFactor = 1
    }

    // Mark - Helpers
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    // Mark - APIs
    private func getStore(location: String?) {
        API.StoreClass.getStoreLocation(location: location) { (json) in
            guard let json = json else {
                return
            }

            for element in json {
                let newStore = Store(json: element.1)
                if self.store.filter({ $0 == newStore }).isEmpty {
                    self.store.append(newStore)
                }
            }
            self.mapView.clusterManager.annotations = self.store
        }
    }

    // Mark - Actions
    @IBAction func changeMapTypeDidTap(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        let actionSheet = UIAlertController(title: "Tracks" ~> "change map type", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .iliadRed

        let configurations: [(mapType: MKMapType, textKey: String)] = [
            (MKMapType.standard, "Normale"),
            (MKMapType.hybrid, "Hybrido"),
            (MKMapType.satellite, "Satellite")
        ]

        for configuration in configurations {
            actionSheet.addAction(UIAlertAction(title: "\(configuration.textKey)", style: .default, handler: { (_) in
                self.mapView.mapType = configuration.mapType
            }))
        }

        actionSheet.addAction(UIAlertAction(title: "Commons" ~> "CANCEL", style: .cancel, handler: nil))

        if let popoverPresentationController = actionSheet.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.sourceView = button
            popoverPresentationController.sourceRect = button.bounds
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func centerLocationDidTap(_ sender: Any) {
        guard let userLocation = mapManager.currentCoordinate else {
            return
        }
        centerMapOnLocation(coordinate: userLocation)
    }
    @IBAction func dismissDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Mark - Map View Delegate
extension StoreViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let cluster = annotation as? CKCluster else {
            return nil
        }

        var view: MKAnnotationView

        if cluster.count > 1 {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: clusterAnnotationViewReuseIdentifier) as? StoreClusterView {
                dequeuedView.image = #imageLiteral(resourceName: "ic_round").textToImage(drawText: "\(cluster.count)")
                view = dequeuedView
            } else {
                view = StoreClusterView(annotation: annotation, reuseIdentifier: clusterAnnotationViewReuseIdentifier, numberOfItemInCluster: cluster.count)
            }
            return view
        }

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewReuseIdentifier) as? StoreAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = StoreAnnotationView(annotation: annotation, reuseIdentifier: annotationViewReuseIdentifier)
        }

        return view
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.clusterManager.updateClustersIfNeeded()
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let cluster = view.annotation as? CKCluster else {
            return
        }

        if cluster.count > 1 {
            let edgePadding = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
            mapView.show(cluster, edgePadding: edgePadding, animated: true)
        } else if let annotation = cluster.firstAnnotation {
            mapView.clusterManager.selectAnnotation(annotation, animated: false)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let cluster = view.annotation as? CKCluster, cluster.count == 1 else {
            return
        }

        mapView.clusterManager.deselectAnnotation(cluster.firstAnnotation, animated: false)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let cluster = view.annotation as? CKCluster, cluster.count == 1, let location = cluster.firstAnnotation as? Store else {
            return
        }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
