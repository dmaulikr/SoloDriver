//
//  WebViewController.swift
//  SoloDriver
//
//  Created by HaoBoji on 21/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.scalesPageToFit = true
            webView.loadRequest(request)
        }
    }
    
}
