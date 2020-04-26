//
//  Document.swift
//  Jupyter Notebook Viewer
//
//  Created by Tino Wagner on 29.01.17.
//  Copyright © 2017 Tino Wagner. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    var jsonString:String = "";

    override init() {
        super.init()
    }

    override class var autosavesInPlace: Bool {
        return false
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Load JSON data
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            self.jsonString = String(data: jsonData, encoding: .utf8)!
        } catch {
            throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil)
        }
    }


}

