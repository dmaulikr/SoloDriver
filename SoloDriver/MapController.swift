//
//  FirstViewController.swift
//  SoloDriver
//
//  Created by HaoBoji on 13/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import SCLAlertView
import Instructions

class MapController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate {

    let coachMarksController = CoachMarksController()

    @IBOutlet var mapView: MKMapView!

    @IBOutlet var toolbar: UIToolbar!

    var currentTask: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = CategoriesController.currentCategory
        // Instructions
        self.coachMarksController.dataSource = self
        self.coachMarksController.overlayBackgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        // Maps
        self.mapView.delegate = self
        // Add bar buttons
        let trackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        let emptySpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: .None, action: nil)
        let modeButton = UIBarButtonItem(image: UIImage(named: "Info-111"), style: .Plain, target: .None, action: nil)
        toolbar.setItems([trackingButton, emptySpace, modeButton], animated: true)
        toolbar.translucent = true
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .Any)
        toolbar.backgroundColor = UIColor.clearColor()
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)

        // Set map camera
        var lastLocation = LocationService.shared.getLastLocation()
        var camera: MKMapCamera
        // Default location - Melbourne
        if (lastLocation == nil) {
            lastLocation = CLLocation(latitude: -37.768356, longitude: 144.9663673)
        }
        camera = MKMapCamera(lookingAtCenterCoordinate: lastLocation!.coordinate, fromEyeCoordinate: lastLocation!.coordinate, eyeAltitude: 50000)
        mapView.setCamera(camera, animated: false)

        // Register tap event
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapController.handleTap(_:)))
        singleTapRecognizer.numberOfTapsRequired = 1
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapController.handleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        singleTapRecognizer.delegate = self
        doubleTapRecognizer.delegate = self
        mapView.addGestureRecognizer(singleTapRecognizer)
        mapView.addGestureRecognizer(doubleTapRecognizer)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationItem.title != CategoriesController.currentCategory) {
            self.navigationItem.title = CategoriesController.currentCategory
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.coachMarksController.startOn(self)
    }

// For instructions
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController)
        -> Int {
            return 0
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex: Int)
        -> CoachMark {
            switch (coachMarksForIndex) {
            case 0:
                let leftBarButton = self.navigationItem.leftBarButtonItem! as UIBarButtonItem
                let viewLeft = leftBarButton.valueForKey("view") as! UIView
                return coachMarksController.coachMarkForView(viewLeft)
            case 1:
                let rightBarButton = self.navigationItem.rightBarButtonItem! as UIBarButtonItem
                let viewRight = rightBarButton.valueForKey("view") as! UIView
                return coachMarksController.coachMarkForView(viewRight)
            default:
                return coachMarksController.coachMarkForView()
            }
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark)
        -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
            let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
            coachViews.bodyView.hintLabel.text = "Hello! I'm a Coach Mark!"
            coachViews.bodyView.nextLabel.text = "Ok!"
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

