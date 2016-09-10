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

    var currentTask: Int = 0

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

    @IBAction func didClickFilter(sender: AnyObject) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("FilterNavigationController")
        controller.modalPresentationStyle = .FormSheet
        controller.modalTransitionStyle = .CoverVertical
        presentViewController(controller, animated: true) { }
    }

    @IBAction func didClickSettings(sender: AnyObject) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("SettingsNavigationController")
        controller.modalPresentationStyle = .FormSheet
        controller.modalTransitionStyle = .CoverVertical
        presentViewController(controller, animated: true) { }
    }

    @IBAction func didClickAction(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.view.tintColor = view.tintColor
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let clearMap = UIAlertAction(title: "Clear Map", style: .Default) { (action) in
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        let searchMap = UIAlertAction(title: "Search Map Area", style: .Default) { (action) in
            self.titleItem.title = action.title
            self.searchFeatures()
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(clearMap)
        actionSheet.addAction(searchMap)
        presentViewController(actionSheet, animated: true) { }
    }

    @IBOutlet var titleItem: UIBarButtonItem!
    @IBAction func didClickTitle(sender: AnyObject) {
        if (titleItem.title == "Search Map Area") {
            searchFeatures()
        }
    }

}
