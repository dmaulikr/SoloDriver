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

class RestAreaAnnotation: AlertViewAnnotation {
    
    override init() {
        super.init()
        reuseId = "RestAreaAnnotation"
    }
    
}

extension Geometry {
    
    static func createRestAreaAnnotationFrom(json: JSON) -> RestAreaAnnotation {
        // For annotation
        let annotation = RestAreaAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(json["Latitude"].stringValue)!, longitude: Double(json["Longitude"].stringValue)!)
        annotation.title = (json["RestAreaName"].stringValue == "") ? "Rest Area" : json["RestAreaName"].stringValue
        annotation.subtitle = json["RoadName"].stringValue
        annotation.image = Config.ICON_REST_AREA
        annotation.color = Config.GREEN
        // For alert view
        annotation.alertTitle = annotation.title
        var subtitle = "This rest area lies " + json["Carriageway"].stringValue
        subtitle += " on the " + json["RoadName"].stringValue
        subtitle += " (" + json["SRNS"].stringValue + ") "
        subtitle += "in " + json["Locality"].stringValue + ". "
        subtitle += "The nearest intersection is " + json["NearestIntersection"].stringValue + "; "
        subtitle += "the rest area can be found " + json["DistanceFromInt"].stringValue + "m "
        subtitle += json["DirectionFromInt"].stringValue + " from this intersection.\n"
        subtitle += "\nDelineated Parking: " + json["DelineatedParking"].stringValue
        subtitle += "\nToilets: " + json["Toilets"].stringValue
        subtitle += "\nDisabled Toilets: " + json["DisabledToilets"].stringValue
        subtitle += "\nPicnic Tables: " + json["PicnicTables"].stringValue
        subtitle += "\nBBQ: " + json["BBQ"].stringValue
        subtitle += "\nRubbish Bins: " + json["RubbishBins"].stringValue
        subtitle += "\nWater: " + json["Water"].stringValue
        annotation.alertSubtitle = subtitle
        annotation.alertStyle = .success
        annotation.alertColor = Config.GREEN_CODE
        return annotation
    }

}
