//
//  Geometries.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SCLAlertView

class ColorPolyline: MKPolyline {
    var color: UIColor?
}

class HMLPolyLine: ColorPolyline {

}

class HPFVPolyline: ColorPolyline {

}

class DirectionPolyline: ColorPolyline {
    override init() {
        super.init()
        color = UIColor.blackColor()
    }
}

class AlertViewAnnotation: MKPointAnnotation {
    var reuseId = "Annotation"
    var color: UIColor?
    var image: UIImage?
    var alertTitle: String?
    var alertSubtitle: String?
    var alertColor: UInt?
    var alertStyle: SCLAlertViewStyle?

    func createPinView(oldPinView: MKAnnotationView?) -> MKAnnotationView {
        if (oldPinView == nil) {
            let pinView = MKAnnotationView(annotation: self, reuseIdentifier: reuseId)
            pinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            pinView.userInteractionEnabled = true
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

class BridgeAnnotation: AlertViewAnnotation {

}

class HMLAnnotation: AlertViewAnnotation {

}

class HPFVAnnotation: AlertViewAnnotation {

}

class WayPointAnnotation: MKPointAnnotation {

}

class DestinationAnnotation: MKPointAnnotation {

}