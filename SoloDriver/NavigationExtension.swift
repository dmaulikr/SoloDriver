//
//  NavigationExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit

extension MasterController {
    
    func startNavigation() {
        self.titleItem.title = "End Navigation"
        var newDirectionSteps: [[DirectionPolyline]] = []
        // Remove candidate directions
        for step in directionSteps {
            // remove feature on map
            for polyline in step {
                if (polyline.renderer.strokeColor == UIColor.black.withAlphaComponent(0.9)) {
                    newDirectionSteps += [[polyline]]
                } else {
                    mapView.remove(polyline)
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
        // Hide nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Get route info
        self.navigationInstruction.text = directionSteps[0][0].route!.steps[0].instructions
        for step in directionSteps {
            let route = step[0].route
            for routeStep in route!.steps {
                let pointsArray = routeStep.polyline.points()
                let firstPoint = pointsArray[0]
                let firstLocation = MKCoordinateForMapPoint(firstPoint)
                print(routeStep.instructions)
                print(firstLocation.latitude)
            }
        }
    }
    
    func cancelNavigation() {
        // Display nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        mapView.userTrackingMode = .none
        self.titleItem.title = "Start Navigation"
        self.navigationInstruction.text = ""
        // Set camera
        let userCoordinate = LocationManager.shared.getLastLocation()!.coordinate
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: userCoordinate, eyeAltitude: 3000.0)
        mapView.setCamera(mapCamera, animated: true)
    }
}
