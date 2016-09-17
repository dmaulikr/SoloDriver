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

    override func viewWillAppear(_ animated: Bool) {
        if (SettingsManager.shared.settings["Routes"].stringValue == "") {
            SettingsManager.shared.settings["Routes"].string = "None"
        }
        routesTitle.text = SettingsManager.shared.settings["Routes"].stringValue
        super.viewWillAppear(animated)
    }

    @IBAction func done(_ sender: AnyObject) {
        dismiss(animated: true) { }
    }

    @IBOutlet var sBridgeClearance: UISwitch! {
        didSet {
            sBridgeClearance.isOn = SettingsManager.shared.settings["Bridge Clearance"].boolValue
        }
    }

    @IBAction func aBridgeClearance(_ sender: UISwitch) {
        SettingsManager.shared.settings["Bridge Clearance"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sRoadwork: UISwitch! {
        didSet {
            sRoadwork.isOn = SettingsManager.shared.settings["Roadwork"].boolValue
        }
    }

    @IBAction func aRoadwork(_ sender: UISwitch) {
        SettingsManager.shared.settings["Roadwork"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sEvent: UISwitch! {
        didSet {
            sEvent.isOn = SettingsManager.shared.settings["Event"].boolValue
        }
    }

    @IBAction func aEvent(_ sender: UISwitch) {
        SettingsManager.shared.settings["Event"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sTowAllocation: UISwitch! {
        didSet {
            sTowAllocation.isOn = SettingsManager.shared.settings["Tow Allocation"].boolValue
        }
    }

    @IBAction func aTowAllocation(_ sender: UISwitch) {
        SettingsManager.shared.settings["Tow Allocation"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sTrafficAlert: UISwitch! {
        didSet {
            sTrafficAlert.isOn = SettingsManager.shared.settings["Traffic Alert"].boolValue
        }
    }

    @IBAction func aTrafficAlert(_ sender: UISwitch) {
        SettingsManager.shared.settings["Traffic Alert"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sRoadClosed: UISwitch! {
        didSet {
            sRoadClosed.isOn = SettingsManager.shared.settings["Road Closed"].boolValue
        }
    }

    @IBAction func aRoadClosed(_ sender: UISwitch) {
        SettingsManager.shared.settings["Road Closed"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }

    @IBOutlet var sRestArea: UISwitch! {
        didSet {
            sRestArea.isOn = SettingsManager.shared.settings["Rest Area"].boolValue
        }
    }

    @IBAction func aRestArea(_ sender: UISwitch!) {
        SettingsManager.shared.settings["Rest Area"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }
}
