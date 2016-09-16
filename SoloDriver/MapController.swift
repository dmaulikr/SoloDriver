////
////  FirstViewController.swift
////  SoloDriver
////
////  Created by HaoBoji on 13/08/2016.
////  Copyright © 2016 HaoBoji. All rights reserved.
////
//
//import UIKit
//import MapKit
//import SwiftyJSON
//import SCLAlertView
//
//class MapController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate {
//
//    let coachMarksController = CoachMarksController()
//    let SEARCH_TEXT = "Search this area"
//    let PLAN_TEXT = "Plan a route"
//
//    // For planning route
//    var wayPoints: [CLLocationCoordinate2D] = []
//
//    @IBOutlet var mapView: MKMapView!
//    @IBOutlet var toolbar: UIToolbar!
//    @IBOutlet var mainButton: UIButton!
//
//    var currentTask: Int = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.navigationItem.title = CategoriesController.currentCategory
//        // Instructions
//        self.coachMarksController.dataSource = self
//        self.coachMarksController.overlayBackgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
//        // Maps
//        self.mapView.delegate = self
//        // Set map camera
//        var lastLocation = LocationService.shared.getLastLocation()
//        var camera: MKMapCamera
//        // Default location - Melbourne
//        if (lastLocation == nil) {
//            lastLocation = CLLocation(latitude: -37.768356, longitude: 144.9663673)
//        }
//        camera = MKMapCamera(lookingAtCenter: lastLocation!.coordinate, fromEyeCoordinate: lastLocation!.coordinate, eyeAltitude: 50000)
//        mapView.setCamera(camera, animated: false)
//        // Add bar buttons
//        addToolBar()
//        // Register tap event
//        registerTapGesture()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if (self.navigationItem.title != CategoriesController.currentCategory) {
//            self.navigationItem.title = CategoriesController.currentCategory
//            self.clearMap()
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.coachMarksController.startOn(self)
//    }
//
//    // For instructions
//    func numberOfCoachMarksForCoachMarksController(_ coachMarkController: CoachMarksController)
//        -> Int {
//            return 0
//    }
//
//    // For instructions
//    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarksForIndex: Int)
//        -> CoachMark {
//            switch (coachMarksForIndex) {
//            case 0:
//                let leftBarButton = self.navigationItem.leftBarButtonItem! as UIBarButtonItem
//                let viewLeft = leftBarButton.value(forKey: "view") as! UIView
//                return coachMarksController.coachMarkForView(viewLeft)
//            case 1:
//                let rightBarButton = self.navigationItem.rightBarButtonItem! as UIBarButtonItem
//                let viewRight = rightBarButton.value(forKey: "view") as! UIView
//                return coachMarksController.coachMarkForView(viewRight)
//            default:
//                return coachMarksController.coachMarkForView()
//            }
//    }
//
//    // For instructions
//    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark)
//        -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
//            let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
//            coachViews.bodyView.hintLabel.text = "Hello! I'm a Coach Mark!"
//            coachViews.bodyView.nextLabel.text = "Ok!"
//            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
//    }
//
//    // Floating main button action
//    @IBAction func mainButton(_ sender: UIButton) {
//        switch sender.currentTitle! {
//        case SEARCH_TEXT:
//            displayFeatures()
//            break
//        case PLAN_TEXT:
//            loadCustomRoute()
//            break
//        default:
//            break
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        currentTask = (currentTask + 1) % 1024
//        switch segue.identifier! {
//        case "CategoriesSeque":
//            CategoriesController.currentCategory = self.navigationItem.title!
//            break
//        default:
//            return
//        }
//    }
//
//    // MARK:- MapViewDelegate methods, Polyline view
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is Geometries.ColorPolyline {
//            let colorOverlay = overlay as! Geometries.ColorPolyline
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = colorOverlay.color
//            if (overlay is Geometries.PlanPolyline) {
//                polylineRenderer.lineWidth = 5
//            } else {
//                polylineRenderer.lineWidth = 2
//            }
//            return polylineRenderer
//        }
//        return MKPolylineRenderer()
//    }
//
//    // MARK:- MapViewDelegate methods, Annotation View
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if (annotation is Geometries.BridgeAnnotation) {
//            let reuseId = "bridge"
//            var bridgeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//            if bridgeAnnotationView == nil {
//                bridgeAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//                bridgeAnnotationView!.canShowCallout = true
//                bridgeAnnotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//                bridgeAnnotationView!.isUserInteractionEnabled = false
//            } else {
//                bridgeAnnotationView!.annotation = annotation
//            }
//            let bridgeAnnotation = annotation as! Geometries.BridgeAnnotation
//            (bridgeAnnotationView! as! MKPinAnnotationView).pinTintColor = bridgeAnnotation.color
//            bridgeAnnotationView!.rightCalloutAccessoryView!.tintColor = bridgeAnnotation.color
//            return bridgeAnnotationView
//        } else if (annotation is Geometries.HMLAnnotation) {
//            let reuseId = "HML"
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//            if (annotationView == nil) {
//                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//                annotationView!.canShowCallout = true
//                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//                annotationView!.isUserInteractionEnabled = true
//            } else {
//                annotationView!.annotation = annotation
//            }
//            let annotation = annotation as! Geometries.HMLAnnotation
//            annotationView!.rightCalloutAccessoryView!.tintColor = annotation.color
//            return annotationView
//        } else if (annotation is Geometries.HPFVAnnotation) {
//            let reuseId = "HPFV"
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//            if (annotationView == nil) {
//                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//                annotationView!.canShowCallout = true
//                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//                annotationView!.isUserInteractionEnabled = true
//            } else {
//                annotationView!.annotation = annotation
//            }
//            let annotation = annotation as! Geometries.HPFVAnnotation
//            annotationView!.rightCalloutAccessoryView!.tintColor = annotation.color
//            return annotationView
//        } else if (annotation is Geometries.WayPointAnnotation) {
//            let reuseId = "WayPointAnnotation"
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//            if (annotationView == nil) {
//                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//                annotationView?.pinTintColor = UIColor.blue
//            } else {
//                annotationView!.annotation = annotation
//            }
//            return annotationView
//        }
//        return nil
//    }
//
//    // MARK:- MapViewDelegate methods, Annotation View Callout
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if (view.annotation is Geometries.AlertViewAnnotation) {
//            let annotation = view.annotation as! Geometries.AlertViewAnnotation
//            SCLAlertView(appearance: SCLAlertView.SCLAppearance(
//                kWindowWidth: UIScreen.main.bounds.width - 50))
//                .showTitle(
//                    annotation.title!,
//                    subTitle: annotation.alertSubtitle!,
//                    style: annotation.alertStyle!,
//                    closeButtonTitle: "Close",
//                    duration: 0,
//                    colorStyle: annotation.alertColor!,
//                    colorTextButton: 0xFFFFFF)
//
//        }
//    }
//
//    // Register tap gesture for searching features
//    func registerTapGesture() {
//        mapView.gestureRecognizers = []
//        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapController.tapHandler(_:)))
//        singleTapRecognizer.numberOfTapsRequired = 1
//        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: nil)
//        doubleTapRecognizer.numberOfTapsRequired = 2
//        singleTapRecognizer.require(toFail: doubleTapRecognizer)
//        singleTapRecognizer.delegate = self
//        doubleTapRecognizer.delegate = self
//        mapView.addGestureRecognizer(singleTapRecognizer)
//        mapView.addGestureRecognizer(doubleTapRecognizer)
//    }
//
//    // Add tool bar and its items
//    func addToolBar() {
//        let trackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
//        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: .none, action: nil)
//        let modeButton = UIBarButtonItem(image: UIImage(named: "Info-111"), style: .plain, target: .none, action: #selector(MapController.modeSwitchHandler(_:)))
//        toolbar.setItems([trackingButton, emptySpace, modeButton], animated: true)
//        toolbar.isTranslucent = true
//        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
//        toolbar.backgroundColor = UIColor.clear
//        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
//    }
//
//    // Handler: tap event for searching
//    func tapHandler(_ gestureReconizer: UITapGestureRecognizer) {
//        let location = gestureReconizer.location(in: mapView)
//        let tapCoordinate = mapView.convert(location, toCoordinateFrom: mapView)
//        if (mainButton.currentTitle == SEARCH_TEXT) {
//            let tapMapPoint = MKMapPointForCoordinate(tapCoordinate)
//            switch CategoriesController.currentCategory {
//            case CategoriesController.TITLE_HML:
//                PublicDataService.getHMLPoint(tapCoordinate) { (result) in
//                    let roads = JSON(result)["features"]
//                    if (roads.count == 0) {
//                        return
//                    }
//                    let polyline = Geometries.createHMLPolylineFrom(roads[0])
//                    let closestPoint = Geometries.getClosestPoint(tapMapPoint, poly: polyline)
//                    let annotation = Geometries.createHMLAnnotationFrom(roads[0], coordinate: closestPoint)
//                    self.mapView.addAnnotation(annotation)
//                    self.mapView.selectAnnotation(annotation, animated: true)
//                }
//                break
//            case CategoriesController.TITLE_HPFV:
//                PublicDataService.getHPFVPoint(tapCoordinate) { (result) in
//                    let roads = JSON(result)["features"]
//                    if (roads.count == 0) {
//                        return
//                    }
//                    let polyline = Geometries.createHPFVPolylineFrom(roads[0])
//                    let closestPoint = Geometries.getClosestPoint(tapMapPoint, poly: polyline)
//                    let annotation = Geometries.createHPFVAnnotationFrom(roads[0], coordinate: closestPoint)
//                    self.mapView.addAnnotation(annotation)
//                    self.mapView.selectAnnotation(annotation, animated: true)
//                }
//                break
//            default:
//                break
//            }
//        } else if (mainButton.currentTitle == PLAN_TEXT) {
//            let annotation = Geometries.WayPointAnnotation()
//            annotation.coordinate = tapCoordinate
//            wayPoints += [tapCoordinate]
//            mapView.addAnnotation(annotation)
//        }
//
//    }
//
//    // Handler: info button
//    func modeSwitchHandler(_ gestureReconizer: UITapGestureRecognizer) {
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let searchFeatures = UIAlertAction(title: "Search Features", style: .default) { (alert: UIAlertAction!) -> Void in
//            self.mainButton.setTitle(self.SEARCH_TEXT, for: UIControlState())
//
//        }
//        let planJourney = UIAlertAction(title: "Plan a Journey", style: .default) { (alert: UIAlertAction!) -> Void in
//            self.mainButton.setTitle(self.PLAN_TEXT, for: UIControlState())
//        }
//        let clearMap = UIAlertAction(title: "Clear Map", style: .default) { (alert: UIAlertAction!) -> Void in
//            self.clearMap()
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) in
//
//        }
//        actionSheet.addAction(clearMap)
//        actionSheet.addAction(searchFeatures)
//        actionSheet.addAction(planJourney)
//        actionSheet.addAction(cancel)
//        present(actionSheet, animated: true, completion: nil)
//    }
//
//    // Load features into map
//    func displayFeatures() {
//        currentTask = (currentTask + 1) % 1024
//        let thisTask = currentTask
//        switch self.navigationItem.title! {
//        case CategoriesController.TITLE_HML:
//            PublicDataService.getHMLRoute(mapView) { (result) in
//                // Draw lines in background
//                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                    let roads = JSON(result)["features"]
//                    // Loop through roads
//                    for (_, road): (String, JSON) in roads {
//                        // let attributes = road["attributes"]
//                        let roadPolyline = Geometries.createHMLPolylineFrom(road)
//                        // let roadAnnotations = Geometries.createHMLAnnotationsFrom(road)
//                        if (thisTask != self.currentTask) {
//                            break
//                        }
//                        DispatchQueue.main.async(execute: {
//                            self.mapView.add(roadPolyline)
//                            // self.mapView.addAnnotations(roadAnnotations)
//                        })
//                    }
//                })
//            }
//            break
//        case CategoriesController.TITLE_HPFV:
//            PublicDataService.getHPFVRoute(mapView) { (result) in
//                // Draw lines in background
//                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                    let roads = JSON(result)["features"]
//                    // Loop through roads
//                    for (_, road): (String, JSON) in roads {
//                        let roadPolyline = Geometries.createHPFVPolylineFrom(road)
//                        if (thisTask != self.currentTask) {
//                            break
//                        }
//                        DispatchQueue.main.async(execute: {
//                            self.mapView.add(roadPolyline)
//                        })
//                    }
//                })
//            }
//            break
//        case CategoriesController.TITLE_BRIDGE:
//            PublicDataService.getBridgeStructures(mapView, completion: { (result) in
//                // Draw annotations in background
//                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                    let bridges = JSON(result)["features"]
//                    // Loop through bridges
//                    for (_, bridge): (String, JSON) in bridges {
//                        let bridgeType = bridge["attributes"]["BRIDGE_TYPE"].stringValue
//                        if (!(bridgeType.contains("OVER ROAD") || bridgeType.contains("PEDESTRIAN UNDERPASS"))) {
//                            continue
//                        }
//                        if (bridge["attributes"]["MIN_CLEARANCE"].doubleValue <= 1) {
//                            continue
//                        }
//                        let bridgeAnnotation = Geometries.createBridgeAnnotationFrom(bridge)
//                        let bridgeAnnotationView = MKPinAnnotationView(annotation: bridgeAnnotation, reuseIdentifier: "bridge")
//                        if (thisTask != self.currentTask) {
//                            break
//                        }
//                        DispatchQueue.main.async(execute: {
//                            self.mapView.addAnnotation(bridgeAnnotationView.annotation!)
//                        })
//                    }
//                })
//            })
//            break
//        default:
//            break
//        }
//        mapView.removeOverlays(mapView.overlays)
//        mapView.removeAnnotations(mapView.annotations)
//    }
//
//    // Calculate a route based on waypoint
//    func loadCustomRoute() {
//        PublicDataService.getCustomRoute(wayPoints) { (result) in
//            let directions = JSON(result)
//            let overview_polyline = directions["routes"][0]["overview_polyline"]["points"].stringValue
//            if (overview_polyline == "") {
//                return
//            }
//            let planPolyline = Geometries.createPlanPolyline(overview_polyline)
//            self.mapView.add(planPolyline)
//        }
//    }
//
//    func clearMap() {
//        self.currentTask = (self.currentTask + 1) % 1024
//        self.wayPoints = []
//        self.mapView.removeOverlays(self.mapView.overlays)
//        self.mapView.removeAnnotations(self.mapView.annotations)
//    }
//}
//
