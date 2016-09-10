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
        generatePlaylist()
    }
    
    @IBAction func cancelButtonClicked(sender: NSButton) {
        dismissController(nil)
    }
    
    func generatePlaylist() {
        var playlistItems = [String]()
        var usedArtists = [Artist]()
        
        for i in selectedTypeNames {
            print(i)
        }
        
        var artists = getArtists()
        var categoryTable = getCategories()
        var newTracks = getNewTracks()
        print("artists: \(artists.count)")
        print("newTracks: \(newTracks.count)")
        for i in selectedTypeNames {
            if i == "New" {
                if newTracks.count == 0 {
                    playlistItems.append("No Track")
                } else {
                    let availableTracks = newTracks.filter() {
                        !usedArtists.contains($0.artist)
                    }
                    if availableTracks.count == 0 {
                        playlistItems.append("No Track")
                    } else {
                        let track = availableTracks[Int(arc4random()) % availableTracks.count]
                        playlistItems.append("\(track.title) - \(track.artist.name)")
                        usedArtists.append(track.artist)
                    }
                }
            } else if i == "Artist" {
                let availableArtists = artists.filter() {
                    !usedArtists.contains($0)
                }
                if availableArtists.count == 0 {
                    playlistItems.append("No Artist")
                } else {
                    let artist = availableArtists[Int(arc4random()) % availableArtists.count]
                    playlistItems.append("Song by \(artist.name)")
                    usedArtists.append(artist)
                }
            } else {
                if let availableTracks = (categoryTable[i]?.tracks.allObjects as? [Track])?.filter({
                    !usedArtists.contains($0.artist)
                }) {
                    print("available tracks: \(availableTracks.count)")
                    if availableTracks.count != 0 {
                        let track = availableTracks[Int(arc4random()) % availableTracks.count]
                        playlistItems.append("\(track.title) - \(track.artist.name)")
                        usedArtists.append(track.artist)
                    } else {
                        playlistItems.append("No Track")
                    }
                } else {
                    playlistItems.append("No Track")
                }
            
            }
        }
        print("finished generating playlist")
        for i in playlistItems {
            print(i)
        }
        generatedPlaylist = playlistItems
        NSNotificationCenter.defaultCenter().postNotificationName(UPDATE_PLAYLIST_NOTIFICATION, object: nil)
        dismissController(nil)
    }
    
    // MARK: - Fetch Requests
    
    func getArtists() -> [Artist] {
        let fetchRequest = NSFetchRequest(entityName: "Artist")
        return try! context.executeFetchRequest(fetchRequest) as! [Artist]
    }
    
    func getCategories() -> [String: Category] {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let categories = try! context.executeFetchRequest(fetchRequest) as! [Category]
        var categoryTable = [String: Category]()
        for i in categories {
            categoryTable[i.name] = i
        }
        return categoryTable
    }
    
    func getNewTracks() -> [Track] {
        let fetchRequest = NSFetchRequest(entityName: "Track")
        fetchRequest.predicate = NSPredicate(format: "new == true", argumentArray: nil)
        let fetchedObjects = try! context.executeFetchRequest(fetchRequest) as! [Track]
        var result = [Track]()
        for i in fetchedObjects {
            if NSDate().timeIntervalSinceDate(i.becomesOld!) > 0 {
                i.new = false
                continue
            }
            result.append(i)
        }
        return result
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
