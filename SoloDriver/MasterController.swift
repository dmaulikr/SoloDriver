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
    var resultSearchController: UISearchController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // tracking button
        toolbarItems![0].width = -10
        toolbarItems![1] = MKUserTrackingBarButtonItem(mapView: mapView)
        toolbarItems![1].customView?.tintColor = view.tintColor
        navigationController?.isToolbarHidden = false
        // Add search bar
        initDirection()
        // Taps on map
        registerTapGestures()

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
            camera = MKMapCamera(lookingAtCenter: lastLocation!.coordinate, fromEyeCoordinate: lastLocation!.coordinate, eyeAltitude: 50000)
            mapView.setCamera(camera, animated: false)
        }
    }

    @IBAction func didClickFilter(_ sender: AnyObject) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "FilterNavigationController")
        controller.modalPresentationStyle = .formSheet
        controller.modalTransitionStyle = .coverVertical
        present(controller, animated: true) { }
    }

    @IBAction func didClickSettings(_ sender: AnyObject) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "SettingsNavigationController")
        controller.modalPresentationStyle = .formSheet
        controller.modalTransitionStyle = .coverVertical
        present(controller, animated: true) { }
    }

    @IBAction func didClickAction(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = view.tintColor
        actionSheet.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let clearMap = UIAlertAction(title: "Clear Map", style: .default) { (action) in
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        let searchMap = UIAlertAction(title: "Search Map Area", style: .default) { (action) in
            self.titleItem.title = action.title
            self.searchFeatures()
        }
        let addWaypoint = UIAlertAction(title: "Add Waypoint", style: .default) { (action) in
            // TODO
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(clearMap)
        actionSheet.addAction(addWaypoint)
        actionSheet.addAction(searchMap)
        present(actionSheet, animated: true) { }
    }

    @IBOutlet var titleItem: UIBarButtonItem!
    @IBAction func didClickTitle(_ sender: AnyObject) {
        if (titleItem.title == "Search Map Area") {
            searchFeatures()
        }
    }

}
