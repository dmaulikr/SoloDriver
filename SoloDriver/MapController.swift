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

class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var navBar: UINavigationBar!

    var currentTask: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CategoriesController.currentCategory
        self.mapView.delegate = self
        // Add current location button
        let currentLocationItem = MKUserTrackingBarButtonItem(mapView: mapView)
        navBar.topItem!.rightBarButtonItem = currentLocationItem
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.translucent = true
        navBar.backgroundColor = UIColor.clearColor()

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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (self.title != CategoriesController.currentCategory) {
            self.title = CategoriesController.currentCategory
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
        }
    }

    @IBAction func searchThisArea(sender: UIButton) {
        currentTask = (currentTask + 1) % 1024
        let thisTask = currentTask
        switch self.title! {
        case CategoriesController.TITLE_HML:
            PublicDataService.getHMLRoute(mapView) { (result) in
                // Draw lines in background
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let roads = JSON(result)["features"]
                    // Loop through roads
                    for (_, road): (String, JSON) in roads {
                        // let attributes = road["attributes"]
                        let roadPolyline = Geometries.createHMLPolylineFrom(road)
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
        case CategoriesController.TITLE_HPFV:
            PublicDataService.getHPFVRoute(mapView) { (result) in
                // Draw lines in background
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let roads = JSON(result)["features"]
                    // Loop through roads
                    for (_, road): (String, JSON) in roads {
                        // let attributes = road["attributes"]
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
            CategoriesController.currentCategory = self.title!
            break
        default:
            return
        }
    }

    // MARK:- MapViewDelegate methods
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is Geometries.HMLPolyLine {
            let hmlOverlay = overlay as! Geometries.HMLPolyLine
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = hmlOverlay.color
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
            } else {
                bridgeAnnotationView!.annotation = annotation
            }
            let bridgeAnnotation = annotation as! Geometries.BridgeAnnotation
            (bridgeAnnotationView! as! MKPinAnnotationView).pinTintColor = bridgeAnnotation.color
            bridgeAnnotationView!.rightCalloutAccessoryView!.tintColor = bridgeAnnotation.color
            return bridgeAnnotationView
        }
        return nil
    }

    // Annotation View Callout
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if (view.annotation is Geometries.BridgeAnnotation) {
                let bridgeAnnotation = view.annotation as! Geometries.BridgeAnnotation
                SCLAlertView(appearance: SCLAlertView.SCLAppearance(
                    kWindowWidth: UIScreen.mainScreen().bounds.width - 20))
                    .showTitle(
                        bridgeAnnotation.title!,
                        subTitle: bridgeAnnotation.alertSubtitle!,
                        style: bridgeAnnotation.alertStyle!,
                        closeButtonTitle: "Close",
                        duration: 0,
                        colorStyle: bridgeAnnotation.alertColor!,
                        colorTextButton: 0xFFFFFF)

            }
        }
    }
}

