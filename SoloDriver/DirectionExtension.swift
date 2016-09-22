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
                break
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
    
    func getDirection(destinationAnnotation: MKAnnotation) {
        // Check gps availability
        if (LocationManager.shared.getLastLocation() == nil) {
            let alert = UIAlertController(title: "Oops", message: "Cannot get your location...", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        // Clear existing directions
        for polylines in directionSteps {
            mapView.removeOverlays(polylines)
        }
        directionSteps = []
        // Get directions, step by step
        for waypointCount in 0..<waypoints.count+1 {
            let source: CLLocationCoordinate2D
            let destination: CLLocationCoordinate2D
            // source
            if (waypointCount == 0) {
                source = LocationManager.shared.getLastLocation()!.coordinate
            } else {
                source = waypoints[waypointCount-1].coordinate
            }
            // destination
            if (waypointCount == waypoints.count) {
                destination = destinationAnnotation.coordinate
            } else {
                destination = waypoints[waypointCount].coordinate
            }
            // request
            let request: MKDirectionsRequest = MKDirectionsRequest()
            request.source = coordinateToMapItem(coordinate: source)
            request.destination = coordinateToMapItem(coordinate: destination)
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            // per step
            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                if (error != nil || response?.routes == nil) {
                    return
                }
                var directionStep: [DirectionPolyline] = []
                for i in 0..<response!.routes.count {
                    let polyline = DirectionPolyline(route: response!.routes[i])
                    if (i == 0) {
                        polyline.color = UIColor.black.withAlphaComponent(0.9)
                    } else {
                        polyline.color = UIColor.black.withAlphaComponent(0.3)
                    }
                    directionStep += [polyline]
                    self.mapView.add(polyline)
                }
                self.directionSteps += [directionStep]
            }
        }
        self.titleItem.title = "Start Navigation"
    }
}
