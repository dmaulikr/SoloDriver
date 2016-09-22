//
//  NavigationExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit

extension MasterController{
    
    func startNavigation() {
        self.titleItem.title = "End Navigation"
        var newDirectionSteps: [[DirectionPolyline]] = [[]]
        // Remove candidate directions
        for step in directionSteps {
            // remove feature on map
            for polyline in step {
                if (polyline.renderer.strokeColor != UIColor.black.withAlphaComponent(0.9)) {
                    mapView.remove(polyline)
                }
            }
            // get picked directions
            for polyline in step {
                if (polyline.renderer.strokeColor == UIColor.black.withAlphaComponent(0.9)) {
                    newDirectionSteps += [[polyline]]
                    break
                }
            }
        }
        self.directionSteps = newDirectionSteps
        // Set camera
        let userCoordinate = LocationManager.shared.getLastLocation()!.coordinate
        var eyeCoordinate = CLLocationCoordinate2D()
        eyeCoordinate.latitude = userCoordinate.latitude - 0.03
        eyeCoordinate.longitude = userCoordinate.longitude
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 3000.0)
        mapView.setCamera(mapCamera, animated: true)
    }
    
    func cancelNavigation() {
        self.titleItem.title = "Search Map Area"
    }
}
