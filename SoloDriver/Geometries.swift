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
import SCLAlertView

class Geometries: NSObject {

    static let RED = UIColor(red: 0.74, green: 0.21, blue: 0.18, alpha: 1.0)
    static let RED_CODE = 0xBD362E
    static let ORANGE = UIColor(red: 0.97, green: 0.58, blue: 0.02, alpha: 1.0)
    static let ORANGE_CODE = 0xF79405
    static let GREEN = UIColor(red: 0.32, green: 0.64, blue: 0.32, alpha: 1.0)
    static let GREEN_CODE = 0x52A352
    static let BLUE = UIColor(red: 0.00, green: 0.27, blue: 0.80, alpha: 1.0)
    static let BLUE_CODE = 0x0045CC

    class HMLPolyLine: MKPolyline {
        var color: UIColor?
    }

    class HPFVPolyline: HMLPolyLine {

    }

    class BridgeAnnotation: MKPointAnnotation {
        var color: UIColor?
        var alertTitle: String?
        var alertSubtitle: String?
        var alertColor: Int?
        var alertStyle: SCLAlertViewStyle?

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
        case "Funded improvements":
            roadPolyline.color = Geometries.BLUE
            break
        default:
            roadPolyline.color = UIColor.clearColor()
        }
        return roadPolyline
    }

    static func createHPFVPolylineFrom(road: JSON) -> HMLPolyLine {
        var pointsToUse: [CLLocationCoordinate2D] = []
        let paths = road["geometry"]["paths"][0]
        // Loop road points
        for (_, point): (String, JSON) in paths {
            let coordinate = CLLocationCoordinate2D(latitude: point[1].doubleValue, longitude: point[0].doubleValue)
            pointsToUse += [coordinate]
        }
        let roadPolyline = HMLPolyLine(coordinates: &pointsToUse, count: paths.count)
        // Set color
        switch road["attributes"]["HVR_HPFV_MASS"].stringValue {
        case "Approved":
            roadPolyline.color = Geometries.GREEN
            break
        case "Conditionally Approved":
            roadPolyline.color = Geometries.ORANGE
            break
        case "Restricted":
            roadPolyline.color = Geometries.RED
            break
        case "Funded improvements":
            roadPolyline.color = Geometries.BLUE
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
        bridgeAnnotation.title = attributes["FEATURE_CROSSED"].stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        bridgeAnnotation.subtitle = "CLEARANCE: " + String(clearance)
        bridgeAnnotation.alertTitle = bridge["COLLOQUIAL_NAME_1"].stringValue
        if (clearance < 4) {
            bridgeAnnotation.color = Geometries.RED
            bridgeAnnotation.alertColor = Geometries.RED_CODE
            bridgeAnnotation.alertStyle = SCLAlertViewStyle.Warning
        } else if (clearance < 5) {
            bridgeAnnotation.color = Geometries.ORANGE
            bridgeAnnotation.alertColor = Geometries.ORANGE_CODE
            bridgeAnnotation.alertStyle = SCLAlertViewStyle.Notice
        } else {
            bridgeAnnotation.color = Geometries.GREEN
            bridgeAnnotation.alertColor = Geometries.GREEN_CODE
            bridgeAnnotation.alertStyle = SCLAlertViewStyle.Success
        }
        bridgeAnnotation.alertSubtitle = bridgeAnnotation.subtitle
        return bridgeAnnotation
    }
}
