//
//  SettingsManager.swift
//  SoloDriver
//
//  Created by HaoBoji on 28/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsManager: NSObject {

    static let shared = SettingsManager()

    let file = "Settings.json"
    var settings: JSON = [:]

    override init() {
        super.init()
        loadSettings()
    }

    func loadSettings() {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)

            // reading
            let settingsData = NSData(contentsOfURL: path)
            if (settingsData != nil) {
                settings = JSON(data: settingsData!)
                if (settings["Routes"].string == nil || settings["Routes"].string == "") {
                    settings["Routes"].string = "None"
                }
            }
        }
    }

    func saveSettings() {
        // print(self.settings)
        // Save settings in the background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(self.file)
                do {
                    try self.settings.rawString()!.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                }
                catch { /* error handling here */ }
            }
        })
    }

    func getCachedSettings() -> JSON {
        return settings
    }

    func getSettings() -> JSON {
        var settings: JSON = [:]

        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)

            // reading
            let settingsData = NSData(contentsOfURL: path)
            if (settingsData != nil) {
                settings = JSON(data: settingsData!)
            }
        }
        return settings
    }

    func saveSettings(settings: JSON) {
        self.settings = settings
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            do {
                print(settings.rawString())
                try settings.rawString()!.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch { /* error handling here */ }
        }
    }
}