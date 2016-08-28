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