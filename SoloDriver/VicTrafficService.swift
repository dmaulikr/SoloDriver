//
//  VicTrafficService.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VicTrafficService: NSObject {

    fileprivate static let url = "http://traffic.vicroads.vic.gov.au/maps.js"

    static func getVicTrafficFeatures(_ completion: @escaping (_ result: String) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url).validate().responseString { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if (response.result.isFailure) {
                return
            }
            if let value = response.result.value {
                completion(value)
            }
        }
    }

    static func parseVicTrafficFeatures(_ value: String) -> JSON? {
        let startIndex = value.range(of: "{\"incidents\":[{\"id\":")?.lowerBound
        let endIndex = value.range(of: "}]}]}")?.upperBound
        // Guard
        if (startIndex == nil || endIndex == nil) {
            return nil
        }
        let json = value.substring(to: endIndex!).substring(from: startIndex!)
        return JSON(json)
    }
}
