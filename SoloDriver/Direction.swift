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

    let reuseId = "Destination"
    func createPinView(oldPinView: MKAnnotationView?) -> MKPinAnnotationView {
        if (oldPinView == nil) {
            let pinView = MKPinAnnotationView(annotation: self, reuseIdentifier: reuseId)
            let rightButton = UIButton(type: .System)
            rightButton.frame = CGRectMake(0, 0, 110, 50)
            rightButton.backgroundColor = UIColor.blackColor()
            rightButton.setTitle("Get Direction", forState: .Normal)
            rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            pinView.rightCalloutAccessoryView = rightButton as UIView
            pinView.userInteractionEnabled = true
            pinView.canShowCallout = true
            pinView.pinTintColor = UIColor.blackColor()
            pinView.rightCalloutAccessoryView!.tintColor = UIColor.blackColor()
            return pinView
        } else {
            oldPinView!.annotation = self
            return oldPinView! as! MKPinAnnotationView
        }
    }
}

class WayPointAnnotation: MKPointAnnotation {

}

class DirectionPolyline: ColorPolyline {

    convenience init(route: MKRoute) {
        self.init()
        self.init(points: route.polyline.points(), count: route.polyline.pointCount)
        self.route = route
    }

    var route: MKRoute?
}