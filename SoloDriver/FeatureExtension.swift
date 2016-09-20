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
        
        // Semaphore
        currentTask = (currentTask + 1) % 1024
        let thisTask = currentTask
        
        // Setting
        let settings = SettingsManager.shared.settings
        
        // Clean existing features
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        // Bridge Clearance
        if (settings["Bridge Clearance"].boolValue) {
            ArcGISService.getBridgeStructures(mapView, completion: { (result) in
                // Draw annotations in background
                DispatchQueue.global(qos: .userInteractive).async{
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
                }
            })
        }
        
        // VicTraffic
        VicTrafficService.getVicTrafficFeatures { (result) in
            DispatchQueue.global(qos: .userInteractive).async{
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
            
        }
        
        // Rest Area
        if (settings["Rest Area"].boolValue) {
            YQLService.getRestArea(completion: { (result) in
                // Draw annotations in background
                DispatchQueue.global(qos: .userInteractive).async{
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
                }
            })
        }
        
        // Routes
        ArcGISService.getRoutes(mapView: mapView, route: settings["Routes"].stringValue) { (name, routes) in
            // If no results
            if (routes == nil) {
                let alert = UIAlertController(title: "Oops", message: "The map area is too large.\nPlease zoom in and search again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            // Calculate and draw lines on map
            let routes: JSON = JSON.parse(routes!)["features"]
            for (_, route): (String, JSON) in routes {
                let polyline = Geometry.createRoutesPolylineFrom(name: name, json: route)
                if (thisTask != self.currentTask) {
                    break
                }
                DispatchQueue.main.async {
                    self.mapView.add(polyline)
                }
            }
        }
    }
}
