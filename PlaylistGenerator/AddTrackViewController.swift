//
//  AddTrackViewController.swift
//  PlaylistGenerator
//
//  Created by Owen LaRosa on 6/5/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Cocoa

class AddTrackViewController: NSViewController {
    
    @IBOutlet weak var titleTextField: NSTextField!
    
    @IBOutlet weak var artistComboBox: NSComboBox!
    
    @IBOutlet weak var typeComboBox: NSComboBox!
    
    @IBOutlet weak var newCheckBox: NSButton!
    
    @IBOutlet weak var becomesOldTextField: NSTextField!
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissController(nil)
    }
    
    @IBAction func addButton(sender: AnyObject) {
    }
    
    
}
