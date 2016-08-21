//
//  AboutController.swift
//  SoloDriver
//
//  Created by HaoBoji on 18/08/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class AboutController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    static let URL_ABOUT = "https://docs.google.com/document/d/12VEs0wMTe4USIcaBZFPEDMT0xYGPSHr5xOhIXlUGkFk/pub"
    static let URL_HML = "https://docs.google.com/document/d/1w5hmNikQ9WMhqc-tHs25yxk4SsReEMiL__kB5X-ob6I/pub?embedded=true"
    static let URL_HPFV = "https://docs.google.com/document/d/1xbJcEowR0rhpsbCB7KdWcK6tZv1oce8mtY58qMYQAnI/pub?embedded=true"
    static let URL_BRIDGE = "https://docs.google.com/document/d/1xwkfgzvQo4fIYaqLp5w_XsShcmXf8OgnDjHvdUmcYEo/pub?embedded=true"

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = CategoriesController.currentCategory
        // Set url
        let url: NSURL
        switch CategoriesController.currentCategory {
        case CategoriesController.TITLE_HML:
            url = NSURL (string: AboutController.URL_HML)!;
        case CategoriesController.TITLE_HPFV:
            url = NSURL (string: AboutController.URL_HPFV)!;
        case CategoriesController.TITLE_BRIDGE:
            url = NSURL (string: AboutController.URL_BRIDGE)!;
        default:
            url = NSURL()
        }
        let requestObj = NSURLRequest(URL: url);
        webView.delegate = self
        webView.loadRequest(requestObj);
    }

    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { }
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let newURL = request.URL {
            if (newURL.absoluteString.containsString("https://docs.google.com/document")) {
                return true
            }
            if UIApplication.sharedApplication().canOpenURL(newURL) {
                print("canOpenURL")
                if UIApplication.sharedApplication().openURL(newURL) {
                    print("redirected to browser")
                    self.viewWillAppear(false)
                    return false // no need to open this url in your app
                }
            }
        }
        return true
    }

}
