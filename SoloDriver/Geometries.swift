//
//  Geometries.swift
//  SoloDriver
//
//  Created by HaoBoji on 16/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

class Geometries: NSObject {

    static let RED = UIColor(red: 0.74, green: 0.21, blue: 0.18, alpha: 1.0)
    static let ORANGE = UIColor(red: 0.97, green: 0.58, blue: 0.02, alpha: 1.0)
    static let GREEN = UIColor(red: 0.32, green: 0.64, blue: 0.32, alpha: 1.0)
    // static let CIRCLE = UIImage(named: "circle")

    class HMLPolyLine: MKPolyline {
        var color: UIColor?
    }

    class BridgeAnnotation: MKPointAnnotation {
        var color: UIColor?
    }

    static func getVisibleAreaEnvelope(mapView: MKMapView) -> String {
        let mRect = mapView.visibleMapRect
        let xmin = MKMapRectGetMinX(mRect)
        let ymin = MKMapRectGetMinY(mRect)
        let xmax = MKMapRectGetMaxX(mRect)
        let ymax = MKMapRectGetMaxY(mRect)
        let min = MKCoordinateForMapPoint(MKMapPointMake(xmin, ymin))
        let max = MKCoordinateForMapPoint(MKMapPointMake(xmax, ymax))
        let geometry = JSON(["xmin": min.longitude, "xmax": max.longitude, "ymin": min.latitude, "ymax": max.latitude])
        return geometry.rawString()!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }

    static func createHMLPolylineFrom(road: JSON) -> HMLPolyLine {
        var pointsToUse: [CLLocationCoordinate2D] = []
        let paths = road["geometry"]["paths"][0]
        // Loop road points
        for (_, point): (String, JSON) in paths {
            let coordinate = CLLocationCoordinate2D(latitude: point[1].doubleValue, longitude: point[0].doubleValue)
            pointsToUse += [coordinate]
        }
        let roadPolyline = HMLPolyLine(coordinates: &pointsToUse, count: paths.count)
        // Set color
        switch road["attributes"]["HVR_HML"].stringValue {
        case "Approved":
            roadPolyline.color = Geometries.GREEN
            break
        case "Conditionally Approved":
            roadPolyline.color = Geometries.ORANGE
            break
        case "Restricted":
            roadPolyline.color = Geometries.RED
            break
        default:
            roadPolyline.color = UIColor.clearColor()
        }
        return roadPolyline
    }

    static func createBridgeAnnotationFrom(bridge: JSON) -> BridgeAnnotation {
        let geometry = bridge["geometry"]
        let attributes = bridge["attributes"]
        let clearance = attributes["MIN_CLEARANCE"].doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: geometry["y"].doubleValue, longitude: geometry["x"].doubleValue)
        // Set annotation
        let bridgeAnnotation = BridgeAnnotation()
        bridgeAnnotation.coordinate = coordinate
        bridgeAnnotation.title = attributes["FEATURE_CROSSED"].stringValue
        bridgeAnnotation.subtitle = "CLEARANCE: " + String(clearance)
        if (clearance < 4) {
            bridgeAnnotation.color = Geometries.RED
        } else if (clearance < 5) {
            bridgeAnnotation.color = Geometries.ORANGE
        } else {
            bridgeAnnotation.color = Geometries.GREEN
        }
        return bridgeAnnotation
    }
}
