//
//  ViewController+WKURLSchemeHandler.swift
//  WKWebKitExample
//
//  Created by Scotty on 02/10/2017.
//  Copyright © 2017 Diligent Robot. All rights reserved.
//

import UIKit
import WebKit

enum CustomSchemeHandlerError: Error {
    case noIdeaWhatToDoWithThis
    case fileNotFound(fileName: String)
}

extension ViewController: WKURLSchemeHandler {
    
    /// Any reqests for our custom `dr-bundle-file1 scheme will arrive here.
    func webView(_ webView: WKWebView,
                 start urlSchemeTask: WKURLSchemeTask) {
        
        // Make sure the task is for a dr-bundle-file
        guard let url = urlSchemeTask.request.url,
            let scheme = url.scheme,
            scheme == "dr-bundle-file" else {
                urlSchemeTask.didFailWithError(CustomSchemeHandlerError.noIdeaWhatToDoWithThis)
                return
        }
        
        // Extract the required file name from the request.
        let urlString = url.absoluteString
        let index = urlString.index(urlString.startIndex, offsetBy: 17)
        let file = String(urlString[index..<urlString.endIndex])
        let path = (file as NSString).deletingPathExtension
        let ext = (file as NSString).pathExtension
        
        // Try and find the file in the app bundle.
        guard let fileBundleUrl = Bundle.main.url(forResource: path,
                                                  withExtension: ext) else {
            urlSchemeTask.didFailWithError(CustomSchemeHandlerError.fileNotFound(fileName: "\(file)"))
            return
        }
        
        // Load the data from the file and prepare a URLResponse.
        do {
            let data = try Data(contentsOf: fileBundleUrl)
            let response = URLResponse(url: url,
                                       mimeType: ext == "png" ? "image/png" : "text/html",
                                       expectedContentLength: data.count,
                                       textEncodingName: nil)
            
            // Fulfill the task.
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        } catch {
            urlSchemeTask.didFailWithError(error)
        }
    }
    
    /// Not needed here but should be implemented to stop loading in cases where
    /// The fulfilling of the request was a long running asynchronous operation
    /// That may not have finished.
    func webView(_ webView: WKWebView,
                 stop urlSchemeTask: WKURLSchemeTask) {
        
    }
}
