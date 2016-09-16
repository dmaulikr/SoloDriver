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

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) { }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        // Configure the cell...
        switch (indexPath as NSIndexPath).row {
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
            cell.accessoryType = .checkmark
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        CategoriesController.currentCategory = tableView.cellForRow(at: indexPath)!.textLabel!.text!
        self.dismiss(animated: true) { }
    }

}
