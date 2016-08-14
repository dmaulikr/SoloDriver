//
//  PublicDataService.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON

public class PublicDataService: NSObject {
    /*

     http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?outFields=*&where=&geometry={%22xmin%22:14634497.927916244,%22ymin%22:-4749031.404608972,%22xmax%22:17728668.832899354,%22ymax%22:-4015235.9330714755,%22spatialReference%22:{%22wkid%22:102100,%22latestWkid%22:3857}}&f=pjson

     */
    private static let baseUrlHMLRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outFields=*&where=&geometry="

    public static func getHMLRoute(center: CLLocationCoordinate2D, completion: (result: String) -> Void) {
        let xmin: Double = center.latitude * 100000 - 500
        let xmax: Double = center.latitude * 100000 + 500
        let ymin: Double = center.longitude * 100000 - 1000
        let ymax: Double = center.longitude * 100000 + 1000

        // let geometry: JSON = ["xmin": xmin, "xmax": xmax, "ymin": ymin, "ymax": ymax]
        let geometry = JSON(["xmin": xmin, "xmax": xmax, "ymin": ymin, "ymax": ymax])
        let url = baseUrlHMLRoute + geometry.rawString()!
        print(url)
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                }
            case .Failure(let error):
                print(error)
            }
        }
        completion(result: "end")
    }
}
