//
//  CategoriesController.swift
//  SoloDriver
//
//  Created by HaoBoji on 17/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class CategoriesController: UITableViewController {

    static let TITLE_HML = "HML Routes"
    static let TITLE_HPFV = "HPFV Routes"
    static let TITLE_BRIDGE = "Bridge Clearances"
    static var currentCategory: String = TITLE_HML

    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.imageView!.image = UIImage(named: "bridge-on-avenue-perspective")
            cell.textLabel!.text = CategoriesController.TITLE_BRIDGE
            break
        case 1:
            cell.imageView!.image = UIImage(named: "frontal-truck")
            cell.textLabel!.text = CategoriesController.TITLE_HML
            break
        case 2:
            cell.imageView!.image = UIImage(named: "truck")
            cell.textLabel!.text = CategoriesController.TITLE_HPFV
            break
        default:
            break
        }
        if (cell.textLabel!.text == CategoriesController.currentCategory) {
            cell.accessoryType = .Checkmark
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        CategoriesController.currentCategory = tableView.cellForRowAtIndexPath(indexPath)!.textLabel!.text!
        self.dismissViewControllerAnimated(true) { }
    }

}
