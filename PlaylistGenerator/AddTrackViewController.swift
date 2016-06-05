//
//  AddTrackViewController.swift
//  PlaylistGenerator
//
//  Created by Owen LaRosa on 6/5/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Cocoa

class AddTrackViewController: NSViewController {
    
    let context = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var titleTextField: NSTextField!
    
    @IBOutlet weak var artistComboBox: NSComboBox!
    
    @IBOutlet weak var typeComboBox: NSComboBox!
    
    @IBOutlet weak var newCheckBox: NSButton!
    
    @IBOutlet weak var becomesOldTextField: NSTextField!
    
    var artistNames = [String]()
    var categoryNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let artistFetchRequest = NSFetchRequest(entityName: "Artist")
        artistNames = try! context.executeFetchRequest(artistFetchRequest).map() {
            ($0 as! Artist).name
        }
        let categoryFetchRequest = NSFetchRequest(entityName: "Category")
        categoryNames = try! context.executeFetchRequest(categoryFetchRequest).map() {
            ($0 as! Category).name
        }
        artistComboBox.addItemsWithObjectValues(artistNames)
        typeComboBox.addItemsWithObjectValues(categoryNames)
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissController(nil)
    }
    
    @IBAction func addButton(sender: AnyObject) {
    }
    
    
}
