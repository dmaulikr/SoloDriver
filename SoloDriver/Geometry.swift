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

class ColorPolyline: MKPolyline {
    var color: UIColor?
}

class AlertViewAnnotation: MKPointAnnotation {
    var color: UIColor?
    var image: UIImage?
    var alertTitle: String?
    var alertSubtitle: String?
    var alertColor: UInt?
    var alertStyle: SCLAlertViewStyle?
}

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
}
