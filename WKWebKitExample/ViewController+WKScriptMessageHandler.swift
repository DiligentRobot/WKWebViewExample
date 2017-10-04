//
//  ViewController+WKScriptMessageHandler.swift
//  WKWebKitExample
//
//  Created by Scotty on 02/10/2017.
//  Copyright © 2017 Diligent Robot. All rights reserved.
//

import UIKit
import WebKit

extension ViewController: WKScriptMessageHandler {
    
    /// When JavaScript in the web page calls `webkit.messageHandlers.populationHasChanged.postMessage()`
    /// It will arrive here.
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
        // Check we are processing the populationHasChanged message,
        // That the message body is a JSON Dictionary and has the population key.
        guard message.name == "populationHasChanged",
            let body = message.body as? [String: Any],
            let population = body["population"] as? Int else {
            return
        }
    
        // Make sure we update the UI on the main thread. 
        DispatchQueue.main.async {
            self.populationLabel.text = "Population: \(population)"
        }
    }
    
}
