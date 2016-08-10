//
//  GenerateViewController.swift
//  PlaylistGenerator
//
//  Created by Owen LaRosa on 8/10/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Cocoa

class GenerateViewController: NSViewController {
    
    let context = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var typePopupButton: NSPopUpButton!
    
    var selectedTypes = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let typeFetchRequest = NSFetchRequest(entityName: "Category")
        var typeNames = try! context.executeFetchRequest(typeFetchRequest).map() {
            ($0 as! Category).name
        }
        typeNames.append("New")
        typePopupButton.removeAllItems()
        typePopupButton.addItemsWithTitles(typeNames)
    }
    
    @IBAction func addButtonClicked(sender: NSButton) {
        
    }
    
    @IBAction func generateButtonClicked(sender: NSButton) {
        
    }
    
    @IBAction func cancelButtonClicked(sender: NSButton) {
        dismissController(nil)
    }
    
}
