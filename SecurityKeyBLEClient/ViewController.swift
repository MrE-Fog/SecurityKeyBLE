//
//  ViewController.swift
//  SecurityKeyBLEClient
//
//  Created by Benjamin P Toews on 9/5/16.
//  Copyright © 2016 GitHub. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var u2fClient: Client?

    override func viewDidLoad() {
        super.viewDidLoad()
        u2fClient = Client()
        
        do {
            try u2fClient?.register("hello world")
        } catch {
            print("shit")
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

