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
    
    var selectedTypeNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let typeFetchRequest = NSFetchRequest(entityName: "Category")
        var typeNames = try! context.executeFetchRequest(typeFetchRequest).map() {
            ($0 as! Category).name
        }
        typeNames.append("New")
        typeNames.append("Artist")
        typePopupButton.removeAllItems()
        typePopupButton.addItemsWithTitles(typeNames)
    }
    
    @IBAction func addButtonClicked(sender: NSButton) {
        if let title = typePopupButton.titleOfSelectedItem {
            selectedTypeNames.append(title)
            tableView.reloadData()
        }
    }
    
    @IBAction func generateButtonClicked(sender: NSButton) {
        
    }
    
    @IBAction func cancelButtonClicked(sender: NSButton) {
        dismissController(nil)
    }
    
}

extension GenerateViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return selectedTypeNames.count
    }
    
}

extension GenerateViewController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print("viewForTableColumn")
        guard let cell = tableView.makeViewWithIdentifier("TypeCell", owner: nil) as? NSTableCellView else {
            return nil
        }
        
        cell.textField?.stringValue = selectedTypeNames[row]
        
        return cell
    }
    
}
