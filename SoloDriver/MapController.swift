//
//  FirstViewController.swift
//  SoloDriver
//
//  Created by HaoBoji on 13/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    override func loadView() {
        // Default location - Melbourne
        let camera: GMSCameraPosition
        let lastLocation = LocationService.shared.getLastLocation()
        if (lastLocation != nil) {
            camera = GMSCameraPosition.cameraWithLatitude(
                lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude, zoom: 10.0)
        } else {
            camera = GMSCameraPosition.cameraWithLatitude(-37.768356, longitude: 144.9663673, zoom: 8.0)
        }
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        let mapInsets = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 60.0, right: 0.0)
        mapView.padding = mapInsets
        self.view = mapView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

