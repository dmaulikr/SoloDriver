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
        if overlay is ColorPolyline {
            let colorOverlay = overlay as! ColorPolyline
            return colorOverlay.renderer
        }
        return MKPolylineRenderer()
    }

    // MARK:- MapViewDelegate methods, Annotation View
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is BridgeAnnotation) {
            let thisAnnotation = annotation as! BridgeAnnotation
            let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(thisAnnotation.reuseId)
            return thisAnnotation.createPinView(pinView)
        } else if (annotation is DestinationAnnotation) {
            let thisAnnotation = annotation as! DestinationAnnotation
            let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(thisAnnotation.reuseId)
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

        } else if (view.annotation is DestinationAnnotation) {
            let annotation = view.annotation as! DestinationAnnotation
            getDirection(annotation)
        }
    }
}
