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
    
    static let baseUrlGoogleDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    static let GoogleApiKey = "AIzaSyAeKxLr3VG9Dnp4QX5aNDXvjLwHLPs67Wo"
    static let baseUrlHMLPoint = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    static let baseUrlHMLRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_NETWORK/FeatureServer/"
    static let queryParamsHMLRoute = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&orderByFields=SUBJECT_PREF_RDNAME&geometry="
    static let layersHMLRoute = [9, 8, 6, 5, 3, 2]
    static let baseUrlBridgeStructures = "https://services2.arcgis.com/18ajPSI0b3ppsmMt/ArcGIS/rest/services/Bridge_Structures/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    static let baseUrlHPFVRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HPFV_Mass_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    
    static func getBridgeStructures(_ mapView: MKMapView, completion: @escaping (_ result: String) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = baseUrlBridgeStructures + Geometry.getVisibleAreaEnvelope(mapView)
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
