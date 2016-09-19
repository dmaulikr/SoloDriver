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
    }

    func saveSettings() {
        print(self.settings)
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
