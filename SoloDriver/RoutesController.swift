//
//  RoutesController.swift
//  SoloDriver
//
//  Created by HaoBoji on 10/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class RoutesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (cell.textLabel?.text == SettingsManager.shared.settings["Routes"].stringValue) {
            cell.accessoryType = .Checkmark
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        SettingsManager.shared.settings["Routes"].string = cell.textLabel!.text
        self.navigationController?.popViewControllerAnimated(true)
    }
}
