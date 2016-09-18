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
    lazy var renderer: MKPolylineRenderer = {
        let renderer = MKPolylineRenderer(overlay: self)
        renderer.strokeColor = self.color
        renderer.lineWidth = 2
        return renderer
    }()
}

class AlertViewAnnotation: MKPointAnnotation {
    var color: UIColor?
    var image: UIImage?
    var alertTitle: String?
    var alertSubtitle: String?
    var alertColor: UInt?
    var alertStyle: SCLAlertViewStyle?
    
    var reuseId: String = "AlertViewAnnotation"
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

class Geometry: NSObject {

    static func getTapEnvelope(_ coordinate: CLLocationCoordinate2D) -> String {
        let xmin = coordinate.longitude - Config.TAP_RADIUS
        let ymin = coordinate.latitude - Config.TAP_RADIUS
        let xmax = coordinate.longitude + Config.TAP_RADIUS
        let ymax = coordinate.latitude + Config.TAP_RADIUS
        let geometry = JSON(["xmin": xmin, "xmax": xmax, "ymin": ymin, "ymax": ymax])
        return geometry.rawString()!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }

    static func getVisibleAreaEnvelope(_ mapView: MKMapView) -> String {
        let mRect = mapView.visibleMapRect
        let xmin = MKMapRectGetMinX(mRect)
        let ymin = MKMapRectGetMinY(mRect)
        let xmax = MKMapRectGetMaxX(mRect)
        let ymax = MKMapRectGetMaxY(mRect)
        let min = MKCoordinateForMapPoint(MKMapPointMake(xmin, ymin))
        let max = MKCoordinateForMapPoint(MKMapPointMake(xmax, ymax))
        let geometry = JSON(["xmin": min.longitude, "xmax": max.longitude, "ymin": min.latitude, "ymax": max.latitude])
        return geometry.rawString()!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }

    // Calculate distance between a point and a line
    static func distanceOfPointAndLine(_ pt: MKMapPoint, poly: MKPolyline) -> Double {
        var distance: Double = Double(MAXFLOAT)
        var linePoints: [MKMapPoint] = []
        // var polyPoints = UnsafeMutablePointer<MKMapPoint>.alloc(poly.pointCount)
        for point in UnsafeBufferPointer(start: poly.points(), count: poly.pointCount) {
            linePoints.append(point)
            // print("point: \(point.x),\(point.y)")
        }
        for n in 0...linePoints.count - 2 {
            let ptA = linePoints[n]
            let ptB = linePoints[n + 1]
            let xDelta = ptB.x - ptA.x
            let yDelta = ptB.y - ptA.y
            if (xDelta == 0.0 && yDelta == 0.0) {
                // Points must not be equal
                continue
            }
            let u: Double = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
            var ptClosest = MKMapPoint()
            if (u < 0.0) {
                ptClosest = ptA
            } else if (u > 1.0) {
                ptClosest = ptB
            } else {
                ptClosest = MKMapPointMake(ptA.x + u * xDelta, ptA.y + u * yDelta);
            }
            distance = min(distance, MKMetersBetweenMapPoints(ptClosest, pt))
        }
        return distance
    }

    // Get closest line ppoint between a point and a line
    static func getClosestPoint(_ pt: MKMapPoint, poly: MKPolyline) -> CLLocationCoordinate2D {
        var distance: Double = Double(MAXFLOAT)
        var closestPoint = pt
        var linePoints: [MKMapPoint] = []
        // var polyPoints = UnsafeMutablePointer<MKMapPoint>.alloc(poly.pointCount)
        for point in UnsafeBufferPointer(start: poly.points(), count: poly.pointCount) {
            linePoints.append(point)
            // print("point: \(point.x),\(point.y)")
        }
        for n in 0...linePoints.count - 2 {
            let ptA = linePoints[n]
            let ptB = linePoints[n + 1]
            let xDelta = ptB.x - ptA.x
            let yDelta = ptB.y - ptA.y
            if (xDelta == 0.0 && yDelta == 0.0) {
                // Points must not be equal
                continue
            }
            let u: Double = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
            var ptClosest = MKMapPoint()
            if (u < 0.0) {
                ptClosest = ptA
            } else if (u > 1.0) {
                ptClosest = ptB
            } else {
                ptClosest = MKMapPointMake(ptA.x + u * xDelta, ptA.y + u * yDelta);
            }
            if (MKMetersBetweenMapPoints(ptClosest, pt) < distance) {
                closestPoint = ptClosest
                distance = MKMetersBetweenMapPoints(ptClosest, pt)
            }
        }
        return MKCoordinateForMapPoint(closestPoint)
    }
}
