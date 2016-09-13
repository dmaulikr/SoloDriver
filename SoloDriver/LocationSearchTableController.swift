//
//  LocationSearchTableController.swift
//  WanderList
//
//  Created by HaoBoji on 3/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Adapted from https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
//
//  Seach table under search bar
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func addAnnotationFromSearch(annotation: MKPointAnnotation)
}

class LocationSearchTableController: UITableViewController, UISearchResultsUpdating {

    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    // Cell view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        // cell.detailTextLabel?.text = LocationManager.shared.parseAddress(selectedItem)
        return cell
    }

    // did select
    // Adapted from https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let title = cell?.textLabel?.text
        let subtitle = cell?.detailTextLabel?.text
        let selectedItem = matchingItems[indexPath.row].placemark
        let coordinate = selectedItem.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        handleMapSearchDelegate?.addAnnotationFromSearch(annotation)
        dismissViewControllerAnimated(true, completion: nil)
    }

    // Mark: UISearchResultsUpdating
    // Adapted from https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Set up the API call for map search
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }

}
