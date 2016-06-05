//
//  LibraryViewController.swift
//  PlaylistGenerator
//
//  Created by Owen LaRosa on 6/4/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Cocoa

class LibraryViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension LibraryViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 30
    }
    
}

extension LibraryViewController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.makeViewWithIdentifier("TableCell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = ""
            return cell
        }
        return nil
    }
    
}
