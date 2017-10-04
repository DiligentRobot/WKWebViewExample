//
//  ViewController+WKNavigationDelegate.swift
//  WKWebKitExample
//
//  Created by Scotty on 01/10/2017.
//  Copyright © 2017 Diligent Robot. All rights reserved.
//

import UIKit
import WebKit

extension ViewController: WKNavigationDelegate {
    
    
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // If we are loading for any reason other than a link activated
        // then just process it.
        guard decidePolicyFor.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return 
        }
        
        // Reroute any request for wikipedia out to the default browser
        // then cancel the request.
        let request = decidePolicyFor.request
        if let url = request.url, let host = url.host, host == "en.m.wikipedia.org" {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        
        //By default allow the other requests to continue
        decisionHandler(.allow)
    }
    
    func webView(_: WKWebView, didFinish: WKNavigation!) {
        guard didFinish == initialLoadAction else { return }
        self.filterTowns(filter: searchField.text ?? "")
    }
}

