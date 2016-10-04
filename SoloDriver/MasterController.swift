//
//  MasterController.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import Instructions

class MasterController: UIViewController {
    
    var resultSearchController: UISearchController?
    let coachMarksController = CoachMarksController()
    let speechSynthesizer = AVSpeechSynthesizer()
    var userTrackingButton: MKUserTrackingBarButtonItem?
    var annotationTaskId: Int = 0
    var polylineTaskId: Int = 0
    var directionSteps: [[DirectionPolyline]] = []
    var waypoints: [WayPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tracking button
        toolbarItems![0].width = -10
        userTrackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        toolbarItems![1] = userTrackingButton!
        toolbarItems![1].customView?.tintColor = view.tintColor
        navigationController?.isToolbarHidden = false
        // Add search bar
        initDirection()
        // Taps on map
        registerTapGestures()
        // Instructions
        initInstructions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearMap()
        getAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.endEditing(true)
        if (SettingsManager.shared.settings["InstructionIsEnabled"].bool != false) {
            SettingsManager.shared.settings["InstructionIsEnabled"].bool = false
            SettingsManager.shared.saveSettings()
            clearMap()
            self.coachMarksController.startOn(self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resultSearchController?.isActive = false
        self.coachMarksController.stop(immediately: true)
    }
    
    @IBOutlet var mapView: MKMapView! {
        didSet {
            // Set map camera
            var lastLocation = LocationManager.shared.getLastLocation()
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
    
    @IBOutlet var actionItem: UIBarButtonItem!
    @IBAction func didClickAction(_ sender: AnyObject) {
        if (titleItem.title == "End Navigation") {
            return
        }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = view.tintColor
        actionSheet.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let clearMap = UIAlertAction(title: "Clear Map", style: .default) { (action) in
            self.clearMap()
        }
        let searchMap = UIAlertAction(title: "Search Map Area", style: .default) { (action) in
            self.titleItem.title = action.title
            self.polylineTaskId += 1
            self.getRoutes()
        }
        let addWaypoint = UIAlertAction(title: "Add Waypoint", style: .default) { (action) in
            self.titleItem.title = action.title
        }
        let checkHandbooks = UIAlertAction(title: "Check Handbooks", style: .default) { (action) in
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "DocumentsNavigationController")
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(clearMap)
        actionSheet.addAction(addWaypoint)
        actionSheet.addAction(searchMap)
        actionSheet.addAction(checkHandbooks)
        present(actionSheet, animated: true) { }
    }
    
    @IBOutlet var titleItem: UIBarButtonItem!
    @IBAction func didClickTitle(_ sender: AnyObject) {
        if (titleItem.title == "Search Map Area") {
            clearRoutes()
            getRoutes()
        } else if (titleItem.title == "Start Navigation") {
            startNavigation()
        } else if (titleItem.title == "End Navigation") {
            cancelNavigation()
        }
    }
    
    @IBOutlet var navigationInstruction: UILabel! {
        didSet {
            navigationInstruction.text = ""
        }
    }
    
    @IBOutlet var alertInstruction: UILabel! {
        didSet {
            alertInstruction.text = ""
        }
    }
    
    func clearMap() {
        self.titleItem.title = "Search Map Area"
        self.annotationTaskId += 1
        self.polylineTaskId += 1
        self.directionSteps = []
        self.waypoints = []
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    func clearRoutes() {
        polylineTaskId += 1
        for overlay in mapView.overlays {
            if (overlay is RoutePolyline) {
                mapView.remove(overlay)
            }
        }
        for annotation in mapView.annotations {
            if (annotation is RouteAnnotation) {
                mapView.removeAnnotation(annotation)
            }
        }
    }
}
