//
//  Destination.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import SCLAlertView

class DestinationAnnotation: MKPointAnnotation {

    let reuseId = "DestinationAnnotation"
    func createPinView(_ oldPinView: MKAnnotationView?) -> MKPinAnnotationView {
        if (oldPinView == nil) {
            let pinView = MKPinAnnotationView(annotation: self, reuseIdentifier: reuseId)
            let rightButton = UIButton(type: .system)
            rightButton.frame = CGRect(x: 0, y: 0, width: 110, height: 50)
            rightButton.backgroundColor = UIColor.black
            rightButton.setTitle("Get Direction", for: UIControlState())
            rightButton.setTitleColor(UIColor.white, for: UIControlState())
            pinView.rightCalloutAccessoryView = rightButton as UIView
            pinView.isUserInteractionEnabled = true
            pinView.canShowCallout = true
            pinView.pinTintColor = UIColor.black
            pinView.rightCalloutAccessoryView!.tintColor = UIColor.black
            return pinView
        } else {
            oldPinView!.annotation = self
            return oldPinView! as! MKPinAnnotationView
        }
    }
}

class WayPointAnnotation: MKPointAnnotation {
    let reuseId = "WayPointAnnotation"
    func createPinView(_ oldPinView: MKAnnotationView?) -> MKPinAnnotationView {
        if (oldPinView == nil) {
            let pinView = MKPinAnnotationView(annotation: self, reuseIdentifier: reuseId)
            let rightButton = UIButton(type: .system)
            rightButton.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
            rightButton.backgroundColor = UIColor.black
            rightButton.setTitle("Remove", for: UIControlState())
            rightButton.setTitleColor(UIColor.white, for: UIControlState())
            pinView.rightCalloutAccessoryView = rightButton as UIView
            pinView.isUserInteractionEnabled = true
            pinView.canShowCallout = true
            pinView.pinTintColor = UIColor.black
            pinView.rightCalloutAccessoryView!.tintColor = UIColor.black
            return pinView
        } else {
            oldPinView!.annotation = self
            return oldPinView! as! MKPinAnnotationView
        }
    }
}

class DirectionPolyline: ColorPolyline {

    convenience init(route: MKRoute) {
        self.init()
        self.init(points: route.polyline.points(), count: route.polyline.pointCount)
        self.route = route
    }

    var route: MKRoute?
}
