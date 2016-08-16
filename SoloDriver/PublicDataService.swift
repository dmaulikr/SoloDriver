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

     http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?outFields=*&outSR=4326&geometry={%22xmin%22:14634497.927916244,%22ymin%22:-4749031.404608972,%22xmax%22:17728668.832899354,%22ymax%22:-4015235.9330714755,%22spatialReference%22:{%22wkid%22:102100,%22latestWkid%22:3857}}&f=pjson

     http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?where=&objectIds=&time=&geometry=%7B%22xmin%22%3A146.34497927916244%2C%22ymin%22%3A-47.49031404608972%2C%22xmax%22%3A177.28668832899354%2C%22ymax%22%3A-30.152359330714755%2C%22spatialReference%22%3A%7B%22wkid%22+%3A+4326%7D&geometryType=esriGeometryEnvelope&inSR=4326&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=4326&gdbVersion=&returnDistinctValues=false&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&multipatchOption=&f=html



     */
    private static let test = ""

    private static let ENVELOPE_RADIUS: Double = 0.1
    private static let baseUrlHMLRoute = "https://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outSR=4326&inSR=4326&outFields=*&where=&geometry="

    public static func getHMLRoute(center: CLLocationCoordinate2D, completion: (result: JSON) -> Void) {
        var url = baseUrlHMLRoute + createEnvelopeGeometry(center)
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(result: json["features"])
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    public static func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    private static func createEnvelopeGeometry(center: CLLocationCoordinate2D) -> String {
        let ymin: Double = center.latitude - ENVELOPE_RADIUS
        let ymax: Double = center.latitude + ENVELOPE_RADIUS
        let xmin: Double = center.longitude - ENVELOPE_RADIUS
        let xmax: Double = center.longitude + ENVELOPE_RADIUS
        let geometry = JSON(["xmin": xmin, "xmax": xmax, "ymin": ymin, "ymax": ymax])
        print(geometry)
        return geometry.rawString()!
    }

}
