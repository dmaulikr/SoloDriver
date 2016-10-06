//
//  InstructionExtension.swift
//  SoloDriver
//
//  Created by HaoBoji on 25/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import Instructions

extension MasterController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    func initInstructions() {
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        self.coachMarksController.overlay.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            let leftBarButton = self.navigationItem.leftBarButtonItem! as UIBarButtonItem
            let viewLeft = leftBarButton.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: viewLeft)
        case 1:
            let view = titleItem.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: view)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: self.navigationItem.titleView)
        case 3:
            let view = titleItem.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: view)
        case 4:
            let view = titleItem.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: view)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = "Step1: Choose the features you want on the map by turning them on and also selecting the preferred route you want as per your truck category."
            coachViews.bodyView.nextLabel.text = "Next"
            break
        case 1:
            coachViews.bodyView.hintLabel.text = "Step2: Select this option to check all the possible routes marked in green or red on the visible map area to get the routes you can take as per your truck type. You can keep searching anytime for any map area."
            coachViews.bodyView.nextLabel.text = "Next"
            break
        case 2:
            coachViews.bodyView.hintLabel.text = "Step 3: Set destination via search bar or long tap on map. Then click \"Get Directions\" on the callout bubble to get potential directions."
            coachViews.bodyView.nextLabel.text = "Next"
            resultSearchController?.searchBar.text = "Crown Melbourne"
            break
        case 3:
            coachViews.bodyView.hintLabel.text = "Step 4: Select start navigation to get real time voice assistance"
            coachViews.bodyView.nextLabel.text = "Next"
            break
        case 4:
            coachViews.bodyView.hintLabel.text = "Step 5: End the navigation whenever you want. You can start and end as per your requirement."
            coachViews.bodyView.nextLabel.text = "Done"
            break
        default:
            break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkWillDisappear coachMark: CoachMark, at index: Int) {
        switch(index) {
        case 0:
            break
        case 1:
            titleItem.title = "Search Map Area"
            clearMap()
            getAnnotations()
            getRoutes()
            break
        case 2:
            let annotation = DestinationAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: -37.823507, longitude: 144.958140)
            annotation.title = "Crown Melbourne"
            annotation.subtitle = "8 Whiteman Street, Southbank"
            addDestinationAnnotationFromSearch(annotation: annotation)
            getDirection(destinationAnnotation: annotation)
            break
        case 3:
            startNavigation()
            break
        case 4:
            cancelNavigation()
            self.titleItem.title = "Search Map Area"
            break
        default:
            break
        }
    }
    
}
