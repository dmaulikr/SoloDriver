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
    static let baseUrlHMLPoints = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&geometry="
    static let baseUrlBDoubleRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/B_DOUBLE_NETWORK/FeatureServer/"
    static let baseUrlHMLRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_NETWORK/FeatureServer/"
    static let baseUrlHPFVRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HPFV_Mass_Route/FeatureServer/0"
    static let baseUrl2AxleSPVRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/2_Axle_SPV_Route/FeatureServer/0"
    static let baseUrl40tSPVRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/40t_SPV_Route/FeatureServer/0"
    static let baseUrlOSOMRoutes = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/OSOM_Route/FeatureServer/0"
    static let queryParamsRoutes = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&orderByFields=SUBJECT_PREF_RDNAME&returnIdsOnly=true&geometry="
    static let queryParamsRouteIds = "/query?f=pjson&outSR=4326&inSR=4326&outFields=*&objectIds="
    static let layers = [9, 8, 6, 5, 3, 2]
    static let urlBridgeStructures = "https://services2.arcgis.com/18ajPSI0b3ppsmMt/ArcGIS/rest/services/Bridge_Structures/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&where=MIN_CLEARANCE%3E1+AND+MIN_CLEARANCE%3C"
    
    static func getBridgeStructures(completion: @escaping (_ result: String) -> Void) {
        SettingsManager.shared.networkON()
        let url = urlBridgeStructures + SettingsManager.shared.settings["Height (m)"].stringValue
        Alamofire.request(url).validate().responseString { response in
            SettingsManager.shared.networkOff()
            if (response.result.isFailure) {
                return
            }
            if let value = response.result.value {
                completion(value)
            }
        }
    }
    
    static func getRoutes(envelope: String, route: String, completion: @escaping (_ name: String, _ result: String?) -> Void) {
        var urls: [String] = []
        var name: String = ""
        switch route {
        case "B-Doubles Routes":
            name = "B_DOUBLE"
            for layerId in layers {
                let url = baseUrlBDoubleRoutes + String(layerId)
                urls += [url]
            }
            break
        case "HML Routes":
            name = "HML"
            for layerId in layers {
                let url = baseUrlHMLRoutes + String(layerId)
                urls += [url]
            }
            break
        case "HPFV Routes":
            name = "HPFV_MASS"
            urls = [baseUrlHPFVRoutes]
            break
        case "2 Axle SPV Routes":
            name = "SPV_2AXLE"
            urls = [baseUrl2AxleSPVRoutes]
            break
        case "40t SPV Routes":
            name = "SPV_40T"
            urls = [baseUrl40tSPVRoutes]
            break
        case "OSOM Routes":
            name = "OSOM_SCHEME_PERMIT"
            urls = [baseUrlOSOMRoutes]
            break
        default:
            return
        }
        // execute for all urls
        for url in urls {
            SettingsManager.shared.networkON()
            let urlForAllObjects = url + queryParamsRoutes + envelope
            // Get objectIds for the all routes
            Alamofire.request(urlForAllObjects).validate().responseString(queue: backgroundQueue) { response in
                SettingsManager.shared.networkOff()
                if (response.result.isFailure) {
                    return
                }
                let objectIds = JSON.parse(response.result.value!)["objectIds"]
                // Resuest 100 per round
                let numPerRound = 100
                let maxRound = Int(objectIds.count/numPerRound) + 1
                // Allow 100 round at most, return nil if exceed
                if (maxRound > 100) {
                    completion(name, nil)
                    return
                }
                // Request routes for each round
                for round in 0..<maxRound {
                    let startIndex: Int
                    let endIndex: Int
                    if (round == maxRound - 1) {
                        startIndex = (maxRound - 1) * numPerRound
                        endIndex = objectIds.count
                        if (startIndex > endIndex) {
                            continue
                        }
                    } else {
                        startIndex = round * numPerRound
                        endIndex = (round + 1) * numPerRound
                    }
                    var objectIdsForRound: String = ""
                    for i in startIndex..<endIndex {
                        objectIdsForRound += String(objectIds[i].intValue) + ","
                    }
                    let urlForSingleObject = url + queryParamsRouteIds + objectIdsForRound
                    SettingsManager.shared.networkON()
                    Alamofire.request(urlForSingleObject).validate().responseString(queue: backgroundQueue) { response in
                        SettingsManager.shared.networkOff()
                        print(round)
                        if (response.result.isFailure) {
                            return
                        }
                        completion(name, response.result.value)
                    }
                }
            }
        }
        
        
    }
}
