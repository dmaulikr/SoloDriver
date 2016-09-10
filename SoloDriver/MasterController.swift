//
//  MasterController.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit

class MasterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // tracking button
        toolbarItems![0].width = -10
        toolbarItems![1] = MKUserTrackingBarButtonItem(mapView: mapView)
        toolbarItems![1].customView?.tintColor = view.tintColor
        navigationController?.toolbarHidden = false

    }

    @IBOutlet var mapView: MKMapView! {
        didSet {
            // Set map camera
            var lastLocation = LocationService.shared.getLastLocation()
            var camera: MKMapCamera
            // Default location - Melbourne
            if (lastLocation == nil) {
                lastLocation = CLLocation(latitude: -37.768356, longitude: 144.9663673)
            }
            camera = MKMapCamera(lookingAtCenterCoordinate: lastLocation!.coordinate, fromEyeCoordinate: lastLocation!.coordinate, eyeAltitude: 50000)
            mapView.setCamera(camera, animated: false)
        }
    }

    @IBAction func fiterItem(sender: AnyObject) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("FilterNavigationController")
        controller.modalPresentationStyle = .FormSheet
        controller.modalTransitionStyle = .CoverVertical
        presentViewController(controller, animated: true) { }
    }

    @IBAction func settingsItem(sender: AnyObject) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("SettingsNavigationController")
        controller.modalPresentationStyle = .FormSheet
        controller.modalTransitionStyle = .CoverVertical
        presentViewController(controller, animated: true) { }
    }

}
