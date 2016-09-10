//
//  FilterController.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class FilterController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet var routesTitle: UILabel!

    override func viewWillAppear(animated: Bool) {
        routesTitle.text = SettingsManager.shared.settings["Routes"].stringValue
        super.viewWillAppear(animated)
    }

    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true) { }
    }

    @IBOutlet var sBridgeClearance: UISwitch! {
        didSet {
            sBridgeClearance.on = SettingsManager.shared.settings["Bridge Clearance"].boolValue
        }
    }

    @IBAction func aBridgeClearance(sender: UISwitch) {
        SettingsManager.shared.settings["Bridge Clearance"].bool = sender.on
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sRoadwork: UISwitch! {
        didSet {
            sRoadwork.on = SettingsManager.shared.settings["Roadwork"].boolValue
        }
    }

    @IBAction func aRoadwork(sender: UISwitch) {
        SettingsManager.shared.settings["Roadwork"].bool = sender.on
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sEvent: UISwitch! {
        didSet {
            sEvent.on = SettingsManager.shared.settings["Event"].boolValue
        }
    }

    @IBAction func aEvent(sender: UISwitch) {
        SettingsManager.shared.settings["Event"].bool = sender.on
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sTowAllocation: UISwitch! {
        didSet {
            sTowAllocation.on = SettingsManager.shared.settings["Tow Allocation"].boolValue
        }
    }

    @IBAction func aTowAllocation(sender: UISwitch) {
        SettingsManager.shared.settings["Tow Allocation"].bool = sender.on
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sTrafficAlert: UISwitch! {
        didSet {
            sTrafficAlert.on = SettingsManager.shared.settings["Traffic Alert"].boolValue
        }
    }

    @IBAction func aTrafficAlert(sender: UISwitch) {
        SettingsManager.shared.settings["Traffic Alert"].bool = sender.on
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sRoadClosed: UISwitch! {
        didSet {
            sRoadClosed.on = SettingsManager.shared.settings["Road Closed"].boolValue
        }
    }

    @IBAction func aRoadClosed(sender: UISwitch) {
        SettingsManager.shared.settings["Road Closed"].bool = sender.on
        SettingsManager.shared.saveSettings()
    }

}
