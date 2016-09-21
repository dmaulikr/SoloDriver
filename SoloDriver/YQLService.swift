//
//  ArcGISService.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class YQLService: NSObject {
    
    static let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
    static let urlRestArea = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%27https%3A%2F%2Fwww.vicroads.vic.gov.au%2F~%2Fmedia%2FMedia%2FBusiness%2520and%2520Industry%2FRest%2520Areas%2Frestareadata%27%0A%20%20%20%20%20%20and%20columns%3D%27RestAreaID%2CRestAreaName%2CRoadName%2CCarriageway%2CSRNS%2CDistanceFromInt%2CDirectionFromInt%2CNearestIntersection%2CLocality%2CLatitude%2CLongitude%2CRestAreaType%2CSurfaceType%2CDelineatedParking%2CToilets%2CDisabledToilets%2CPicnicTables%2CBBQ%2CRubbishBins%2CWater%27&format=json&diagnostics=true&callback="
    
    static func getRestArea(completion: @escaping (_ result: String) -> Void) {
        SettingsManager.shared.networkON()
        Alamofire.request(urlRestArea).validate().responseString(queue: userInitiatedQueue) { response in
            SettingsManager.shared.networkOff()
            if (response.result.isFailure) {
                return
            }
            if let value = response.result.value {
                completion(value)
            }
        }
    }
}
