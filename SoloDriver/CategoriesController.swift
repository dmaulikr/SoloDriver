//
//  CategoriesController.swift
//  SoloDriver
//
//  Created by HaoBoji on 17/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class CategoriesController: UITableViewController {

    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) {
            // TODO
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        // Configure the cell...
        cell.imageView!.image = UIImage(named: "Truck Filled-100")
        return cell
    }

}
