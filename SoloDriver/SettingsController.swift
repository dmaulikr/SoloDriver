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

    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true) { }
    }

    override func viewWillAppear(animated: Bool) {
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case MY_TRUCK:
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let destination = storyboard!.instantiateViewControllerWithIdentifier("EditTextController") as! EditTextController
            destination.titleString = cell?.textLabel?.text
            destination.editText = cell?.detailTextLabel?.text
            self.navigationController?.pushViewController(destination, animated: true)
            break
        default:
            break
        }
    }

}