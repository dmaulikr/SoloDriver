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

class RoutePolyline: ColorPolyline {
    
}

extension Geometry {
    
    static func createRoutesPolylineFrom(name: String, json: JSON) -> RoutePolyline {
        var pointsToUse: [CLLocationCoordinate2D] = []
        let paths = json["geometry"]["paths"][0]
        // Loop road points
        for (_, point): (String, JSON) in paths {
            let coordinate = CLLocationCoordinate2D(latitude: point[1].doubleValue, longitude: point[0].doubleValue)
            pointsToUse += [coordinate]
        }
        let roadPolyline = RoutePolyline(coordinates: &pointsToUse, count: paths.count)
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
