//
//  SearchFeatureExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

extension MasterController {
    
    // Search features
    func searchFeatures() {
        
        // Clean existing features
        clearMap()
        
        // Semaphore
        let thisTask = currentTask
        
        // Setting
        let settings = SettingsManager.shared.settings
        
        // Bridge Clearance
        if (settings["Bridge Clearance"].boolValue) {
            ArcGISService.getBridgeStructures(completion: { (result) in
                var bridges: JSON
                if let dataFromString = result.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    bridges = JSON(data: dataFromString)["features"]
                } else {
                    return
                }
                // Loop through bridges
                for (_, bridge): (String, JSON) in bridges {
                    let bridgeType = bridge["attributes"]["BRIDGE_TYPE"].stringValue
                    if (!bridgeType.contains("OVER ROAD")) {
                        continue
                    } else if (bridgeType.contains("PEDESTRIAN UNDERPASS")) {
                        continue
                    } else if (bridge["attributes"]["MIN_CLEARANCE"].doubleValue > settings["Height (m)"].doubleValue) {
                        continue
                    }
                    let annotation = Geometry.createBridgeAnnotationFrom(bridge: bridge)
                    let annotationView = annotation.createPinView(nil)
                    if (thisTask != self.currentTask) {
                        break
                    }
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(annotationView.annotation!)
                    }
                }
                
            })
        }
        
        // VicTraffic
        VicTrafficService.getVicTrafficFeatures { (result) in
            var incidents: JSON
            if let dataFromString = result.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                incidents = JSON(data: dataFromString)["incidents"]
            } else {
                return
            }
            for (_, incident): (String, JSON) in incidents {
                let closureType = incident["closure_type"].stringValue
                switch closureType {
                case "Road Construction", "Road Maintenance", "Utility Works":
                    if (!settings["Roadwork"].boolValue) {
                        continue
                    }
                    break
                case "Sporting/Social Event":
                    if (!settings["Event"].boolValue) {
                        continue
                    }
                    break
                case "Traffic Alert":
                    if (!settings["Traffic Alert"].boolValue) {
                        continue
                    }
                    break
                case "Road Closed":
                    if (!settings["Road Closed"].boolValue) {
                        continue
                    }
                    break
                default:
                    break
                }
                let annotation = Geometry.createVicTrafficAnnotationFrom(json: incident)
                if (annotation == nil) {
                    continue
                }
                let annotationView = annotation!.createPinView(nil)
                if (thisTask != self.currentTask) {
                    break
                }
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotationView.annotation!)
                }
            }
            
        }
        
        // Rest Area
        if (settings["Rest Area"].boolValue) {
            YQLService.getRestArea(completion: { (result) in
                var restAreas: JSON
                if let dataFromString = result.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    restAreas = JSON(data: dataFromString)["query"]["results"]["row"]
                } else {
                    return
                }
                for i in 1..<restAreas.count {
                    let restArea = restAreas[i]
                    if (!restArea["RestAreaType"].stringValue.contains("TRUCKS")) {
                        continue
                    }
                    let annotation = Geometry.createRestAreaAnnotationFrom(json: restArea)
                    let annotationView = annotation.createPinView(nil)
                    if (thisTask != self.currentTask) {
                        break
                    }
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(annotationView.annotation!)
                    }
                }
                
            })
        }
        
        // Routes
        let envelope = Geometry.getVisibleAreaEnvelope(mapView)
        let route = settings["Routes"].stringValue
        ArcGISService.getRouteIds(envelope: envelope, route: route) { (result) in
            let objectIds = JSON.parse(result)["objectIds"]
            // Resuest 100 per round
            let numPerRound = 100
            let maxRound = Int(objectIds.count/numPerRound) + 1
            // Allow 100 round at most, alert if exceed
            if (maxRound > 100) {
                let alert = UIAlertController(title: "Oops", message: "The map area is too large.\nPlease zoom in and search again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            // Query each round
            for round in 0..<maxRound {
                if (thisTask != self.currentTask) {
                    return
                }
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
                ArcGISService.getRoutesByIds(objectIds: objectIdsForRound, route: route) { (result) in
                    let name = SettingsManager.getRouteName(route: route)!
                    // Calculate and draw lines on map
                    let routes: JSON = JSON.parse(result)["features"]
                    for (_, route): (String, JSON) in routes {
                        let polyline = Geometry.createRoutePolylineFrom(name: name, json: route)
                        if (thisTask != self.currentTask) {
                            return
                        }
                        DispatchQueue.main.async {
                            self.mapView.add(polyline)
                        }
                        // Add annotation
                        if (route["attributes"]["HVR_" + name].stringValue == "Conditionally Approved") {
                            let annotations = Geometry.createRouteAnnotationsFrom(name: name, polyline: polyline, json: route)
                            DispatchQueue.main.async {
                                self.mapView.addAnnotations(annotations)
                            }
                        }
                    }
                }
            }
        }
    }
}
