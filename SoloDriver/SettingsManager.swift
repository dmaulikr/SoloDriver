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
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent(file)
            // reading
            let settingsData = try? Data(contentsOf: path)
            if (settingsData != nil) {
                settings = JSON(data: settingsData!)
            }
        }
        if (settings["Routes"].string == nil) {
            settings["Routes"].string = "None"
        }
        if (settings["Bridge Clearance"].bool == nil) {
            settings["Bridge Clearance"].bool = true
        }
        if (settings["Roadwork"].bool == nil) {
            settings["Roadwork"].bool = true
        }
        if (settings["Event"].bool == nil) {
            settings["Event"].bool = true
        }
        if (settings["Traffic Alert"].bool == nil) {
            settings["Traffic Alert"].bool = true
        }
        if (settings["Road Closed"].bool == nil) {
            settings["Road Closed"].bool = true
        }
        if (settings["Rest Area"].bool == nil) {
            settings["Rest Area"].bool = true
        }
        if (settings["Height (m)"].double == nil) {
            settings["Height (m)"].double = 4.6
        }
        if (settings["Length (m)"].double == nil) {
            settings["Length (m)"].double = 17.5
        }
        if (settings["Width (m)"].double == nil) {
            settings["Width (m)"].double = 2.4
        }
        if (settings["Weight (t)"].double == nil) {
            settings["Weight (t)"].double = 15.0
        }
    }
    
    func saveSettings() {
        // Save settings in the background
        DispatchQueue.global(qos: .background).async {
            if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
                let path = URL(fileURLWithPath: dir).appendingPathComponent(self.file)
                do {
                    try self.settings.rawString()!.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                }
                catch { /* error handling here */ }
            }
        }
    }
    
    static func getRouteName(route: String) -> String? {
        switch route {
        case "B-Doubles Routes":
            return "B_DOUBLE"
        case "HML Routes":
            return "HML"
        case "HPFV Routes":
            return "HPFV_MASS"
        case "2 Axle SPV Routes":
            return "SPV_2AXLE"
        case "40t SPV Routes":
            return "SPV_40T"
        case "OSOM Routes":
            return "OSOM_SCHEME_PERMIT"
        default:
            return nil
        }
    }
    
    // WIFI Indicator
    var semaphore: Int = 0
    func networkON() {
        semaphore += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }
    func networkOff() {
        semaphore -= 1
        if (semaphore == 0) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
