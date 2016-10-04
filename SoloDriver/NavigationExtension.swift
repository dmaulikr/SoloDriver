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
        // Display first instruction
        let instruction = createInstructionFrom(routeStep: directionSteps[0][0].route!.steps[0])
        updateInstruction(instruction: instruction[0])
        // Direction instructions
        var locationInstructions: [LocationInstruction] = []
        for step in directionSteps {
            let route = step[0].route
            for routeStep in route!.steps {
                locationInstructions += createInstructionFrom(routeStep: routeStep)
            }
        }
        // Feature instructions
        for annotation in mapView.annotations {
            if (annotation is AlertViewAnnotation) {
                let thisAnnotation = annotation as! AlertViewAnnotation
                if (thisAnnotation.image == nil) {
                    continue
                }
                let locationInstruction = LocationInstruction()
                locationInstruction.location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                locationInstruction.radius = 1000
                locationInstruction.text = annotation.title!! + "\n" + annotation.subtitle!!
                locationInstruction.voice = thisAnnotation.alertTitle! + ".\n" + thisAnnotation.alertSubtitle!
                locationInstructions += [locationInstruction]
            }
        }
        LocationManager.shared.locationInstructions = locationInstructions
        LocationManager.shared.delegate = self
    }
    
    func cancelNavigation() {
        // Stop speaking
        speechSynthesizer.stopSpeaking(at: .word)
        // Reset UI
        self.titleItem.title = "Start Navigation"
        self.navigationInstruction.text = ""
        self.alertInstruction.text = ""
        // Display nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        LocationManager.shared.locationInstructions = []
        // Reset map
        mapView.userTrackingMode = .none
        // Set camera
        let userCoordinate = LocationManager.shared.getLastLocation()!.coordinate
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: userCoordinate, eyeAltitude: 3000.0)
        mapView.setCamera(mapCamera, animated: true)
    }
    
    func createInstructionFrom(routeStep: MKRouteStep) -> [LocationInstruction] {
        let pointsArray = routeStep.polyline.points()
        let firstCoordinate = MKCoordinateForMapPoint(pointsArray[0])
        let firstLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
        let lastCoordinate = MKCoordinateForMapPoint(pointsArray[routeStep.polyline.pointCount - 1])
        let lastLocation = CLLocation(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude)
        // start point notification
        let startInstruction = LocationInstruction()
        startInstruction.location = firstLocation
        let distance = Int(firstLocation.distance(from: lastLocation)/100) * 100
        if (distance != 0) {
            startInstruction.voice = "In " + String(distance) + "m, " + routeStep.instructions
        } else {
            startInstruction.voice = routeStep.instructions
        }
        startInstruction.text = routeStep.instructions
        startInstruction.radius = 32
        startInstruction.notifyWhenExit = true
        startInstruction.isNavInstruction = true
        // end point notification
        let endInstruction = LocationInstruction()
        endInstruction.location = lastLocation
        endInstruction.text = routeStep.instructions
        endInstruction.voice = endInstruction.text
        endInstruction.radius = 128
        endInstruction.isNavInstruction = true
        return [startInstruction, endInstruction]
    }
    
    func updateInstruction(instruction: LocationInstruction) {
        // Check whether to process
        if (titleItem.title != "End Navigation") {
            return
        }
        // Discard far away notification
        if (instruction.location!.distance(from: LocationManager.shared.getLastLocation()!) > 1000) {
            return
        }
        if (instruction.isNavInstruction) {
            self.navigationInstruction.text = instruction.text
            let speechUtterance = AVSpeechUtterance(string: instruction.voice!)
            speechSynthesizer.stopSpeaking(at: .immediate)
            speechSynthesizer.speak(speechUtterance)
        } else if (self.alertInstruction.text == "" && !speechSynthesizer.isSpeaking) {
            self.alertInstruction.text = instruction.text
            let speechUtterance = AVSpeechUtterance(string: instruction.voice!)
            speechSynthesizer.speak(speechUtterance)
            let deadline = DispatchTime.now() + .seconds(16)
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                self.alertInstruction.text = ""
            })
        } else {
            let deadline = DispatchTime.now() + .seconds(10)
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                self.updateInstruction(instruction: instruction)
            })
        }
    }
}

class LocationInstruction: NSObject {
    var location: CLLocation?
    var voice: String?
    var text: String?
    var radius: CLLocationDistance?
    var notifyWhenExit = false
    var isNavInstruction = false
}
