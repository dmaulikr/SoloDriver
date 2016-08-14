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

public class PublicDataService: NSObject {
    /*

     http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?outFields=*&where=&geometry={%22xmin%22:14634497.927916244,%22ymin%22:-4749031.404608972,%22xmax%22:17728668.832899354,%22ymax%22:-4015235.9330714755,%22spatialReference%22:{%22wkid%22:102100,%22latestWkid%22:3857}}&f=pjson

     */
    private static let baseUrlHMLRoute = "http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outFields=*&where=&geometry="

    public static func getHMLRoute(center: CLLocationCoordinate2D, completion: (String)) {
        let minX = center.latitude * 100000 - 500
        let maxX = center.latitude * 100000 + 500
        let minY = center.longitude * 100000 - 1000
        let maxY = center.longitude * 100000 + 1000
        print(minX)
        print(maxX)
        print(minY)
        print(maxY)
        let geometry = "{"
        Alamofire.request(.GET, baseUrlHMLRoute, parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request) // original URL request
                print(response.response) // URL response
                print(response.data) // server data
                print(response.result) // result of response serialization

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
}
