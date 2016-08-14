//
//  PublicDataService.swift
//  SoloDriver
//
//  Created by HaoBoji on 14/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import Foundation

public class PublicDataService: NSObject {
    /*

     http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?outFields=*&where=&geometry={%22xmin%22:14634497.927916244,%22ymin%22:-4749031.404608972,%22xmax%22:17728668.832899354,%22ymax%22:-4015235.9330714755,%22spatialReference%22:{%22wkid%22:102100,%22latestWkid%22:3857}}&f=pjson

     */
    let baseUrlHMLRoute = "http://data.vicroads.vic.gov.au/arcgis/rest/services/HeavyVehicles/HML_Route/FeatureServer/0/query?f=pjson&outFields=*&where=&geometry="
}
