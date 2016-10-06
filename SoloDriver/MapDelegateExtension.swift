//
//  MapExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SCLAlertView

extension MasterController: MKMapViewDelegate {
    
    // MARK:- MapViewDelegate methods, Polyline view
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is ColorPolyline {
            let colorOverlay = overlay as! ColorPolyline
            let renderer = colorOverlay.renderer
            if (overlay is DirectionPolyline) {
                renderer.lineWidth = 5
            }
            return renderer
        }
        return MKPolylineRenderer()
    }
    
    // MARK:- MapViewDelegate methods, Annotation View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is AlertViewAnnotation) {
            let thisAnnotation = annotation as! AlertViewAnnotation
            let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: thisAnnotation.reuseId)
            return thisAnnotation.createPinView(pinView)
        } else if (annotation is DestinationAnnotation) {
            let thisAnnotation = annotation as! DestinationAnnotation
            let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: thisAnnotation.reuseId)
            return thisAnnotation.createPinView(pinView)
        } else if (annotation is WayPointAnnotation) {
            let thisAnnotation = annotation as! WayPointAnnotation
            let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: thisAnnotation.reuseId)
            return thisAnnotation.createPinView(pinView)
        }
        return nil
    }
    
    // MARK:- MapViewDelegate methods, Annotation View Callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (view.annotation is AlertViewAnnotation) {
            let annotation = view.annotation as! AlertViewAnnotation
            var width = UIScreen.main.bounds.width - 50
            if (width > 400) {
                width = 400
            }
            _ = SCLAlertView(appearance: SCLAlertView.SCLAppearance(
                kWindowWidth: width))
                .showTitle(
                    annotation.alertTitle!,
                    subTitle: annotation.alertSubtitle!,
                    style: annotation.alertStyle!,
                    closeButtonTitle: "Close",
                    duration: 0,
                    colorStyle: annotation.alertColor!,
                    colorTextButton: 0xFFFFFF)
        } else if (view.annotation is DestinationAnnotation) {
            let annotation = view.annotation as! DestinationAnnotation
            getDirection(destinationAnnotation: annotation)
        } else if (view.annotation is WayPointAnnotation) {
            let thisAnnotation = view.annotation as! WayPointAnnotation
            for i in 0..<waypoints.count {
                if (waypoints[i] == thisAnnotation) {
                    waypoints.remove(at: i)
                    break
                }
            }
            mapView.removeAnnotation(view.annotation!)
            for i in 0..<waypoints.count {
                waypoints[i].title = "Waypoint " + String(i + 1)
            }
        }
    }
    
    // MARK: region did change
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Tracking mode
        if (self.titleItem.title == "End Navigation") {
            mapView.userTrackingMode = .followWithHeading
        }
        // Title
        if (titleItem.title == "Search Map Area" || titleItem.title == "Auto Searching ...") {
            if (mapView.camera.altitude < 10000) {
                self.titleItem.title = "Auto Searching ..."
            } else  {
                self.titleItem.title = "Search Map Area"
            }
        }
        // Searching
        if (mapView.camera.altitude < 10000) {
            getRoutes()
        }
    }
}
