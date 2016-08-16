//
//  Geometries.swift
//  SoloDriver
//
//  Created by HaoBoji on 16/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import Foundation
import MapKit

class Geometries: NSObject {

    static let RED = UIColor(red: 0.74, green: 0.21, blue: 0.18, alpha: 1.0)
    static let ORANGE = UIColor(red: 0.97, green: 0.58, blue: 0.02, alpha: 1.0)
    static let GREEN = UIColor(red: 0.32, green: 0.64, blue: 0.32, alpha: 1.0)

    class HMLPolyLine: MKPolyline {
        var color: UIColor?
    }
}
