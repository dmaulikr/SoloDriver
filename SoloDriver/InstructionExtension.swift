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

extension MasterController: CoachMarksControllerDataSource {
    
    func initInstructions() {
        self.coachMarksController.dataSource = self
        self.coachMarksController.overlay.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        //        let skipView = CoachMarkSkipDefaultView()
        //        skipView.setTitle("Skip", for: .normal)
        //        self.coachMarksController.skipView = skipView
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        if (SettingsManager.shared.settings["InstructionIsEnabled"].bool == false) {
            return 0
        } else {
            SettingsManager.shared.settings["InstructionIsEnabled"].bool = false
            return 6
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            let leftBarButton = self.navigationItem.leftBarButtonItem! as UIBarButtonItem
            let viewLeft = leftBarButton.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: viewLeft)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.navigationItem.titleView)
        case 2:
            let rightBarButton = self.navigationItem.rightBarButtonItem! as UIBarButtonItem
            let viewRight = rightBarButton.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: viewRight)
        case 3:
            return coachMarksController.helper.makeCoachMark(for: userTrackingButton?.customView)
        case 4:
            let view = titleItem.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: view)
        case 5:
            let view = actionItem.value(forKey: "view") as! UIView
            return coachMarksController.helper.makeCoachMark(for: view)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = "Filter: Change desired map features"
            coachViews.bodyView.nextLabel.text = "Next"
        case 1:
            coachViews.bodyView.hintLabel.text = "Destination: Search for destination"
            coachViews.bodyView.nextLabel.text = "Next"
        case 2:
            coachViews.bodyView.hintLabel.text = "Settings: Change truck dimensions"
            coachViews.bodyView.nextLabel.text = "Next"
        case 3:
            coachViews.bodyView.hintLabel.text = "Tracking Button: Change among tracking modes"
            coachViews.bodyView.nextLabel.text = "Next"
        case 4:
            coachViews.bodyView.hintLabel.text = "Current Action: Click to perform this action"
            coachViews.bodyView.nextLabel.text = "Next"
        case 5:
            coachViews.bodyView.hintLabel.text = "All Actions: Click to see all possible actions"
            coachViews.bodyView.nextLabel.text = "Done"
        default:
            break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
