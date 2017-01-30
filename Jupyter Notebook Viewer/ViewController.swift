//
//  ViewController.swift
//  Jupyter Notebook Viewer
//
//  Created by Tino Wagner on 29.01.17.
//  Copyright © 2017 Tino Wagner. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var webview: WebView!
    
    weak var document: Document? {
        let window = self.view.window!
        let windowController = window.windowController!
        return windowController.document as? Document
    }
    
    override func viewWillAppear() {
        // Render HTML
        let resourceURL = Bundle.main.resourceURL
        let templateURL = Bundle.main.url(forResource: "template", withExtension: "html")
        let templateString = try? String(contentsOf: templateURL!, encoding: .utf8)
        if (templateString != nil) {
            let jsonString = self.document!.jsonString
            let html = templateString!.replacingOccurrences(of: "%notebook-json%", with: jsonString)
            webview.mainFrame!.loadHTMLString(html, baseURL: resourceURL)
        }
    }

}

