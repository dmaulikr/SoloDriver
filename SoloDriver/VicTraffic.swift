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

class VicTrafficAnnotation: AlertViewAnnotation {
    
}

extension Geometry {
    
    static func createVicTrafficAnnotationFrom(json: JSON) -> AlertViewAnnotation? {
        // For annotation
        let annotation = VicTrafficAnnotation()
        annotation.reuseId = json["closure_type"].stringValue
        let lat = Double(json["lat"].stringValue)
        let long = Double(json["long"].stringValue)
        if (lat == nil || long == nil) {
            return nil
        }
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        annotation.title = json["closed_road_name"].stringValue
        annotation.subtitle = json["incident_type"].stringValue
        // For alert view
        annotation.alertTitle = json["closure_type"].stringValue
        var subtitle = json["closed_road_name"].stringValue
        subtitle += "\n" + json["description"].stringValue
        if (json["from"].stringValue != "") {
            subtitle += "\n\nFrom: " + json["from"].stringValue
        }
        if (json["to"].stringValue != "") {
            subtitle += "\nTo: " + json["to"].stringValue
        }
        subtitle += "\n\nStart: " + json["created_date"].stringValue
        subtitle += "\nEnd: " + json["updated_date"].stringValue
        annotation.alertSubtitle = subtitle
        annotation.color = Config.ORANGE
        annotation.alertColor = Config.ORANGE_CODE
        annotation.alertStyle = .info
        switch json["closure_type"].stringValue {
        case "Road Construction", "Road Maintenance", "Utility Works":
            annotation.image = Config.ICON_ROADWORK
            break
        case "Sporting/Social Event":
            annotation.image = Config.ICON_EVENT
            break
        case "Traffic Alert":
            annotation.image = Config.ICON_TRAFFIC_ALERT
            break
        case "Road Closed":
            annotation.image = Config.ICON_ROAD_CLOSED
            annotation.color = Config.RED
            annotation.alertColor = Config.RED_CODE
            annotation.alertStyle = .error
            break
        default:
            annotation.image = nil
            break
        }
        return annotation
    }
    
}
