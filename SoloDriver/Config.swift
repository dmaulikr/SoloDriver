//
//  Config.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class Config: NSObject {

    // Color
    static let RED = UIColor(red: 0.74, green: 0.21, blue: 0.18, alpha: 1.0)
    static let RED_CODE = 0xBD362E as UInt
    static let ORANGE = UIColor(red: 0.97, green: 0.58, blue: 0.02, alpha: 1.0)
    static let ORANGE_CODE = 0xF79405 as UInt
    static let GREEN = UIColor(red: 0.32, green: 0.64, blue: 0.32, alpha: 1.0)
    static let GREEN_CODE = 0x52A352 as UInt
    static let BLUE = UIColor(red: 0.00, green: 0.27, blue: 0.80, alpha: 1.0)
    static let BLUE_CODE = 0x0045CC as UInt
    static let TAP_RADIUS = 0.001

    // Size
    static let ICON_SIZE: CGFloat = 24
    static let ICON_BRIDGE = UIImage(named: "Bridge-96")?.resize(newWidth: ICON_SIZE)
    static let ICON_ROADWORK = UIImage(named: "Road Worker-96")?.resize(newWidth: ICON_SIZE)
    static let ICON_EVENT = UIImage(named: "Event Accepted Tentatively-96")?.resize(newWidth: ICON_SIZE)
    static let ICON_TRAFFIC_ALERT = UIImage(named: "Error-96")?.resize(newWidth: ICON_SIZE)
    static let ICON_ROAD_CLOSED = UIImage(named: "Cancel-96")?.resize(newWidth: ICON_SIZE)
    static let ICON_REST_AREA = UIImage(named: "Park Bench-96")?.resize(newWidth: ICON_SIZE)
    
    // Instruction
    static let summary = "Truck drivers!, This is a handy tool offering navigation, which suggests truck routes depending upon the type of heavy vehicle you are driving. It can help you identify the restricted and conditionally restricted routes. It will make you aware of bridge clearances, possible road works and road closures beforehand to help plan your journey with the best possible route. SoloDriver will also alert you when approaching a low height bridge that provides sufficient time to deviate from the route. You can know the closest rest areas on the planned route for a quick break from long and tiring drive. Additionally, it also provides information about carrying dangerous loads and various safety techniques while driving. Stay safe on road!"
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
