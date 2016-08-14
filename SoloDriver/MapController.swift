//
//  FirstViewController.swift
//  SoloDriver
//
//  Created by HaoBoji on 13/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {

    @IBOutlet var mapView: MKMapView!

    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var navBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add current location button
        let currentLocationItem = MKUserTrackingBarButtonItem(mapView: mapView)
        navBar.topItem!.rightBarButtonItem = currentLocationItem
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.translucent = true
        navBar.backgroundColor = UIColor.clearColor()

        // Default location - Melbourne
        let lastLocation = LocationService.shared.getLastLocation()

//        if (lastLocation != nil) {
//            camera = GMSCameraPosition.cameraWithLatitude(
//                lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude, zoom: 10.0)
//        } else {
//            camera = GMSCameraPosition.cameraWithLatitude(-37.768356, longitude: 144.9663673, zoom: 8.0)
//        }
//        mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: camera)
//        mapView!.myLocationEnabled = true
//        mapView!.settings.compassButton = true
//        mapView!.settings.myLocationButton = true
//        mapView!.padding = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 60.0, right: 0.0)
//        self.view.insertSubview(mapView!, atIndex: 0)
    }

    @IBAction func searchThisArea(sender: UIButton) {
//        let cameraPosition = mapView!.camera.target
//        PublicDataService.getHMLRoute(cameraPosition) { (result) in
//            print(result)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

