//
//  LocationService.swift
//  SoloDriver
//
//  Created by HaoBoji on 13/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import Foundation
import CoreLocation

open class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // static instance
    open static let shared = LocationManager()
    
    let manager: CLLocationManager
    var locationInstructions: [LocationInstruction] = [] {
        didSet {
            if (locationInstructions.count == 0) {
                queuedInstructions = []
            } else {
                delegate?.updateInstruction(instruction: locationInstructions[0])
                locationInstructions.remove(at: 0)
            }
        }
    }
    var queuedInstructions: [LocationInstruction] = []
    var delegate: MasterControllerDelegate?
    
    override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.activityType = CLActivityType.automotiveNavigation
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.manager.delegate = self
    }
    
    func start() {
        // self.manager.requestAlwaysAuthorization()
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        // self.manager.startMonitoringSignificantLocationChanges()
    }
    
    func getLastLocation() -> CLLocation? {
        return manager.location
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for i in 0..<queuedInstructions.count {
            if (queuedInstructions[i].location!.distance(from: locations.last!) > queuedInstructions[i].radius!) {
                delegate?.updateInstruction(instruction: queuedInstructions[i])
                queuedInstructions.remove(at: i)
                break
            }
        }
        
        for i in 0..<locationInstructions.count {
            if (locationInstructions[i].location!.distance(from:locations.last!) < locationInstructions[i].radius!) {
                if (locationInstructions[i].isNavInstruction) {
                    queuedInstructions += [locationInstructions[i]]
                } else {
                    delegate?.updateInstruction(instruction: locationInstructions[i])
                }
                locationInstructions.remove(at: i)
                break
            }
        }
    }
    
    // Adapted from https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    func parseAddress(_ selectedItem: CLPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let addressLine = String(
            format: "%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? ""
        )
        return addressLine
    }
}
