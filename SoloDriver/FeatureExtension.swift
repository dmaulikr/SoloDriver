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
                        if (!(bridgeType.contains("OVER ROAD") || bridgeType.contains("PEDESTRIAN UNDERPASS"))) {
                            continue
                        }
                        if (bridge["attributes"]["MIN_CLEARANCE"].doubleValue <= 1) {
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
            let json = VicTrafficService.parseVicTrafficFeatures(value: result)
            DispatchQueue.global(qos: .userInteractive).async{
                var incidents: JSON
                if let dataFromString = json?.data(using: String.Encoding.utf8, allowLossyConversion: false) {
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
                    let annotationView = annotation.createPinView(nil)
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
        
        //        switch SettingsManager.shared.settings["Routes"].stringValue {
        //        case CategoriesController.TITLE_HML:
        //            PublicDataService.getHMLRoute(mapView) { (result) in
        //                // Draw lines in background
        //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        //                    let roads = JSON(result)["features"]
        //                    // Loop through roads
        //                    for (_, road): (String, JSON) in roads {
        //                        // let attributes = road["attributes"]
        //                        let roadPolyline = Geometries.createHMLPolylineFrom(road)
        //                        // let roadAnnotations = Geometries.createHMLAnnotationsFrom(road)
        //                        if (thisTask != self.currentTask) {
        //                            break
        //                        }
        //                        dispatch_async(dispatch_get_main_queue(), {
        //                            self.mapView.addOverlay(roadPolyline)
        //                            // self.mapView.addAnnotations(roadAnnotations)
        //                        })
        //                    }
        //                })
        //            }
        //            break
        //        case CategoriesController.TITLE_HPFV:
        //            PublicDataService.getHPFVRoute(mapView) { (result) in
        //                // Draw lines in background
        //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        //                    let roads = JSON(result)["features"]
        //                    // Loop through roads
        //                    for (_, road): (String, JSON) in roads {
        //                        let roadPolyline = Geometries.createHPFVPolylineFrom(road)
        //                        if (thisTask != self.currentTask) {
        //                            break
        //                        }
        //                        dispatch_async(dispatch_get_main_queue(), {
        //                            self.mapView.addOverlay(roadPolyline)
        //                        })
        //                    }
        //                })
        //            }
        //            break
        //        default:
        //            break
        //        }
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
}
