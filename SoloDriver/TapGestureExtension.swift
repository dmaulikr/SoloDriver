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
        for i in 0..<mapView.overlays.count {
            if (mapView.overlays[i] is DirectionPolyline) {
                let pickedPolyline = mapView.overlays[i] as! DirectionPolyline
                if Geometry.distanceOfPointAndLine(tapMapPoint, poly: pickedPolyline) > tapRadius() {
                    continue
                }
                // Colorize
                for j in 0..<mapView.overlays.count {
                    if let polyline = mapView.overlays[j] as? DirectionPolyline {
                        if (j == i) {
                            polyline.renderer.strokeColor = UIColor.black.withAlphaComponent(0.9)
                        } else {
                            polyline.renderer.strokeColor = UIColor.black.withAlphaComponent(0.3)
                        }
                    }
                }
                // Did find a direction route
                return
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
            let annotation = DestinationAnnotation()
            annotation.coordinate = tapCoordinate
            annotation.title = "Dropped Pin"
            annotation.subtitle = address
            self.addDestinationAnnotation(annotation: annotation)
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
