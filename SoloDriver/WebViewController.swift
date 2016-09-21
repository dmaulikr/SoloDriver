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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.scalesPageToFit = true
            webView.loadRequest(request)
        }
    }
    
    func close(_: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
