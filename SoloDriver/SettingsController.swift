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

    override func viewWillAppear(animated: Bool) {
        let settings = SettingsManager.shared.getSettings()
        print(settings)
        if (settings["Height (m)"].double == nil) {
            height.detailTextLabel?.text = "--"
        } else {
            height.detailTextLabel?.text = String(settings["Height (m)"].doubleValue)
        }
        if (settings["Length (m)"].double == nil) {
            length.detailTextLabel?.text = "--"
        } else {
            length.detailTextLabel?.text = String(settings["Length (m)"].doubleValue)
        }
        if (settings["Width (m)"].double == nil) {
            width.detailTextLabel?.text = "--"
        } else {
            width.detailTextLabel?.text = String(settings["Width (m)"].doubleValue)
        }
        if (settings["Weight (t)"].double == nil) {
            weight.detailTextLabel?.text = "--"
        } else {
            weight.detailTextLabel?.text = String(settings["Weight (t)"].doubleValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case MY_TRUCK:
            return 4
        case PREFERED_ROUTE:
            return 1
        case ACKNOWLEDGEMENTS:
            return 3
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case MY_TRUCK:
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let destination = storyboard.instantiateViewControllerWithIdentifier("EditTextController") as! EditTextController
            destination.titleString = cell?.textLabel?.text
            destination.editText = cell?.detailTextLabel?.text
            self.navigationController?.pushViewController(destination, animated: true)
            break
        default:
            break
        }
    }

//    // MARK: - Navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        switch segue.identifier! {
//        case "Height":
//            let destinationController = segue.destinationViewController as! EditTextController
//            destinationController.titleString
//            break
//        default:
//            <#code#>
//        }
//    }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.

    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

     // Configure the cell...

     return cell
     }
     */

    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

}