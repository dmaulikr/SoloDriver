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

extension MasterController: UIGestureRecognizerDelegate, HandleMapSearch {

    func initDirection() {
        // Search bar
        addSearchBar()
    }
    
    func addSearchBar() {
        // Search result list under search bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController!.searchResultsUpdater = locationSearchTable
        // Setup search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Destination"
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = false
        navigationItem.titleView = resultSearchController!.searchBar
        resultSearchController!.hidesNavigationBarDuringPresentation = false
        resultSearchController!.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        // Setup search table
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    // Add annotation to map
    func addDestinationAnnotation(annotation: MKPointAnnotation) {
        // clear existing pins
        for annotation in mapView.annotations {
            if annotation is DestinationAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    // Add annotation from search result
    func addDestinationAnnotationFromSearch(annotation: MKPointAnnotation) {
        addDestinationAnnotation(annotation: annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func getDirection(annotation: MKAnnotation) {
        // Clear existing directions
        for overlay in mapView.overlays {
            if overlay is DirectionPolyline {
                mapView.remove(overlay)
            }
        }
        // Get directions
        let destination = annotation.coordinate
        let request: MKDirectionsRequest = MKDirectionsRequest()
        if (LocationManager.shared.getLastLocation() == nil) {
            return
        }
        request.source = coordinateToMapItem(coordinate: LocationManager.shared.getLastLocation()!.coordinate)
        request.destination = coordinateToMapItem(coordinate: destination)
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if (error != nil) {
                return
            }
            if let routes = response?.routes {
                for i in 0..<routes.count {
                    let polyline = DirectionPolyline(route: routes[i])
                    if (i == 0) {
                        polyline.color = UIColor.black.withAlphaComponent(0.9)
                    } else {
                        polyline.color = UIColor.black.withAlphaComponent(0.3)
                    }
                    self.mapView.add(polyline)
                }
            }
        }
    }
}
