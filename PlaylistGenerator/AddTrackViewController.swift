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
    
    var editTrack: Track!
    
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
        
        if editTrack != nil {
            titleTextField.stringValue = editTrack.title
            artistComboBox.stringValue = editTrack.artist.name
            typeComboBox.stringValue = editTrack.type.name
            newCheckBox.state = editTrack.new ? 1 : 0
            //becomesOldTextField.intValue = (NSDate().timeIntervalSinceDate(editTrack.firstAdded) / 86400
        }
    }
    
    @IBAction func newCheckBoxDidChange(sender: AnyObject) {
        becomesOldTextField.enabled = newCheckBox.state == 1
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissController(nil)
    }
    
    @IBAction func addButton(sender: AnyObject) {
        if editTrack != nil {
            saveEditedTrackPropertes()
            return
        }
        if titleTextField.stringValue == "" || artistComboBox.stringValue == "" || typeComboBox.stringValue == "" {
            let alert = NSAlert()
            alert.alertStyle = .InformationalAlertStyle
            alert.messageText = "Oops!"
            alert.informativeText = "One or more required fields are empty. Please try again."
            alert.runModal()
            return
        }
        if newCheckBox.state == 1 && becomesOldTextField.intValue <= 0 {
            let alert = NSAlert()
            alert.alertStyle = .InformationalAlertStyle
            alert.messageText = "Oops!"
            alert.informativeText = "New tracks must remain new for at least 1 day."
            alert.runModal()
            return
        }
        var artist: Artist
        var category: Category
        if !artistNames.contains(artistComboBox.stringValue) {
            artist = Artist(name: artistComboBox.stringValue, context: context)
        } else {
            artist = getArtistWithName(artistComboBox.stringValue)
        }
        if !categoryNames.contains(typeComboBox.stringValue) {
            category = Category(name: typeComboBox.stringValue, context: context)
        } else {
            category = getCategoryWithName(typeComboBox.stringValue)
        }
        let becomesOld: NSDate? = newCheckBox.state == 1 ? NSDate(timeIntervalSinceNow: 86400 * Double(becomesOldTextField.intValue)) : nil
        let track = Track(title: titleTextField.stringValue, artist: artist, new: newCheckBox.state == 1, becomesOld: becomesOld, context: context)
        track.type = category
        do {
            try context.save()
        } catch {}
        dismissController(nil)
    }
    
    private func getArtistWithName(name: String) -> Artist {
        let fetchRequest = NSFetchRequest(entityName: "Artist")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        return try! context.executeFetchRequest(fetchRequest)[0] as! Artist
    }
    
    private func getCategoryWithName(name: String) -> Category {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        return try! context.executeFetchRequest(fetchRequest)[0] as! Category
    }
    
    private func saveEditedTrackPropertes() {
        var artist: Artist
        var category: Category
        editTrack.title = titleTextField.stringValue
        if !artistNames.contains(artistComboBox.stringValue) {
            artist = Artist(name: artistComboBox.stringValue, context: context)
        } else {
            artist = getArtistWithName(artistComboBox.stringValue)
        }
        editTrack.artist = artist
        if !categoryNames.contains(typeComboBox.stringValue) {
            category = Category(name: typeComboBox.stringValue, context: context)
        } else {
            category = getCategoryWithName(typeComboBox.stringValue)
        }
        editTrack.type = category
        editTrack.new = newCheckBox.state == 1
        //let becomesOld: NSDate? = newCheckBox.state == 1 ? NSDate(timeIntervalSinceNow: 86400 * Double(becomesOldTextField.intValue)) : nil
        //let track = Track(title: titleTextField.stringValue, artist: artist, new: newCheckBox.state == 1, becomesOld: becomesOld, context: context)
        do {
            try context.save()
        } catch {}
        dismissController(nil)
    }
    
}
