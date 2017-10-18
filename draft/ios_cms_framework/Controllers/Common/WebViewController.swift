//
//  WebViewController.swift
//  CIASMovie
//
//  Created by Albert on 15/05/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SnapKit


class WebViewController: UIViewController{
    
    let jsMsgName = "Notification_iOS"
    
    var requestURL: String = ""
    var webViewTitle: String = ""
    
    private var webView: WKWebView!
    fileprivate var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentC = WKUserContentController()
        contentC.add(self as WKScriptMessageHandler, name: jsMsgName)
        
        let conf = WKWebViewConfiguration()
        conf.userContentController = contentC
        
        webView = WKWebView(frame: self.view.bounds, configuration: conf)
        webView.navigationDelegate = self
        
//        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.backgroundColor = UIColor.clear
        indicatorView.center = view.center
        indicatorView.hidesWhenStopped = true
        view.addSubview(indicatorView)
        
        
        load(requestURL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = webViewTitle
    }
    
    func load(_ aURL: String) {
        let _url = URL(string: aURL)
        
        guard let url = _url else {
            return
        }
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        webView.load(request as URLRequest)
    }
    
    
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.stopAnimating()
    }
    
}

extension WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        
        guard message.name == jsMsgName, let dic = message.body as? [String: Any] else {
            return
        }
        
        if let couponIds = dic["coupon"] as? [String] {
           couponIds.forEach({ (item) in
            print(item)
           })
        }
        
        if let activities = dic["activity"] as? [String] {
            activities.forEach({ (item) in
                print(item)
            })
        }
        
       
    }
}
