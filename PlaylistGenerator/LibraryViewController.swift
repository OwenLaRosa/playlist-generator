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
    
    @IBOutlet weak var editTrackButton: NSButton!
    
    @IBOutlet weak var removeTrackButton: NSButton!
    
    var tracks = [Track]()
    var selectedTrack: Track!
    let context = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest(entityName: "Track")
        tracks = try! context.executeFetchRequest(fetchRequest) as! [Track]
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func editTrackButtonTapped(sender: AnyObject) {
        if selectedTrack == nil {
            let alert = NSAlert()
            alert.alertStyle = .InformationalAlertStyle
            alert.messageText = "Oops!"
            alert.informativeText = "Please select a track in order to edit."
            alert.runModal()
            return
        }
        performSegueWithIdentifier("AddTrack", sender: selectedTrack)
    }
    
    @IBAction func removeTrackButtonTapped(sender: AnyObject) {
        tracks.removeAtIndex(tableView.selectedRow)
        context.deleteObject(selectedTrack)
        do {
            try context.save()
        } catch {}
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddTrack" {
            let destinationVC = segue.destinationController as! AddTrackViewController
            if let editTrack = sender as? Track {
                destinationVC.editTrack = editTrack
            }
        }
    }

}

extension LibraryViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tracks.count
    }
    
}

extension LibraryViewController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let track = tracks[row]
        guard let cell = tableView.makeViewWithIdentifier("TableCell", owner: nil) as? NSTableCellView else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            cell.textField?.stringValue = track.title
        } else if tableColumn == tableView.tableColumns[1] {
            cell.textField?.stringValue = track.artist.name
        } else if tableColumn == tableView.tableColumns[2] {
            cell.textField?.stringValue = track.type.name
        }
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        selectedTrack = tracks[tableView.selectedRow]
    }
    
}
