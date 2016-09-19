//
//  Bridge.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import SCLAlertView

extension Geometry {
    
    static func createRoutesPolylineFrom(name: String, json: JSON) -> ColorPolyline {
        
        print(json.rawString()!)
        
        var pointsToUse: [CLLocationCoordinate2D] = []
        let paths = json["geometry"]["paths"][0]
        // Loop road points
        for (_, point): (String, JSON) in paths {
            let coordinate = CLLocationCoordinate2D(latitude: point[1].doubleValue, longitude: point[0].doubleValue)
            pointsToUse += [coordinate]
        }
        let roadPolyline = ColorPolyline(coordinates: &pointsToUse, count: paths.count)
        // Set color
        switch json["attributes"]["HVR_" + name].stringValue {
        case "Approved":
            roadPolyline.color = Config.GREEN
            break
        case "Conditionally Approved":
            roadPolyline.color = Config.ORANGE
            break
        case "Restricted":
            roadPolyline.color = Config.RED
            break
        case "Funded improvements":
            roadPolyline.color = Config.BLUE
            break
        default:
            roadPolyline.color = UIColor.clear
        }
        return roadPolyline
    }
    
}

//{
//    "geometry" : {
//        "paths" : [
//        [
//        [
//        145.0696135143999,
//        -37.75663786461165
//        ],
//        [
//        145.0703595562603,
//        -37.75672745018421
//        ]
//        ]
//        ]
//    },
//    "attributes" : {
//        "HVR_HML" : "Conditionally Approved",
//        "OBJECTID" : 213196,
//        "HVR_RD_MANAGER" : "BANYULE",
//        "LRS_RMACLASS" : "Municipal Road",
//        "LOCALITIES" : "HEIDELBERG",
//        "SUBJECT_PREF_RDNAME" : "BURGUNDY STREET ",
//        "HVR_HML_COMM" : "No left turn into Burgundy Street from Rosanna Road for vehicles longer than 10m"
//    }
//}
