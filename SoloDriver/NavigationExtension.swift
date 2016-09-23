//
//  NavigationExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

protocol MasterControllerDelegate {
    func updateInstruction(instruction: LocationInstruction)
}

extension MasterController: MasterControllerDelegate {
    
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
        // Direction instructions
        var locationInstructions: [LocationInstruction] = []
        for step in directionSteps {
            let route = step[0].route
            for routeStep in route!.steps {
                locationInstructions += [createInstructionFrom(routeStep: routeStep)]
            }
        }
        // Feature instructions
        for annotation in mapView.annotations {
            if (annotation is BridgeAnnotation || annotation is VicTrafficAnnotation) {
                let locationInstruction = LocationInstruction()
                locationInstruction.location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                locationInstruction.radius = 1000
                locationInstruction.instruction = annotation.title!! + "\n" + annotation.subtitle!!
                locationInstructions += [locationInstruction]
            }
        }
        LocationManager.shared.locationInstructions = locationInstructions
        LocationManager.shared.delegate = self
    }
    
    func cancelNavigation() {
        // Display nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        mapView.userTrackingMode = .none
        self.titleItem.title = "Start Navigation"
        self.navigationInstruction.text = ""
        LocationManager.shared.locationInstructions = []
        // Set camera
        let userCoordinate = LocationManager.shared.getLastLocation()!.coordinate
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: userCoordinate, eyeAltitude: 3000.0)
        mapView.setCamera(mapCamera, animated: true)
    }
    
    func createInstructionFrom(routeStep: MKRouteStep) -> LocationInstruction {
        let pointsArray = routeStep.polyline.points()
        let firstPoint = pointsArray[0]
        let firstCoordinate = MKCoordinateForMapPoint(firstPoint)
        let firstLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
        let locationInstruction = LocationInstruction()
        locationInstruction.location = firstLocation
        locationInstruction.instruction = routeStep.instructions
        locationInstruction.radius = 32
        locationInstruction.isNavInstruction = true
        return locationInstruction
    }
    
    func updateInstruction(instruction: LocationInstruction) {
        if (instruction.isNavInstruction) {
            self.navigationInstruction.text = instruction.instruction
        } else {
            self.alertInstruction.text = instruction.instruction
            let deadline = DispatchTime.now() + .seconds(10)
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                if (self.alertInstruction.text == instruction.instruction) {
                    self.alertInstruction.text = ""
                }
            })
        }
        pronounceInstruction(instruction: instruction.instruction!)
    }
    
    func pronounceInstruction(instruction: String) {
        let speechUtterance = AVSpeechUtterance(string: instruction)
        speechSynthesizer.speak(speechUtterance)
    }
}

class LocationInstruction: NSObject {
    var location: CLLocation?
    var instruction: String?
    var radius: CLLocationDistance?
    var isNavInstruction = false
}
