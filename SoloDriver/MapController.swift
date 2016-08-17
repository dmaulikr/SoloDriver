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

class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var navBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CategoriesController.TITLE_HML
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
        self.title = CategoriesController.currentCategory
    }

    @IBAction func searchThisArea(sender: UIButton) {
        mapView.removeOverlays(mapView.overlays)
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
                        dispatch_async(dispatch_get_main_queue(), {
                            self.mapView.addOverlay(roadPolyline)
                        })
                    }
                })
            }
            break
        default:
            break
        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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

}

