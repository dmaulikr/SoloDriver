//
//  Polyline.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import SCLAlertView

class Geometry: NSObject {

    static func getTapEnvelope(coordinate: CLLocationCoordinate2D) -> String {
        let xmin = coordinate.longitude - Geometries.TAP_RADIUS
        let ymin = coordinate.latitude - Geometries.TAP_RADIUS
        let xmax = coordinate.longitude + Geometries.TAP_RADIUS
        let ymax = coordinate.latitude + Geometries.TAP_RADIUS
        let geometry = JSON(["xmin": xmin, "xmax": xmax, "ymin": ymin, "ymax": ymax])
        return geometry.rawString()!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
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

    static func createBridgeAnnotationFrom(bridge: JSON) -> BridgeAnnotation {
        let geometry = bridge["geometry"]
        let attributes = bridge["attributes"]
        let clearance = attributes["MIN_CLEARANCE"].doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: geometry["y"].doubleValue, longitude: geometry["x"].doubleValue)
        // Set annotation: required
        let bridgeAnnotation = BridgeAnnotation()
        bridgeAnnotation.coordinate = coordinate
        bridgeAnnotation.title = attributes["FEATURE_CROSSED"].stringValue
            .stringByReplacingOccurrencesOfString("RAILWAY OVER ", withString: "")
            .stringByReplacingOccurrencesOfString("RAILWAY LINE OVER ", withString: "")
            .stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        bridgeAnnotation.subtitle = "CLEARANCE: " + String(clearance)
        // For alert view
        var subtitle = "CLEARANCE: " + String(clearance)
        subtitle += "\nBRIDGE TYPE: " + attributes["BRIDGE_TYPE"].stringValue
            .stringByReplacingOccurrencesOfString("(GRADE SEPARATION)", withString: "")
            .stringByReplacingOccurrencesOfString("(RAIL OVERPASS)", withString: "")
        subtitle += "\nBRIDGE WIDTH: " + String(attributes["OVERALL_WIDTH"].doubleValue)
        subtitle += "\nBRIDGE LENGTH: " + String(attributes["OVERALL_LENGTH"].doubleValue)
        bridgeAnnotation.alertSubtitle = subtitle
        // Set color based on settings
        let settings = SettingsManager.shared.settings
        if (settings["Height (m)"].double == nil) {
            if (clearance < 4) {
                bridgeAnnotation.color = Config.RED
                bridgeAnnotation.image = Config.RED_BRIDGE
                bridgeAnnotation.alertColor = Config.RED_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.Info
            } else if (clearance < 5) {
                bridgeAnnotation.color = Config.ORANGE
                bridgeAnnotation.image = Config.ORANGE_BRIDGE
                bridgeAnnotation.alertColor = Config.ORANGE_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.Info
            } else {
                bridgeAnnotation.color = Config.GREEN
                bridgeAnnotation.alertColor = Config.GREEN_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.Success
            }
        } else {
            if (clearance < settings["Height (m)"].doubleValue) {
                bridgeAnnotation.color = Config.RED
                bridgeAnnotation.image = Config.RED_BRIDGE
                bridgeAnnotation.alertColor = Config.RED_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.Error
            } else {
                bridgeAnnotation.color = Config.GREEN
                bridgeAnnotation.image = Config.GREEN_BRIDGE
                bridgeAnnotation.alertColor = Config.GREEN_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.Success
            }
        }
        return bridgeAnnotation
    }

}
