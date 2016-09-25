//
//  SettingsController.swift
//  SoloDriver
//
//  Created by HaoBoji on 27/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    let MY_TRUCK = 0
    let PREFERED_ROUTE = 1
    let ACKNOWLEDGEMENTS = 2

    @IBOutlet var height: UITableViewCell!
    @IBOutlet var length: UITableViewCell!
    @IBOutlet var width: UITableViewCell!
    @IBOutlet var weight: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view as! UIScrollView).showsVerticalScrollIndicator = false
    }

    @IBAction func done(_ sender: AnyObject) {
        dismiss(animated: true) { }
    }
    
    @IBOutlet var sInstruction: UISwitch! {
        didSet {
            sInstruction.isOn = SettingsManager.shared.settings["InstructionIsEnabled"].boolValue
        }
    }
    
    @IBAction func aInstruction(_ sender: UISwitch) {
        SettingsManager.shared.settings["InstructionIsEnabled"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }
    
    @IBOutlet var sTutorial: UISwitch! {
        didSet {
            sTutorial.isOn = SettingsManager.shared.settings["TutorialIsEnabled"].boolValue
        }
    }
    
    @IBAction func aTutorial(_ sender: UISwitch) {
        SettingsManager.shared.settings["TutorialIsEnabled"].bool = sender.isOn
        SettingsManager.shared.saveSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let settings = SettingsManager.shared.settings
        if (settings["Height (m)"].double == nil) {
            height.detailTextLabel?.text = "--"
        } else {
            height.detailTextLabel?.text = String(format: "%.1f", settings["Height (m)"].doubleValue)
        }
        if (settings["Length (m)"].double == nil) {
            length.detailTextLabel?.text = "--"
        } else {
            length.detailTextLabel?.text = String(format: "%.1f", settings["Length (m)"].doubleValue)
        }
        if (settings["Width (m)"].double == nil) {
            width.detailTextLabel?.text = "--"
        } else {
            width.detailTextLabel?.text = String(format: "%.1f", settings["Width (m)"].doubleValue)
        }
        if (settings["Weight (t)"].double == nil) {
            weight.detailTextLabel?.text = "--"
        } else {
            weight.detailTextLabel?.text = String(format: "%.1f", settings["Weight (t)"].doubleValue)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).section {
        case MY_TRUCK:
            let cell = tableView.cellForRow(at: indexPath)
            let destination = storyboard!.instantiateViewController(withIdentifier: "EditTextController") as! EditTextController
            destination.titleString = cell?.textLabel?.text
            destination.editText = cell?.detailTextLabel?.text
            self.navigationController?.pushViewController(destination, animated: true)
            break
        default:
            break
        }
    }

}
