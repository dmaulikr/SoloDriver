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
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is Geometries.ColorPolyline {
            let colorOverlay = overlay as! Geometries.ColorPolyline
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = colorOverlay.color
            if (overlay is Geometries.PlanPolyline) {
                polylineRenderer.lineWidth = 5
            } else {
                polylineRenderer.lineWidth = 2
            }
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }

    // MARK:- MapViewDelegate methods, Annotation View
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is BridgeAnnotation) {
            let thisAnnotation = annotation as! BridgeAnnotation
            let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(thisAnnotation.reuseId) as? MKPinAnnotationView
            return thisAnnotation.createPinView(pinView)
        }
        return nil
    }

    // MARK:- MapViewDelegate methods, Annotation View Callout
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (view.annotation is AlertViewAnnotation) {
            let annotation = view.annotation as! AlertViewAnnotation
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
