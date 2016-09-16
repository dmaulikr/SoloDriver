////
////  Geometries.swift
////  SoloDriver
////
////  Created by HaoBoji on 16/08/2016.
////  Copyright © 2016 HaoBoji. All rights reserved.
////
//
//import Foundation
//import MapKit
//import SwiftyJSON
//import SCLAlertView
//// import Polyline
//
//class Geometries: NSObject {
//
//static let RED = UIColor(red: 0.74, green: 0.21, blue: 0.18, alpha: 1.0)
//static let RED_CODE = 0xBD362E as UInt
//static let ORANGE = UIColor(red: 0.97, green: 0.58, blue: 0.02, alpha: 1.0)
//static let ORANGE_CODE = 0xF79405 as UInt
//static let GREEN = UIColor(red: 0.32, green: 0.64, blue: 0.32, alpha: 1.0)
//static let GREEN_CODE = 0x52A352 as UInt
//static let BLUE = UIColor(red: 0.00, green: 0.27, blue: 0.80, alpha: 1.0)
//static let BLUE_CODE = 0x0045CC as UInt
//static let TAP_RADIUS = 0.001
//
//class ColorPolyline: MKPolyline {
//    var color: UIColor?
//}
//
//class HMLPolyLine: ColorPolyline {
//}
//
//class HPFVPolyline: ColorPolyline {
//
//}
//
//class PlanPolyline: ColorPolyline {
//
//}
//
//class AlertViewAnnotation: MKPointAnnotation {
//    var color: UIColor?
//    var alertTitle: String?
//    var alertSubtitle: String?
//    var alertColor: UInt?
//    var alertStyle: SCLAlertViewStyle?
//}
//
//class BridgeAnnotation: AlertViewAnnotation {
//
//}
//
//class HMLAnnotation: AlertViewAnnotation {
//
//}
//
//class HPFVAnnotation: AlertViewAnnotation {
//
//}
//
//class WayPointAnnotation: MKPointAnnotation {
//
//}
//
//static func getTapEnvelope(_ coordinate: CLLocationCoordinate2D) -> String {
//    let xmin = coordinate.longitude - Geometries.TAP_RADIUS
//    let ymin = coordinate.latitude - Geometries.TAP_RADIUS
//    let xmax = coordinate.longitude + Geometries.TAP_RADIUS
//    let ymax = coordinate.latitude + Geometries.TAP_RADIUS
//    let geometry = JSON(["xmin": xmin, "xmax": xmax, "ymin": ymin, "ymax": ymax])
//    return geometry.rawString()!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//}
//
//static func getVisibleAreaEnvelope(_ mapView: MKMapView) -> String {
//    let mRect = mapView.visibleMapRect
//    let xmin = MKMapRectGetMinX(mRect)
//    let ymin = MKMapRectGetMinY(mRect)
//    let xmax = MKMapRectGetMaxX(mRect)
//    let ymax = MKMapRectGetMaxY(mRect)
//    let min = MKCoordinateForMapPoint(MKMapPointMake(xmin, ymin))
//    let max = MKCoordinateForMapPoint(MKMapPointMake(xmax, ymax))
//    let geometry = JSON(["xmin": min.longitude, "xmax": max.longitude, "ymin": min.latitude, "ymax": max.latitude])
//    return geometry.rawString()!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//}
//
//static func createHMLPolylineFrom(_ road: JSON) -> HMLPolyLine {
//    var pointsToUse: [CLLocationCoordinate2D] = []
//    let paths = road["geometry"]["paths"][0]
//    // Loop road points
//    for (_, point): (String, JSON) in paths {
//        let coordinate = CLLocationCoordinate2D(latitude: point[1].doubleValue, longitude: point[0].doubleValue)
//        pointsToUse += [coordinate]
//    }
//    let roadPolyline = HMLPolyLine(coordinates: &pointsToUse, count: paths.count)
//    // Set color
//    switch road["attributes"]["HVR_HML"].stringValue {
//    case "Approved":
//        roadPolyline.color = Geometries.GREEN
//        break
//    case "Conditionally Approved":
//        roadPolyline.color = Geometries.ORANGE
//        break
//    case "Restricted":
//        roadPolyline.color = Geometries.RED
//        break
//    case "Funded improvements":
//        roadPolyline.color = Geometries.BLUE
//        break
//    default:
//        roadPolyline.color = UIColor.clear
//    }
//    return roadPolyline
//}
//
//static func createHMLAnnotationFrom(_ road: JSON, coordinate: CLLocationCoordinate2D) -> HMLAnnotation {
//    let attributes = road["attributes"]
//    // Set annotation
//    let title = attributes["SUBJECT_PREF_RDNAME"].stringValue
//    let subtitle = attributes["HVR_HML"].stringValue
//    var alertSubtitle = attributes["HVR_HML_COMM"].stringValue
//    alertSubtitle += "\n\nROAD CLASS: " + attributes["LRS_RMACLASS"].stringValue
//    alertSubtitle += "\nLOCALITY: " + attributes["LOCALITIES"].stringValue
//    alertSubtitle += "\nROAD MANAGER: " + attributes["HVR_RD_MANAGER"].stringValue
//    let alertColor: UInt
//    let color: UIColor
//    let alertStyle: SCLAlertViewStyle
//    // Set annotation alert view
//    switch subtitle {
//    case "Approved":
//        color = Geometries.GREEN
//        alertColor = Geometries.GREEN_CODE
//        alertStyle = SCLAlertViewStyle.success
//        break
//    case "Conditionally Approved":
//        color = Geometries.ORANGE
//        alertColor = Geometries.ORANGE_CODE
//        alertStyle = SCLAlertViewStyle.info
//        break
//    case "Restricted":
//        color = Geometries.RED
//        alertColor = Geometries.RED_CODE
//        alertStyle = SCLAlertViewStyle.error
//        break
//    case "Funded improvements":
//        color = Geometries.BLUE
//        alertColor = Geometries.BLUE_CODE
//        alertStyle = SCLAlertViewStyle.info
//        break
//    default:
//        color = UIColor.clear
//        alertColor = 0xFFFFFF
//        alertStyle = SCLAlertViewStyle.error
//    }
//
//    let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//    let annotation = HMLAnnotation()
//    annotation.coordinate = coordinate
//    annotation.title = title
//    annotation.subtitle = subtitle
//    annotation.color = color
//    annotation.alertSubtitle = alertSubtitle
//    annotation.alertColor = alertColor
//    annotation.alertStyle = alertStyle
//    return annotation
//}
//
//static func createHPFVPolylineFrom(_ road: JSON) -> HMLPolyLine {
//    var pointsToUse: [CLLocationCoordinate2D] = []
//    let paths = road["geometry"]["paths"][0]
//    // Loop road points
//    for (_, point): (String, JSON) in paths {
//        let coordinate = CLLocationCoordinate2D(latitude: point[1].doubleValue, longitude: point[0].doubleValue)
//        pointsToUse += [coordinate]
//    }
//    let roadPolyline = HMLPolyLine(coordinates: &pointsToUse, count: paths.count)
//    // Set color
//    switch road["attributes"]["HVR_HPFV_MASS"].stringValue {
//    case "Approved":
//        roadPolyline.color = Geometries.GREEN
//        break
//    case "Conditionally Approved":
//        roadPolyline.color = Geometries.ORANGE
//        break
//    case "Restricted":
//        roadPolyline.color = Geometries.RED
//        break
//    case "Funded improvements":
//        roadPolyline.color = Geometries.BLUE
//        break
//    default:
//        roadPolyline.color = UIColor.clear
//    }
//    return roadPolyline
//}
//
//static func createHPFVAnnotationFrom(_ road: JSON, coordinate: CLLocationCoordinate2D) -> HPFVAnnotation {
//    let attributes = road["attributes"]
//    // Set annotation
//    let title = attributes["SUBJECT_PREF_RDNAME"].stringValue
//    let subtitle = attributes["HVR_HPFV_MASS"].stringValue
//    var alertSubtitle = attributes["HVR_HPFV_MASS_COMM"].stringValue
//    alertSubtitle += "\n\nROAD CLASS: " + attributes["LRS_RMACLASS"].stringValue
//    alertSubtitle += "\nLOCALITY: " + attributes["LOCALITIES"].stringValue
//    let alertColor: UInt
//    let color: UIColor
//    let alertStyle: SCLAlertViewStyle
//    // Set annotation alert view
//    switch subtitle {
//    case "Approved":
//        color = Geometries.GREEN
//        alertColor = Geometries.GREEN_CODE
//        alertStyle = SCLAlertViewStyle.success
//        break
//    case "Conditionally Approved":
//        color = Geometries.ORANGE
//        alertColor = Geometries.ORANGE_CODE
//        alertStyle = SCLAlertViewStyle.info
//        break
//    case "Restricted":
//        color = Geometries.RED
//        alertColor = Geometries.RED_CODE
//        alertStyle = SCLAlertViewStyle.error
//        break
//    case "Funded improvements":
//        color = Geometries.BLUE
//        alertColor = Geometries.BLUE_CODE
//        alertStyle = SCLAlertViewStyle.info
//        break
//    default:
//        color = UIColor.clear
//        alertColor = 0xFFFFFF
//        alertStyle = SCLAlertViewStyle.error
//    }
//    let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//    let annotation = HPFVAnnotation()
//    annotation.coordinate = coordinate
//    annotation.title = title
//    annotation.subtitle = subtitle
//    annotation.color = color
//    annotation.alertSubtitle = alertSubtitle
//    annotation.alertColor = alertColor
//    annotation.alertStyle = alertStyle
//    return annotation
//}
//
//static func createBridgeAnnotationFrom(_ bridge: JSON) -> BridgeAnnotation {
//    let geometry = bridge["geometry"]
//    let attributes = bridge["attributes"]
//    let clearance = attributes["MIN_CLEARANCE"].doubleValue
//    let coordinate = CLLocationCoordinate2D(latitude: geometry["y"].doubleValue, longitude: geometry["x"].doubleValue)
//    // Set annotation: required
//    let bridgeAnnotation = BridgeAnnotation()
//    bridgeAnnotation.coordinate = coordinate
//    bridgeAnnotation.title = attributes["FEATURE_CROSSED"].stringValue
//        .replacingOccurrences(of: "RAILWAY OVER ", with: "")
//        .replacingOccurrences(of: "RAILWAY LINE OVER ", with: "")
//        .trimmingCharacters(in: CharacterSet.decimalDigits)
//        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    bridgeAnnotation.subtitle = "CLEARANCE: " + String(clearance)
//    // For alert view
//    var subtitle = "CLEARANCE: " + String(clearance)
//    subtitle += "\nBRIDGE TYPE: " + attributes["BRIDGE_TYPE"].stringValue
//        .replacingOccurrences(of: "(GRADE SEPARATION)", with: "")
//        .replacingOccurrences(of: "(RAIL OVERPASS)", with: "")
//    subtitle += "\nBRIDGE WIDTH: " + String(attributes["OVERALL_WIDTH"].doubleValue)
//    subtitle += "\nBRIDGE LENGTH: " + String(attributes["OVERALL_LENGTH"].doubleValue)
//    bridgeAnnotation.alertSubtitle = subtitle
//    // Set color based on settings
//    let settings = SettingsManager.shared.settings
//    if (settings["Height (m)"].double == nil) {
//        if (clearance < 4) {
//            bridgeAnnotation.color = Geometries.RED
//            bridgeAnnotation.alertColor = Geometries.RED_CODE
//            bridgeAnnotation.alertStyle = SCLAlertViewStyle.info
//        } else if (clearance < 5) {
//            bridgeAnnotation.color = Geometries.ORANGE
//            bridgeAnnotation.alertColor = Geometries.ORANGE_CODE
//            bridgeAnnotation.alertStyle = SCLAlertViewStyle.info
//        } else {
//            bridgeAnnotation.color = Geometries.GREEN
//            bridgeAnnotation.alertColor = Geometries.GREEN_CODE
//            bridgeAnnotation.alertStyle = SCLAlertViewStyle.success
//        }
//    } else {
//        if (clearance < settings["Height (m)"].doubleValue) {
//            bridgeAnnotation.color = Geometries.RED
//            bridgeAnnotation.alertColor = Geometries.RED_CODE
//            bridgeAnnotation.alertStyle = SCLAlertViewStyle.error
//        } else {
//            bridgeAnnotation.color = Geometries.GREEN
//            bridgeAnnotation.alertColor = Geometries.GREEN_CODE
//            bridgeAnnotation.alertStyle = SCLAlertViewStyle.success
//        }
//    }
//    return bridgeAnnotation
//}
//
//// Calculate distance between a point and a line
//static func distanceOfPointAndLine(_ pt: MKMapPoint, poly: MKPolyline) -> Double {
//    var distance: Double = Double(MAXFLOAT)
//    var linePoints: [MKMapPoint] = []
//    // var polyPoints = UnsafeMutablePointer<MKMapPoint>.alloc(poly.pointCount)
//    for point in UnsafeBufferPointer(start: poly.points(), count: poly.pointCount) {
//        linePoints.append(point)
//        // print("point: \(point.x),\(point.y)")
//    }
//    for n in 0...linePoints.count - 2 {
//        let ptA = linePoints[n]
//        let ptB = linePoints[n + 1]
//        let xDelta = ptB.x - ptA.x
//        let yDelta = ptB.y - ptA.y
//        if (xDelta == 0.0 && yDelta == 0.0) {
//            // Points must not be equal
//            continue
//        }
//        let u: Double = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
//        var ptClosest = MKMapPoint()
//        if (u < 0.0) {
//            ptClosest = ptA
//        } else if (u > 1.0) {
//            ptClosest = ptB
//        } else {
//            ptClosest = MKMapPointMake(ptA.x + u * xDelta, ptA.y + u * yDelta);
//        }
//        distance = min(distance, MKMetersBetweenMapPoints(ptClosest, pt))
//    }
//    return distance
//}
//
//// Get closest line ppoint between a point and a line
//static func getClosestPoint(_ pt: MKMapPoint, poly: MKPolyline) -> CLLocationCoordinate2D {
//    var distance: Double = Double(MAXFLOAT)
//    var closestPoint = pt
//    var linePoints: [MKMapPoint] = []
//    // var polyPoints = UnsafeMutablePointer<MKMapPoint>.alloc(poly.pointCount)
//    for point in UnsafeBufferPointer(start: poly.points(), count: poly.pointCount) {
//        linePoints.append(point)
//        // print("point: \(point.x),\(point.y)")
//    }
//    for n in 0...linePoints.count - 2 {
//        let ptA = linePoints[n]
//        let ptB = linePoints[n + 1]
//        let xDelta = ptB.x - ptA.x
//        let yDelta = ptB.y - ptA.y
//        if (xDelta == 0.0 && yDelta == 0.0) {
//            // Points must not be equal
//            continue
//        }
//        let u: Double = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
//        var ptClosest = MKMapPoint()
//        if (u < 0.0) {
//            ptClosest = ptA
//        } else if (u > 1.0) {
//            ptClosest = ptB
//        } else {
//            ptClosest = MKMapPointMake(ptA.x + u * xDelta, ptA.y + u * yDelta);
//        }
//        if (MKMetersBetweenMapPoints(ptClosest, pt) < distance) {
//            closestPoint = ptClosest
//            distance = MKMetersBetweenMapPoints(ptClosest, pt)
//        }
//    }
//    return MKCoordinateForMapPoint(closestPoint)
//}
//
//static func createPlanPolyline(_ overview_polyline: String) -> PlanPolyline {
//    var coordinates: [CLLocationCoordinate2D] = decodePolyline(overview_polyline)!
//    let count = coordinates.count
//    let planPolyline = PlanPolyline(coordinates: &coordinates, count: count)
//    planPolyline.color = BLUE
//    return planPolyline
//}
//}
