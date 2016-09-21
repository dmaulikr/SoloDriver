//
//  TapGestureExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 18/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit

extension MasterController {
    
    // Register tap gesture for searching destination
    func registerTapGestures() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        mapView.addGestureRecognizer(tapRecognizer)
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapHandler(_:)))
        longTapRecognizer.delegate = self
        mapView.addGestureRecognizer(longTapRecognizer)
    }
    
    func tapHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.view.endEditing(true)
        let tapPosition = gestureRecognizer.location(in: mapView)
        let tapCoordinate = mapView.convert(tapPosition, toCoordinateFrom: mapView)
        let tapMapPoint = MKMapPointForCoordinate(tapCoordinate)
        // Check which direction route is picked
        for directionPolylines in self.directionSteps {
            // For each step
            let numPolylines = directionPolylines.count
            if (numPolylines > 1) {
                var pickedIndex:Int? = nil
                // look for picked polyline
                for i in 0..<numPolylines {
                    let thisPolyline = directionPolylines[i]
                    if Geometry.distanceOfPointAndLine(tapMapPoint, poly: thisPolyline) < tapRadius() {
                        pickedIndex = i
                        break
                    }
                }
                // Colorize
                if (pickedIndex != nil) {
                    for i in 0..<numPolylines {
                        if (i == pickedIndex) {
                            directionPolylines[i].renderer.strokeColor = UIColor.black.withAlphaComponent(0.9)
                        } else {
                            directionPolylines[i].renderer.strokeColor = UIColor.black.withAlphaComponent(0.3)
                        }
                    }
                }
            }
        }
    }
    
    func longTapHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        self.navigationController?.view.endEditing(true)
        if (gestureRecognizer.state != .began) {
            return
        }
        let tapPosition = gestureRecognizer.location(in: mapView)
        let tapCoordinate = mapView.convert(tapPosition, toCoordinateFrom: mapView)
        let tapLocation = CLLocation(latitude: tapCoordinate.latitude, longitude: tapCoordinate.longitude)
        // Long tap to pick destination
        // Parse coordinate to address
        CLGeocoder().reverseGeocodeLocation(tapLocation) { (placemarks, error) in
            var address = "Unknow Place"
            if (error == nil && placemarks!.count > 0) {
                address = LocationManager.shared.parseAddress(placemarks![0])
            }
            if (self.titleItem.title == "Add Waypoint") {
                let annotation = WayPointAnnotation()
                annotation.coordinate = tapCoordinate
                annotation.title = "Waypoint " + String(self.waypoints.count + 1)
                annotation.subtitle = address
                self.waypoints += [annotation]
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            } else {
                let annotation = DestinationAnnotation()
                annotation.coordinate = tapCoordinate
                annotation.title = "Destination"
                annotation.subtitle = address
                self.addDestinationAnnotation(annotation: annotation)
            }
        }
    }
    
    
    func coordinateToMapItem(coordinate: CLLocationCoordinate2D) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
    }
    
    func tapRadius() -> Double {
        let mapRect = mapView.visibleMapRect;
        let metersPerMapPoint = MKMetersPerMapPointAtLatitude(mapView.centerCoordinate.latitude)
        let metersPerPixel = metersPerMapPoint * mapRect.size.width / Double(mapView.bounds.size.width)
        return metersPerPixel * 10
    }
}
