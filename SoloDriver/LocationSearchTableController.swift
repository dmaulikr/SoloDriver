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
    func addDestinationAnnotationFromSearch(annotation: MKPointAnnotation)
}

class LocationSearchTableController: UITableViewController, UISearchResultsUpdating {

    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    // Cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[(indexPath as NSIndexPath).row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = LocationManager.shared.parseAddress(selectedItem)
        return cell
    }

    // did select
    // Adapted from https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let title = cell?.textLabel?.text
        let subtitle = cell?.detailTextLabel?.text
        let selectedItem = matchingItems[(indexPath as NSIndexPath).row].placemark
        let coordinate = selectedItem.coordinate
        let annotation = DestinationAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        handleMapSearchDelegate?.addDestinationAnnotationFromSearch(annotation: annotation)
        dismiss(animated: true, completion: nil)
    }

    // Mark: UISearchResultsUpdating
    // Adapted from https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    func updateSearchResults(for searchController: UISearchController) {
        // Set up the API call for map search
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }

}
