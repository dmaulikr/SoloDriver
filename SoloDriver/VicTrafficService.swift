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
    
    static let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
    static let url = "http://traffic.vicroads.vic.gov.au/maps.json"
    
    static func getVicTrafficFeatures(completion: @escaping (_ result: String) -> Void) {
        SettingsManager.shared.networkON()
        Alamofire.request(url).validate().responseString(queue: userInitiatedQueue) { response in
            SettingsManager.shared.networkOff()
            if (!response.result.isFailure) {
                if let value = response.result.value {
                    completion(value)
                    return
                }
            }
            print(response.result.error!)
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                getVicTrafficFeatures(completion: { (newResult) in
                    completion(newResult)
                })
            }
        }
    }
}
