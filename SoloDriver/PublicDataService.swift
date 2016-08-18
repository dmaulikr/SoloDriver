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

    /* URL example:
     http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_NETWORK/FeatureServer/2/query?f=json&returnGeometry=true&spatialRel=esriSpatialRelIntersects&maxAllowableOffset=2445&geometry=%7B%22xmin%22%3A15028131.257082991%2C%22ymin%22%3A-6261721.357115015%2C%22xmax%22%3A16280475.528506987%2C%22ymax%22%3A-5009377.08569102%2C%22spatialReference%22%3A%7B%22wkid%22%3A102100%2C%22latestWkid%22%3A3857%7D%7D&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100
     */

    private static let ENVELOPE_RADIUS: Double = 0.1
    private static let baseUrlHMLRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_NETWORK/FeatureServer/"
    private static let queryParamsHMLRoute = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    private static let layersHMLRoute = [9, 8, 6, 5, 3, 2]
    private static let baseUrlBridgeStructures = "https://services2.arcgis.com/18ajPSI0b3ppsmMt/ArcGIS/rest/services/Bridge_Structures/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="

    public static func getHMLRoute(mapView: MKMapView, completion: (result: AnyObject) -> Void) {
        for layerID in layersHMLRoute {
            let url = baseUrlHMLRoute + String(layerID) + queryParamsHMLRoute + Geometries.getVisibleAreaEnvelope(mapView)
            // print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
            Alamofire.request(.GET, url).validate().responseJSON { response in
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

    public static func getBridgeStructures(mapView: MKMapView, completion: (result: AnyObject) -> Void) {
        let url = baseUrlBridgeStructures + Geometries.getVisibleAreaEnvelope(mapView)
        print(url.stringByReplacingOccurrencesOfString("f=pjson&", withString: ""))
        Alamofire.request(.GET, url).validate().responseJSON { response in
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
