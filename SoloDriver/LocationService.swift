//
//  LocationService.swift
//  SoloDriver
//
//  Created by HaoBoji on 13/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import Foundation
import CoreLocation

open class LocationService: NSObject, CLLocationManagerDelegate {

    fileprivate let manager: CLLocationManager

    // static instance
    open static let shared = LocationService()

    fileprivate override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.activityType = CLActivityType.automotiveNavigation
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.manager.delegate = self
    }

    open func start() {
        self.manager.requestWhenInUseAuthorization()
//        self.manager.requestAlwaysAuthorization()
//        self.manager.startUpdatingLocation()
//        self.manager.startMonitoringSignificantLocationChanges()
    }

    open func getLastLocation() -> CLLocation? {
        return manager.location
    }

    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // print(manager.location!.timestamp)
    }
}
