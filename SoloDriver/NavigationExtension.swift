//
//  NavigationExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SCLAlertView

extension MasterController{
    
    func startNavigation() {
        self.titleItem.title = "Cancel Navigation"
    }
    
    func cancelNavigation() {
        self.titleItem.title = "Search Map Area"
    }
}
