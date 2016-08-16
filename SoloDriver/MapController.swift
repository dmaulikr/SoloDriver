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

    @IBAction func searchThisArea(sender: UIButton) {
        PublicDataService.getHMLRoute(mapView.camera.centerCoordinate) { (roads) in
            // Loop through roads
            for (_, road): (String, JSON) in roads {
                // let attributes = road["attributes"]
                var pointsToUse: [CLLocationCoordinate2D] = []
                let paths = road["geometry"]["paths"][0]
                // Loop road points
                for (_, point): (String, JSON) in paths {
                    let coordinate = CLLocationCoordinate2D(latitude: point[1].doubleValue, longitude: point[0].doubleValue)
                    pointsToUse += [coordinate]
                }
                let roadPolyline = Geometries.HMLPolyLine(coordinates: &pointsToUse, count: paths.count)
                // Set color
                switch road["attributes"]["HVR_HML"].stringValue {
                case "Approved":
                    roadPolyline.color = Geometries.GREEN
                    break
                case "Conditionally Approved":
                    roadPolyline.color = Geometries.ORANGE
                    break
                case "Restricted":
                    roadPolyline.color = Geometries.RED
                    break
                default:
                    roadPolyline.color = UIColor.clearColor()
                }
                self.mapView.addOverlay(roadPolyline)
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- MapViewDelegate methods
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is Geometries.HMLPolyLine {
            let hmlOverlay = overlay as! Geometries.HMLPolyLine
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = hmlOverlay.color
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }

}

