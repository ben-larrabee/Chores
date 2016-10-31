//
//  NoteStore.swift
//  Notes
//
//  Created by Ben Larrabee on 10/19/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class NoteStore {
  static let shared = NoteStore() // singleton
  fileprivate var notes: [Note]!
  var categories: [ToDoCategory]!
  var selectedImage: UIImage?
  var sortedNotes: [[Note]]!
  var filteredNotes: [[Note]]!
  var unclaimed: [Note]! = []
  
  init() {
    print("started shared instantiation")
    let categoryFilePath = archiveFilePath(task: "CategoryStore.plist")
    let categoryFileManager = FileManager.default
    if categoryFileManager.fileExists(atPath: categoryFilePath) {
      print("found saved categories")
      categories = NSKeyedUnarchiver.unarchiveObject(withFile: categoryFilePath) as! [ToDoCategory]
      print(categories)
    } else {
      print("didn't find categories")
      categories = []
      sortedNotes = []
      addCategory(newCategory: ToDoCategory(name: "Unsorted", color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
      addCategory(newCategory: ToDoCategory(name: "Pa", color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)))
      print(categories)
    }
    let noteFilePath = archiveFilePath(task: "NoteStore.plist")
    let noteFileManager = FileManager.default
    if noteFileManager.fileExists(atPath: noteFilePath) {
      print("found saved notes")
      notes = NSKeyedUnarchiver.unarchiveObject(withFile: noteFilePath) as! [Note]
    } else {
      print("didn't find notes")
      sortedNotes[0].append(Note(title: "By Ben Larrabee", text: "Ben Larrabee is a TA with TEKY.  This app was created as part of a 9 month coding bootcamp.  Look him up, he's a cool guy."))
      sortedNotes[0].append(Note(title: "Getting Started", text: "Add Notes by clicking the plus button.\nSee full details by clicking on any note.  You can also edit a note by clicking on it, then making changes in the detail view, and then saving changes.  You can swipe left to delete a note."))
      sortedNotes[0].append(Note(title: "Welcome", text: "This is ElevenNote, an app created for TEKY"))
    }
    save()
    print("completed shared instantiation")
    print("the app knows notes =\(self.notes)")
  }
  
  
  // MARK: - Public functions
  func getNote(at category: Int, index: Int) -> Note {
    print("the index is \(index)")
    return sortedNotes[category][index]
  }
  func addNote(_ note: Note) {
    sortedNotes[note.categoryIndex].insert(note, at: sortedNotes[note.categoryIndex].count)
    print("a note was sucessfully added")
  }
  func updateNote(_ note: Note, category: Int, index : Int) {
    sortedNotes[category][index] = note
    reSort()
  }
  func deleteNote(_ category: Int, index: Int) {
    sortedNotes[category].remove(at: index)
    reSort()
  }
  func swapNote(fromIndexPath: IndexPath, toIndexPath: IndexPath) {
    let temp = NoteStore.shared.sortedNotes[fromIndexPath.section][fromIndexPath.row]
    NoteStore.shared.sortedNotes[fromIndexPath.section][fromIndexPath.row] = NoteStore.shared.sortedNotes[toIndexPath.section][toIndexPath.row]
    NoteStore.shared.sortedNotes[toIndexPath.section][toIndexPath.row] = temp
  }
  func repositionNote(from: IndexPath, to: IndexPath){
    let note = sortedNotes[from.section][from.row]
    if from.section != to.section {
      note.categoryIndex = to.section
      note.categoryName = categories[to.section].name
      note.categoryBG = categories[to.section].categoryBG
    }
    deleteNote(from.section, index: from.row)
    sortedNotes[note.categoryIndex].insert(note, at: to.row)
  }
  func shiftCategory(indexPath: Int) {
    for note in sortedNotes[indexPath] {
      note.categoryIndex = indexPath - 1
    }
  }
  func getCount(section: Int) -> Int {
    return sortedNotes[(section)].count
  }
  func save() {
    print("started save")
    notes = []
    for category in 0..<sortedNotes.count {
      for note in sortedNotes[category] {
        notes.append(note)
      }
    }
    NSKeyedArchiver.archiveRootObject(notes, toFile: archiveFilePath(task: "NoteStore.plist"))
    NSKeyedArchiver.archiveRootObject(categories, toFile: archiveFilePath(task: "CategoryStore.plist"))
    print("completed save")
    sort()
  }
  func filterNotes() {
    filteredNotes = []
    for category in 0..<sortedNotes.count {
      filteredNotes.append([])
      for note in 0..<sortedNotes[category].count {
        if sortedNotes[category][note].isComplete == false {
          let temp = sortedNotes[category][note]
          filteredNotes[category].append(temp)
        }
      }
    }
    print("filtered notes has contents: ")
    print(filteredNotes)
  }
  
  func reSort() {
    notes = []
    for category in 0..<sortedNotes.count {
      for note in sortedNotes[category] {
        notes.append(note)
      }
    }
    print("calling sort from reSort")
    sort()
  }
  func sort() {
    print("started sort")
    sortedNotes = []
    for _ in categories {
      sortedNotes.append([])
    }
    
    for note in notes {
      sortedNotes[note.categoryIndex].append(note)
    }
    for category in 0..<categories.count {
      
      sortedNotes[category].sort { $0.priority > $1.priority }
    }
    print("completed sort")
  }
  func addCategory(newCategory: ToDoCategory) {
    categories.append(newCategory)
    sortedNotes.append([])
  }
  
  // Mark: - PRivate Functions
  fileprivate func archiveFilePath(task: String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths.first!
    let path = (documentDirectory as NSString).appendingPathComponent(task)
    return path
  }
  
}
