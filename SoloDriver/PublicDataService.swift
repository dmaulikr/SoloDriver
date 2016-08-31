//
//  PublicDataService.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON
import MapKit

public class PublicDataService: NSObject {

    private static let baseUrlGoogleDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    private static let GoogleApiKey = "AIzaSyAeKxLr3VG9Dnp4QX5aNDXvjLwHLPs67Wo"
    private static let baseUrlHMLPoint = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    private static let baseUrlHMLRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_NETWORK/FeatureServer/"
    private static let queryParamsHMLRoute = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&orderByFields=SUBJECT_PREF_RDNAME&geometry="
    private static let layersHMLRoute = [9, 8, 6, 5, 3, 2]
    private static let baseUrlBridgeStructures = "https://services2.arcgis.com/18ajPSI0b3ppsmMt/ArcGIS/rest/services/Bridge_Structures/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    private static let baseUrlHPFVRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HPFV_Mass_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    private static let urlRestArea = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D'https%3A%2F%2Fwww.vicroads.vic.gov.au%2F~%2Fmedia%2FMedia%2FBusiness%2520and%2520Industry%2FRest%2520Areas%2Frestareadata'&format=json"

    // Query custom route based on location array
    public static func getCustomRoute(locations: [CLLocationCoordinate2D], completion: (result: AnyObject) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if (locations.count < 2) {
            return
        }
        let origin = formatLocation(locations[0])
        let destination = formatLocation(locations[locations.count - 1])
        var waypoints: String = ""
        if (locations.count > 2) {
            waypoints = formatLocation(locations[1])
        }
        if (locations.count > 3) {
            for i in 2...locations.count - 2 {
                waypoints += "|" + formatLocation(locations[i])
            }
        }
        let parameters = ["key": GoogleApiKey, "origin": origin, "destination": destination, "waypoints": waypoints]
        Alamofire.request(.GET, baseUrlGoogleDirections, parameters: parameters).validate().responseJSON { response in
            print(response.request?.URLString)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    completion(result: value)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    public static func getHMLRoute(mapView: MKMapView, completion: (result: AnyObject) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        for layerID in layersHMLRoute {
            let url = baseUrlHMLRoute + String(layerID) + queryParamsHMLRoute + Geometries.getVisibleAreaEnvelope(mapView)
            print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
            Alamofire.request(.GET, url).validate().responseJSON { response in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        completion(result: value)
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }

    public static func getHMLPoint(coordinate: CLLocationCoordinate2D, completion: (result: AnyObject) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = baseUrlHMLPoint + Geometries.getTapEnvelope(coordinate)
        print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
        Alamofire.request(.GET, url).validate().responseJSON { response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    completion(result: value)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    public static func getBridgeStructures(mapView: MKMapView, completion: (result: AnyObject) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = baseUrlBridgeStructures + Geometries.getVisibleAreaEnvelope(mapView)
        print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
        Alamofire.request(.GET, url).validate().responseJSON { response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    completion(result: value)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    public static func getHPFVRoute(mapView: MKMapView, completion: (result: AnyObject) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = baseUrlHPFVRoute + Geometries.getVisibleAreaEnvelope(mapView)
        print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
        Alamofire.request(.GET, url).validate().responseJSON { response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    completion(result: value)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    public static func getHPFVPoint(coordinate: CLLocationCoordinate2D, completion: (result: AnyObject) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = baseUrlHPFVRoute + Geometries.getTapEnvelope(coordinate)
        print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
        Alamofire.request(.GET, url).validate().responseJSON { response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    completion(result: value)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    private static func formatLocation(location: CLLocationCoordinate2D) -> String {
        return String(location.latitude) + "," + String(location.longitude)
    }
}
