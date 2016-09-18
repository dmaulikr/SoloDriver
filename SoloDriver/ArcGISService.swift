//
//  ArcGISService.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ArcGISService: NSObject {
    
    static let baseUrlHMLPoint = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    static let baseUrlHMLRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_NETWORK/FeatureServer/"
    static let queryParamsHMLRoute = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&orderByFields=SUBJECT_PREF_RDNAME&geometry="
    static let layersHMLRoute = [9, 8, 6, 5, 3, 2]
    static let urlBridgeStructures = "https://services2.arcgis.com/18ajPSI0b3ppsmMt/ArcGIS/rest/services/Bridge_Structures/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&where=MIN_CLEARANCE%3E1"
    static let baseUrlHPFVRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HPFV_Mass_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    
    static func getBridgeStructures(_ mapView: MKMapView, completion: @escaping (_ result: String) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(urlBridgeStructures).validate().responseString { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if (response.result.isFailure) {
                getBridgeStructures(mapView, completion: { (newResult) in
                    completion(newResult)
                })
                return
            }
            if let value = response.result.value {
                completion(value)
            }
        }
    }
    
    static func getRoutes(mapView: MKMapView, route: String, completion: @escaping (_ result: String) -> Void) {
        var urls: [String] = []
        switch route {
        case "B-Doubles Routes":
            break
        case "HML Routes":
            for layerId in layersHMLRoute {
                let url = baseUrlHMLRoute + String(layerId) + queryParamsHMLRoute + Geometry.getVisibleAreaEnvelope(mapView)
                urls += [url]
            }
            break
        case "HPFV Routes":
            break
        case "2 Axle SPV Routes":
            break
        case "40t SPV Routes":
            break
        case "OSOM Routes":
            break
        default:
            return
        }
        // execute
        for url in urls {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            Alamofire.request(url).validate().responseString { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if (response.result.isFailure) {
                    return
                }
                if let value = response.result.value {
                    completion(value)
                }
            }
        }
        
    }
    
}