// Handle tap event
    func handleTap(gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.locationInView(mapView)
        let tapCoordinate = mapView.convertPoint(location, toCoordinateFromView: mapView)
        let tapMapPoint = MKMapPointForCoordinate(tapCoordinate)
        switch CategoriesController.currentCategory {
        case CategoriesController.TITLE_HML:
            PublicDataService.getHMLPoint(tapCoordinate) { (result) in
                let roads = JSON(result)["features"]
                if (roads.count == 0) {
                    return
                }
                let polyline = Geometries.createHMLPolylineFrom(roads[0])
                let closestPoint = Geometries.getClosestPoint(tapMapPoint, poly: polyline)
                let annotation = Geometries.createHMLAnnotationFrom(roads[0], coordinate: closestPoint)
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
            break
        case CategoriesController.TITLE_HPFV:
            PublicDataService.getHPFVPoint(tapCoordinate) { (result) in
                let roads = JSON(result)["features"]
                if (roads.count == 0) {
                    return
                }
                let polyline = Geometries.createHPFVPolylineFrom(roads[0])
                let closestPoint = Geometries.getClosestPoint(tapMapPoint, poly: polyline)
                let annotation = Geometries.createHPFVAnnotationFrom(roads[0], coordinate: closestPoint)
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
            break
        default:
            break
        }

    }

    @IBAction func searchThisArea(sender: UIButton) {
        currentTask = (currentTask + 1) % 1024
        let thisTask = currentTask
        switch self.navigationItem.title! {
        case CategoriesController.TITLE_HML:
            PublicDataService.getHMLRoute(mapView) { (result) in
                // Draw lines in background
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let roads = JSON(result)["features"]
                    // Loop through roads
                    for (_, road): (String, JSON) in roads {
                        // let attributes = road["attributes"]
                        let roadPolyline = Geometries.createHMLPolylineFrom(road)
                        // let roadAnnotations = Geometries.createHMLAnnotationsFrom(road)
                        if (thisTask != self.currentTask) {
                            break
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.mapView.addOverlay(roadPolyline)
                            // self.mapView.addAnnotations(roadAnnotations)
                        })
                    }
                })
            }
            break
        case CategoriesController.TITLE_HPFV:
            PublicDataService.getHPFVRoute(mapView) { (result) in
                // Draw lines in background
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let roads = JSON(result)["features"]
                    // Loop through roads
                    for (_, road): (String, JSON) in roads {
                        let roadPolyline = Geometries.createHPFVPolylineFrom(road)
                        if (thisTask != self.currentTask) {
                            break
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.mapView.addOverlay(roadPolyline)
                        })
                    }
                })
            }
            break
        case CategoriesController.TITLE_BRIDGE:
            PublicDataService.getBridgeStructures(mapView, completion: { (result) in
                // Draw annotations in background
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let bridges = JSON(result)["features"]
                    // Loop through bridges
                    for (_, bridge): (String, JSON) in bridges {
                        let bridgeType = bridge["attributes"]["BRIDGE_TYPE"].stringValue
                        if (!(bridgeType.containsString("OVER ROAD") || bridgeType.containsString("PEDESTRIAN UNDERPASS"))) {
                            continue
                        }
                        if (bridge["attributes"]["MIN_CLEARANCE"].doubleValue <= 1) {
                            continue
                        }
                        let bridgeAnnotation = Geometries.createBridgeAnnotationFrom(bridge)
                        let bridgeAnnotationView = MKPinAnnotationView(annotation: bridgeAnnotation, reuseIdentifier: "bridge")
                        if (thisTask != self.currentTask) {
                            break
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.mapView.addAnnotation(bridgeAnnotationView.annotation!)
                        })
                    }
                })
            })
            break
        default:
            break
        }
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        currentTask = (currentTask + 1) % 1024
        switch segue.identifier! {
        case "CategoriesSeque":
            mapView.removeOverlays(mapView.overlays)
            CategoriesController.currentCategory = self.navigationItem.title!
            break
        default:
            return
        }
    }

// MARK:- MapViewDelegate methods
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is Geometries.ColorPolyline {
            let colorOverlay = overlay as! Geometries.ColorPolyline
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = colorOverlay.color
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }

// Annotation View
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is Geometries.BridgeAnnotation) {
            let reuseId = "bridge"
            var bridgeAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if bridgeAnnotationView == nil {
                bridgeAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                bridgeAnnotationView!.canShowCallout = true
                bridgeAnnotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                bridgeAnnotationView!.userInteractionEnabled = false
            } else {
                bridgeAnnotationView!.annotation = annotation
            }
            let bridgeAnnotation = annotation as! Geometries.BridgeAnnotation
            (bridgeAnnotationView! as! MKPinAnnotationView).pinTintColor = bridgeAnnotation.color
            bridgeAnnotationView!.rightCalloutAccessoryView!.tintColor = bridgeAnnotation.color
            return bridgeAnnotationView
        } else if (annotation is Geometries.HMLAnnotation) {
            let reuseId = "HML"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if (annotationView == nil) {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView

            } else {
                annotationView!.annotation = annotation
            }
            let annotation = annotation as! Geometries.HMLAnnotation
            annotationView!.rightCalloutAccessoryView!.tintColor = annotation.color
            return annotationView
        } else if (annotation is Geometries.HPFVAnnotation) {
            let reuseId = "HPFV"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if (annotationView == nil) {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView

            } else {
                annotationView!.annotation = annotation
            }
            let annotation = annotation as! Geometries.HPFVAnnotation
            annotationView!.rightCalloutAccessoryView!.tintColor = annotation.color
            return annotationView
        }
        return nil
    }

// Annotation View Callout
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (view.annotation is Geometries.AlertViewAnnotation) {
            let annotation = view.annotation as! Geometries.AlertViewAnnotation
            SCLAlertView(appearance: SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.mainScreen().bounds.width - 50))
                .showTitle(
                    annotation.title!,
                    subTitle: annotation.alertSubtitle!,
                    style: annotation.alertStyle!,
                    closeButtonTitle: "Close",
                    duration: 0,
                    colorStyle: annotation.alertColor!,
                    colorTextButton: 0xFFFFFF)

        }
    }
}

