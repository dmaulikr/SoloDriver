//
//  EditTextController.swift
//  SoloDriver
//
//  Created by HaoBoji on 27/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class EditTextController: UITableViewController {

    @IBOutlet var input: UITextField!

    var titleString: String?
    var editText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        input.text = editText
    }

    override func viewDidAppear(_ animated: Bool) {
        input.becomeFirstResponder()
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        if let inputValue = Double(input.text!) {
            if (inputValue > 0) {
                SettingsManager.shared.settings[titleString!].double = inputValue
                SettingsManager.shared.saveSettings()
                _ = self.navigationController?.popViewController(animated: true)
                return
            }
        }
        let errorDialog = UIAlertController(
            title: "Invalid Input",
            message: "Please enter a decimal number.",
            preferredStyle: UIAlertControllerStyle.alert)
        errorDialog.addAction(UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.default,
            handler: nil))
        self.present(errorDialog, animated: false, completion: nil)
    }
}
