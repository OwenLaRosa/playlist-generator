//
//  PlaylistViewController.swift
//  PlaylistGenerator
//
//  Created by Owen LaRosa on 9/9/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Cocoa

class PlaylistViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistViewController.updatePlaylist), name: UPDATE_PLAYLIST_NOTIFICATION, object: nil)
    }
    
    func updatePlaylist() {
        tableView.reloadData()
    }
    
}

extension PlaylistViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return generatedPlaylist.count
    }
    
}

extension PlaylistViewController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeViewWithIdentifier("PlaylistCell", owner: nil) as? NSTableCellView else {
            return nil
        }
        
        cell.textField?.stringValue = generatedPlaylist[row]
        
        return cell
    }
    
}
