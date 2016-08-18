//
//  AboutController.swift
//  SoloDriver
//
//  Created by HaoBoji on 18/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: "https://docs.google.com/document/d/12VEs0wMTe4USIcaBZFPEDMT0xYGPSHr5xOhIXlUGkFk/pub");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    }

    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { }
    }

}
