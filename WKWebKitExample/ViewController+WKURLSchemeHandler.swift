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
    
    func webView(_ webView: WKWebView,
                 start urlSchemeTask: WKURLSchemeTask) {
        
        guard let url  = urlSchemeTask.request.url,
            let scheme = url.scheme,
            scheme == "dr-bundle-file" else {
                urlSchemeTask.didFailWithError(CustomSchemeHandlerError.noIdeaWhatToDoWithThis)
                return
        }
        
        let urlString = url.absoluteString
        let index = urlString.index(urlString.startIndex, offsetBy: 17)
        let file = String(urlString[index..<urlString.endIndex])
        let path = (file as NSString).deletingPathExtension
        let ext = (file as NSString).pathExtension
        
        guard let fileBundleUrl = Bundle.main.url(forResource: path,
                                                  withExtension: ext) else {
            urlSchemeTask.didFailWithError(CustomSchemeHandlerError.fileNotFound(fileName: "\(file)"))
            return
        }
        
        do {
            let data = try Data(contentsOf: fileBundleUrl)
            let response = URLResponse(url: url,
                                       mimeType: ext == "png" ? "image/png" : "text/html",
                                       expectedContentLength: data.count,
                                       textEncodingName: nil)
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        } catch {
            urlSchemeTask.didFailWithError(error)
        }
    }
    
    func webView(_ webView: WKWebView,
                 stop urlSchemeTask: WKURLSchemeTask) {
        
    }
}
