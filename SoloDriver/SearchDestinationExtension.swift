//
//  SearchDestinationExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import SCLAlertView

extension MasterController {

    func addSearchBar() {

        // Search result list under serach bar
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTableController
        let resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        // Setup search bar
        let searchBar = resultSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Destination"
        searchBar.searchBarStyle = .Minimal
        navigationItem.titleView = resultSearchController.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        // Setup search table
        locationSearchTable.mapView = mapView
        // locationSearchTable.handleMapSearchDelegate = self
    }
}