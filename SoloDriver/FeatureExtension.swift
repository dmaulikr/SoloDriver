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

        // Bridge Clearance
        if (SettingsManager.shared.settings["Bridge Clearance"].boolValue) {
            ArcGISService.getBridgeStructures(mapView, completion: { (result) in
                // Draw annotations in background
                
                DispatchQueue.global(qos: .userInteractive).async{
                    let bridges = JSON(result)["features"]
                    // Loop through bridges
                    for (_, bridge): (String, JSON) in bridges {
                        let bridgeType = bridge["attributes"]["BRIDGE_TYPE"].stringValue
                        if (!(bridgeType.contains("OVER ROAD") || bridgeType.contains("PEDESTRIAN UNDERPASS"))) {
                            continue
                        }
                        if (bridge["attributes"]["MIN_CLEARANCE"].doubleValue <= 1) {
                            continue
                        }
                        let annotation = Geometry.createBridgeAnnotationFrom(bridge)
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
            if let json = VicTrafficService.parseVicTrafficFeatures(result) {
                let incidents = json["incidents"]
                print(incidents)
            }
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
