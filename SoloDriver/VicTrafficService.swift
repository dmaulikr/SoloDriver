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

    private static let url = "http://traffic.vicroads.vic.gov.au/maps.js"

    static func getVicTrafficFeatures(completion: (result: String) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, url).validate().responseString { response in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    completion(result: value)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    static func parseVicTrafficFeatures(value: String) -> JSON? {
        let startRange = value.rangeOfString("{\"incidents\":[{\"id\":")
        let endRange = value.rangeOfString("}]}]};")
        let startIndex = startRange?.startIndex
        let endIndex = endRange?.endIndex.advancedBy(-1)
        // Guard
        if (startIndex == nil || endIndex == nil) {
            return nil
        }
        let json = value.substringToIndex(endIndex!).substringFromIndex(startIndex!)
        return JSON(json)
    }
}
