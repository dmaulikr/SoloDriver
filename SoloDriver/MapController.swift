//
//  FirstViewController.swift
//  SoloDriver
//
//  Created by HaoBoji on 13/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController {

    var mapView: GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Default location - Melbourne
        let camera: GMSCameraPosition
        let lastLocation = LocationService.shared.getLastLocation()
        if (lastLocation != nil) {
            camera = GMSCameraPosition.cameraWithLatitude(
                lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude, zoom: 10.0)
        } else {
            camera = GMSCameraPosition.cameraWithLatitude(-37.768356, longitude: 144.9663673, zoom: 8.0)
        }
        mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: camera)
        mapView!.myLocationEnabled = true
        mapView!.settings.compassButton = true
        mapView!.settings.myLocationButton = true
        mapView!.padding = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 60.0, right: 0.0)
        self.view.insertSubview(mapView!, atIndex: 0)
    }

    @IBAction func searchThisArea(sender: UIButton) {
        let cameraPosition = mapView!.camera.target
        let minX = cameraPosition.latitude * 100000 - 500
        let maxX = cameraPosition.latitude * 100000 + 500
        let minY = cameraPosition.longitude * 100000 - 1000
        let maxY = cameraPosition.longitude * 100000 + 1000
        print(minX)
        print(maxX)
        print(minY)
        print(maxY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

