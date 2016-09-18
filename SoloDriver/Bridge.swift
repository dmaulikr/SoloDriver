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
    
    override init() {
        super.init()
        reuseId = "BridgeAnnotation"
    }
    
}

extension Geometry {
    
    static func createBridgeAnnotationFrom(bridge: JSON) -> BridgeAnnotation {
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
        var subtitle = attributes["FEATURE_CROSSED"].stringValue
            .trimmingCharacters(in: CharacterSet.decimalDigits)
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        subtitle += "\nCLEARANCE: " + String(clearance)
        subtitle += "\nBRIDGE TYPE: " + attributes["BRIDGE_TYPE"].stringValue
            .replacingOccurrences(of: "(GRADE SEPARATION)", with: "")
            .replacingOccurrences(of: "(RAIL OVERPASS)", with: "")
        subtitle += "\nBRIDGE WIDTH: " + String(attributes["OVERALL_WIDTH"].doubleValue)
        subtitle += "\nBRIDGE LENGTH: " + String(attributes["OVERALL_LENGTH"].doubleValue)
        bridgeAnnotation.alertSubtitle = subtitle
        // Set color based on settings
        let settings = SettingsManager.shared.settings
        if (settings["Height (m)"].doubleValue == 0) {
            bridgeAnnotation.alertTitle = "ATTENTION"
            bridgeAnnotation.color = Config.ORANGE
            bridgeAnnotation.image = Config.ICON_BRIDGE
            bridgeAnnotation.alertColor = Config.ORANGE_CODE
            bridgeAnnotation.alertStyle = SCLAlertViewStyle.info
        } else if (settings["Height (m)"].doubleValue > clearance) {
            bridgeAnnotation.alertTitle = "DANGER"
            bridgeAnnotation.color = Config.RED
            bridgeAnnotation.image = Config.ICON_BRIDGE
            bridgeAnnotation.alertColor = Config.RED_CODE
            bridgeAnnotation.alertStyle = SCLAlertViewStyle.error
        }
        return bridgeAnnotation
    }
}
