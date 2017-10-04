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
        
        // Create a configuration, load any required scripts
        // and register custom schemes.
        let config = WKWebViewConfiguration()
        loadScripts(config: config)
        setUpSchemes(config: config)
        

        // Create a WKWebView and set its delegates
        webView = WKWebView(frame: self.webViewContainter.frame, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        // Set Up Auto Layout for the WKWebView
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
        
        // Load the initial file
        let url = URL(string: "dr-bundle-file:///cities.html")!
        initialLoadAction = webView.load(URLRequest(url:url))
    }
    
    /// Load the custom script file from the bundle and add them to the
    /// WKWebViewConfiguration content controller.
    private func loadScripts(config: WKWebViewConfiguration) {

        // Get the paths for the two custom script files.
        guard let changeCSSFilePath = Bundle.main.path(forResource: "changeCSS", ofType: "js"),
            let filterTownsFilePath = Bundle.main.path(forResource: "filterTowns", ofType: "js")else {
                fatalError("Scripts Not Found")
        }

        do {
            // Add the change-css script file.
            let changeCSSJS = try String(contentsOfFile: changeCSSFilePath)
            let changeCSSUserScript = WKUserScript(source: changeCSSJS,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: true)
            config.userContentController.addUserScript(changeCSSUserScript)
            
            // Add the filterTowns script file.
            let filterTownsJS = try String(contentsOfFile: filterTownsFilePath)
            let filterTownsUserScript = WKUserScript(source: filterTownsJS,
                                                   injectionTime: .atDocumentEnd,
                                                   forMainFrameOnly: true)
            config.userContentController.addUserScript(filterTownsUserScript)
            
            // Register to receive populationHasChanged messages.
            config.userContentController.add(self, name: "populationHasChanged")
        } catch {
            fatalError("Something went wrong: \(error)")
        }
    }
    
    /// Register custom url scheme with the WKWebViewConfiguration.
    private func setUpSchemes(config: WKWebViewConfiguration) {
        config.setURLSchemeHandler(self, forURLScheme: "dr-bundle-file")
    }

}

