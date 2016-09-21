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
import SwiftyJSON

class ArcGISService: NSObject {
    
    static let backgroundQueue = DispatchQueue.global(qos: .background)
    static let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
    static let baseUrlHMLPoints = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    static let baseUrlBDoubleRoutes = "http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/B_Double_Route/FeatureServer/0"
    static let baseUrlHMLRoutes = "http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0"
    static let baseUrlHPFVRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HPFV_Mass_Route/FeatureServer/0"
    static let baseUrl2AxleSPVRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/2_Axle_SPV_Route/FeatureServer/0"
    static let baseUrl40tSPVRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/40t_SPV_Route/FeatureServer/0"
    static let baseUrlOSOMRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/OSOM_Route/FeatureServer/0"
    static let queryParamsRoutes = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&orderByFields=SUBJECT_PREF_RDNAME&returnIdsOnly=true&geometry="
    static let queryParamsRouteIds = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&objectIds="
    static let urlBridgeStructures = "https://services2.arcgis.com/18ajPSI0b3ppsmMt/ArcGIS/rest/services/Bridge_Structures/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&where=MIN_CLEARANCE%3E1+AND+MIN_CLEARANCE%3C"
    
    static func getBridgeStructures(completion: @escaping (_ result: String) -> Void) {
        SettingsManager.shared.networkON()
        let url = urlBridgeStructures + SettingsManager.shared.settings["Height (m)"].stringValue
        Alamofire.request(url).validate().responseString(queue: userInitiatedQueue) { response in
            SettingsManager.shared.networkOff()
            if (response.result.isFailure) {
                return
            }
            if let value = response.result.value {
                completion(value)
            }
        }
    }
    
    static func getRouteIds(envelope: String, route: String, completion: @escaping (_ result: String) -> Void) {
        if let url = getRouteUrl(route: route) {
            SettingsManager.shared.networkON()
            let urlForAllObjects = url + queryParamsRoutes + envelope
            // Get objectIds for the all routes
            Alamofire.request(urlForAllObjects).validate().responseString(queue: userInitiatedQueue) { response in
                SettingsManager.shared.networkOff()
                if (response.result.isFailure) {
                    return
                }
                completion(response.result.value!)
            }
        }
    }
    
    static func getRoutesByIds(objectIds: String, route: String, completion: @escaping (_ routes:String) -> Void) {
        let urlForSingleObject = getRouteUrl(route: route)! + queryParamsRouteIds + objectIds
        SettingsManager.shared.networkON()
        Alamofire.request(urlForSingleObject).validate().responseString(queue: backgroundQueue) { response in
            SettingsManager.shared.networkOff()
            if (response.result.isFailure) {
                return
            }
            completion(response.result.value!)
        }
        
    }
    
    static func getRouteUrl(route: String) -> String? {
        switch route {
        case "B-Doubles Routes":
            return baseUrlBDoubleRoutes
        case "HML Routes":
            return baseUrlHMLRoutes
        case "HPFV Routes":
            return baseUrlHPFVRoutes
        case "2 Axle SPV Routes":
            return baseUrl2AxleSPVRoutes
        case "40t SPV Routes":
            return baseUrl40tSPVRoutes
        case "OSOM Routes":
            return baseUrlOSOMRoutes
        default:
            return nil
        }
    }

}
