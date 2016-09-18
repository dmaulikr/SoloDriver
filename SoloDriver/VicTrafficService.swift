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
    
    static let url = "http://traffic.vicroads.vic.gov.au/maps.js"
    
    static func getVicTrafficFeatures(_ completion: @escaping (_ result: String) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url).validate().responseString { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if (response.result.isFailure) {
                return
            }
            if let value = response.result.value {
                if (value.contains("{\"incidents\":[{\"id\":")){
                    completion(value)
                } else {
                    getVicTrafficFeatures({ (newResult) in
                        completion(newResult)
                    })
                }
            }
        }
    }
    
    static func parseVicTrafficFeatures(value: String) -> String? {
        let startIndex = value.range(of: "{\"incidents\":[{\"id\":")?.lowerBound
        let endIndex = value.range(of: "}]}]}")?.upperBound
        // Guard
        if (startIndex == nil || endIndex == nil) {
            return nil
        }
        let json = value.substring(to: endIndex!).substring(from: startIndex!)
        return json
    }
}
