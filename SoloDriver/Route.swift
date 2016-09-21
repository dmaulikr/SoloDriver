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

class RouteAnnotation: AlertViewAnnotation {
    
}

extension Geometry {
    
    static func createRoutePolylineFrom(name: String, json: JSON) -> RoutePolyline {
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
    
    static func createRouteAnnotationsFrom(name:String, polyline: MKPolyline, json:JSON) -> [RouteAnnotation] {
        let attributes = json["attributes"]
        let title = attributes["SUBJECT_PREF_RDNAME"].stringValue
        let subtitle = attributes["HVR_" + name].stringValue
        let alertTitle = title
        let alertSubtitle = attributes["HVR_" + name + "_COMM"].stringValue
        var annotations: [RouteAnnotation] = []
        for point in UnsafeBufferPointer(start: polyline.points(), count: polyline.pointCount) {
            let annotation: RouteAnnotation = RouteAnnotation()
            annotation.coordinate = MKCoordinateForMapPoint(point)
            annotation.title = title
            annotation.subtitle = subtitle
            annotation.color = Config.ORANGE
            annotation.alertTitle = alertTitle
            annotation.alertSubtitle = alertSubtitle
            annotation.alertColor = Config.ORANGE_CODE
            annotation.alertStyle = .info
            annotation.reuseId = "RouteAnnotation"
            annotations += [annotation]
        }
        return annotations
    }
}
