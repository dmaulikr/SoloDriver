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
        // Long tap to mark destination
        registerTapGestures()
    }

    func addSearchBar() {
        // Search result list under serach bar
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTableController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController!.searchResultsUpdater = locationSearchTable
        // Setup search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Destination"
        searchBar.searchBarStyle = .Minimal
        searchBar.showsCancelButton = false
        navigationItem.titleView = resultSearchController!.searchBar
        resultSearchController!.hidesNavigationBarDuringPresentation = false
        resultSearchController!.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        // Setup search table
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }

    // Register tap gesture for searching destination
    func registerTapGestures() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        mapView.addGestureRecognizer(tapRecognizer)
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapHandler(_:)))
        longTapRecognizer.delegate = self
        mapView.addGestureRecognizer(longTapRecognizer)
    }

    func tapHandler(gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.view.endEditing(true)
    }

    func longTapHandler(gestureRecognizer: UILongPressGestureRecognizer) {
        self.navigationController?.view.endEditing(true)
        if (gestureRecognizer.state != .Began) {
            return
        }
        let tapPosition = gestureRecognizer.locationInView(mapView)
        let tapCoordinate = mapView.convertPoint(tapPosition, toCoordinateFromView: mapView)
        let tapLocation = CLLocation(latitude: tapCoordinate.latitude, longitude: tapCoordinate.longitude)
        // Parse coordinate to address
        CLGeocoder().reverseGeocodeLocation(tapLocation) { (placemarks, error) in
            var address = "Unknow Place"
            if (error == nil && placemarks!.count > 0) {
                address = LocationManager.shared.parseAddress(placemarks![0])
            }
            let annotation = DestinationAnnotation()
            annotation.coordinate = tapCoordinate
            annotation.title = "Dropped Pin"
            annotation.subtitle = address
            self.addDestinationAnnotation(annotation)
        }
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
        addDestinationAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

}

