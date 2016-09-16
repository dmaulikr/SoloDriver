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

class BridgeAnnotation: AlertViewAnnotation {
    var reuseId = "BridgeAnnotation"
    func createPinView(_ oldPinView: MKAnnotationView?) -> MKAnnotationView {
        if (oldPinView == nil) {
            let pinView = MKAnnotationView(annotation: self, reuseIdentifier: reuseId)
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            pinView.isUserInteractionEnabled = true
            pinView.canShowCallout = true
            pinView.image = image
            pinView.tintColor = color
            pinView.rightCalloutAccessoryView!.tintColor = color
            return pinView
        } else {
            oldPinView!.annotation = self
            oldPinView!.subviews.last?.tintColor = color
            oldPinView!.rightCalloutAccessoryView!.tintColor = color
            return oldPinView!
        }
    }
}

extension Geometry {

    static func createBridgeAnnotationFrom(_ bridge: JSON) -> BridgeAnnotation {
        let geometry = bridge["geometry"]
        let attributes = bridge["attributes"]
        let clearance = attributes["MIN_CLEARANCE"].doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: geometry["y"].doubleValue, longitude: geometry["x"].doubleValue)
        // Set annotation: required
        let bridgeAnnotation = BridgeAnnotation()
        bridgeAnnotation.coordinate = coordinate
        bridgeAnnotation.title = attributes["FEATURE_CROSSED"].stringValue
            .replacingOccurrences(of: "RAILWAY OVER ", with: "")
            .replacingOccurrences(of: "RAILWAY LINE OVER ", with: "")
            .trimmingCharacters(in: CharacterSet.decimalDigits)
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        bridgeAnnotation.subtitle = "CLEARANCE: " + String(clearance)
        // For alert view
        var subtitle = "CLEARANCE: " + String(clearance)
        subtitle += "\nBRIDGE TYPE: " + attributes["BRIDGE_TYPE"].stringValue
            .replacingOccurrences(of: "(GRADE SEPARATION)", with: "")
            .replacingOccurrences(of: "(RAIL OVERPASS)", with: "")
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
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.info
            } else if (clearance < 5) {
                bridgeAnnotation.color = Config.ORANGE
                bridgeAnnotation.image = Config.ORANGE_BRIDGE
                bridgeAnnotation.alertColor = Config.ORANGE_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.info
            } else {
                bridgeAnnotation.color = Config.GREEN
                bridgeAnnotation.alertColor = Config.GREEN_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.success
            }
        } else {
            if (clearance < settings["Height (m)"].doubleValue) {
                bridgeAnnotation.color = Config.RED
                bridgeAnnotation.image = Config.RED_BRIDGE
                bridgeAnnotation.alertColor = Config.RED_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.error
            } else {
                bridgeAnnotation.color = Config.GREEN
                bridgeAnnotation.image = Config.GREEN_BRIDGE
                bridgeAnnotation.alertColor = Config.GREEN_CODE
                bridgeAnnotation.alertStyle = SCLAlertViewStyle.success
            }
        }
        return bridgeAnnotation
    }
}
