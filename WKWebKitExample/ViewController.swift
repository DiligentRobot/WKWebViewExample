//
//  ViewController.swift
//  WKWebKitExample
//
//  Created by Scotty on 01/10/2017.
//  Copyright © 2017 Diligent Robot. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webViewContainter: UIView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    var webView: WKWebView!
    
    var initialLoadAction: WKNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        loadScripts(config: config)
        setUpSchemes(config: config)
        webView = WKWebView(frame: self.webViewContainter.frame, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainter.addSubview(webView)
        webViewContainter.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[webView]|",
                                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil,
                                                                           views: ["webView": webView]))
        webViewContainter.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|",
                                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil,
                                                                           views: ["webView": webView]))
        let url = URL(string: "dr-bundle-file:///cities.html")!
        initialLoadAction = webView.load(URLRequest(url:url))
    }
    
    private func loadScripts(config: WKWebViewConfiguration) {

        guard let changeCSSFilePath = Bundle.main.path(forResource: "changeCSS", ofType: "js"),
            let filterTownsFilePath = Bundle.main.path(forResource: "filterTowns", ofType: "js")else {
                fatalError("Scripts Not Found")
        }

        do {
            let changeCSSJS = try String(contentsOfFile: changeCSSFilePath)
            let changeCSSUserScript = WKUserScript(source: changeCSSJS,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: true)
            config.userContentController.addUserScript(changeCSSUserScript)
            
            let filterTownsJS = try String(contentsOfFile: filterTownsFilePath)
            let filterTownsUserScript = WKUserScript(source: filterTownsJS,
                                                   injectionTime: .atDocumentEnd,
                                                   forMainFrameOnly: true)
            config.userContentController.addUserScript(filterTownsUserScript)
            
            config.userContentController.add(self, name: "populationHasChanged")
        } catch {
            fatalError("Something went wrong: \(error)")
        }
    }
    
    private func setUpSchemes(config: WKWebViewConfiguration) {
        config.setURLSchemeHandler(self, forURLScheme: "dr-bundle-file")
    }

}

