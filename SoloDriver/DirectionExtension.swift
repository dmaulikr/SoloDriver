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
    
    // Select one direction route
    func tapHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.view.endEditing(true)
        let tapPosition = gestureRecognizer.location(in: mapView)
        let tapCoordinate = mapView.convert(tapPosition, toCoordinateFrom: mapView)
        let tapMapPoint = MKMapPointForCoordinate(tapCoordinate)
        // Check which route is picked
        for i in 0..<mapView.overlays.count {
            if (mapView.overlays[i] is DirectionPolyline) {
                let pickedPolyline = mapView.overlays[i] as! DirectionPolyline
                if Geometry.distanceOfPointAndLine(tapMapPoint, poly: pickedPolyline) > tapRadius() {
                    continue
                }
                // Colorize
                for j in 0..<mapView.overlays.count {
                    let polyline = mapView.overlays[j] as! DirectionPolyline
                    if (j == i) {
                        polyline.renderer.strokeColor = UIColor.black.withAlphaComponent(0.9)
                    } else {
                        polyline.renderer.strokeColor = UIColor.black.withAlphaComponent(0.3)
                    }
                }
                break
            }
        }
    }
    
    func longTapHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        self.navigationController?.view.endEditing(true)
        if (gestureRecognizer.state != .began) {
            return
        }
        let tapPosition = gestureRecognizer.location(in: mapView)
        let tapCoordinate = mapView.convert(tapPosition, toCoordinateFrom: mapView)
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
    func addDestinationAnnotation(_ annotation: MKPointAnnotation) {
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
    func addDestinationAnnotationFromSearch(_ annotation: MKPointAnnotation) {
        addDestinationAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func getDirection(_ annotation: MKAnnotation) {
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
    
    func coordinateToMapItem(coordinate: CLLocationCoordinate2D) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
    }
    
    func tapRadius() -> Double {
        let mapRect = mapView.visibleMapRect;
        let metersPerMapPoint = MKMetersPerMapPointAtLatitude(mapView.centerCoordinate.latitude)
        let metersPerPixel = metersPerMapPoint * mapRect.size.width / Double(mapView.bounds.size.width)
        return metersPerPixel * 10
    }
}
