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
    
    
    /// When a navigation action occurs for a link to wikipedia, ensure it gets
    /// Moved out to the default browser.
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
        
        // By default allow the other requests to continue
        decisionHandler(.allow)
    }
    
    /// When the first load of the initial html page is finished
    /// Call the filter JavaScript within the page.
    func webView(_: WKWebView, didFinish: WKNavigation!) {
        guard didFinish == initialLoadAction else { return }
        self.filterTowns(filter: searchField.text ?? "")
    }
}

