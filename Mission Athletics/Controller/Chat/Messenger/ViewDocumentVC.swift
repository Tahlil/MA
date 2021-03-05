//
//  ViewDocumentVC.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 01/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import WebKit

class ViewDocumentVC: UIViewController, WKNavigationDelegate
{
    var fileName = ""
    var fileUrlStr = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var webViewDocument: WKWebView!

    // MARK: - Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = self.fileName.removingPercentEncoding
        let req = URLRequest(url: NSURL(string: self.fileUrlStr == "" ? "https://www.google.com" : self.fileUrlStr)! as URL)
        self.webViewDocument.load(req)
        
//        self.webViewDocument.sizeToFit()//.scalesPageToFit = true
//        self.webViewDocument.contentMode = .scaleAspectFit
        
        // Do any additional setup after loading the view.
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        self.showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.hideLoading()
    }

}
