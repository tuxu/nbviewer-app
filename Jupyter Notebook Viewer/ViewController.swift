//
//  ViewController.swift
//  Jupyter Notebook Viewer
//
//  Created by Tino Wagner on 29.01.17.
//  Copyright © 2017 Tino Wagner. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSTextFinderBarContainer
{
    @IBOutlet weak var webview: WKWebView!
    
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
            webview.loadHTMLString(html, baseURL: resourceURL)
        }
        textFinder.client = webview
        textFinder.findBarContainer = self
    }
    
    // MARK: Page Zoom -
    var zoomAmount = 1.0 {
        didSet {
            webview.evaluateJavaScript("document.body.style.zoom = '\(zoomAmount)'", completionHandler: nil)
        }
    }

    @IBAction func makeTextLarger(_ sender: Any?) {
        zoomAmount *= 1.1
    }

    @IBAction func makeTextSmaller(_ sender: Any?) {
        zoomAmount /= 1.1
    }

    @IBAction func makeTextStandardSize(_ sender: Any?) {
        zoomAmount = 1.0
    }

    // MARK: Text Search -
    
    var textFinder: NSTextFinder = NSTextFinder()
    
    @IBAction override func performTextFinderAction(_ sender: Any?) {
        guard let action = NSTextFinder.Action(rawValue: (sender as! NSMenuItem).tag) else {
            return
        }
        textFinder.performAction(action)
    }
    
    // MARK: NSTextFinderBarContainer
    
    var findBarView: NSView? {
        didSet {
            if let findBarView = findBarView {
                findBarView.frame = NSMakeRect(0, self.view.bounds.height - findBarView.frame.height, self.view.bounds.width, findBarView.frame.height)
            }
        }
    }
    
    var isFindBarVisible: Bool = false {
        didSet {
            if isFindBarVisible, let findBarView = findBarView {
                self.view.addSubview(findBarView)
            } else {
                findBarView?.removeFromSuperview()
            }
        }
    }
    
    func findBarViewDidChangeHeight() {
        if let findBarView = findBarView {
            findBarView.frame = NSMakeRect(0, self.view.bounds.height - findBarView.frame.height, self.view.bounds.width, findBarView.frame.height)
        }
    }
    
    func contentView() -> NSView? {
        view
    }
    
}

