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

    private static let ENVELOPE_RADIUS: Double = 0.1
    private static let baseUrlHMLPoint = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    private static let baseUrlHMLRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_NETWORK/FeatureServer/"
    private static let queryParamsHMLRoute = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    private static let layersHMLRoute = [9, 8, 6, 5, 3, 2]
    private static let baseUrlBridgeStructures = "https://services2.arcgis.com/18ajPSI0b3ppsmMt/ArcGIS/rest/services/Bridge_Structures/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    private static let baseUrlHPFVRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HPFV_Mass_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="

    public static func getHMLRoute(mapView: MKMapView, completion: (result: AnyObject) -> Void) {
        for layerID in layersHMLRoute {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let url = baseUrlHMLRoute + String(layerID) + queryParamsHMLRoute + Geometries.getVisibleAreaEnvelope(mapView)
            // print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
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
        // print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
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
        // print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
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
