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
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
        guard message.name == "populationHasChanged",
            let body = message.body as? [String: Any],
            let population = body["population"] as? Int else {
            return
        }
    
        DispatchQueue.main.async {
            self.populationLabel.text = "Population: \(population)"
        }
    }
    
}
