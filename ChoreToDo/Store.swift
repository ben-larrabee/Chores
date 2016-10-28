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
  var currentCategoryIndex = 1
  var selectedImage: UIImage?
  var sortedNotes: [[Note]]!
  var filteredNotes: [[Note]]!
  let colors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1),#colorLiteral(red: 0.5769939423, green: 0.06602010131, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0.5, alpha: 1)]
  //  let colors = [
  //    UIColor(red: CGFloat(1.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: 1.0),//red
  //    UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(1.0), alpha: 1.0),//blue
  //    UIColor(red: CGFloat(0.0), green: CGFloat(0.5), blue: CGFloat(0.0), alpha: 1.0),//green
  //    UIColor(red: CGFloat(0.5), green: CGFloat(0.0), blue: CGFloat(0.5), alpha: 1.0),//purple
  //    UIColor(red: CGFloat(0.5), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: 1.0),//maroon
  //    UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.5), alpha: 1.0)//navy
  //    ]
  
  init() {
    print("started shared instantiation")
    let noteFilePath = archiveFilePath(task: "NoteStore.plist")
    let noteFileManager = FileManager.default
    if noteFileManager.fileExists(atPath: noteFilePath) {
      print("found saved notes")
      notes = NSKeyedUnarchiver.unarchiveObject(withFile: noteFilePath) as! [Note]
      print(notes)
    } else {
      print("didn't find notes")
      notes = []
      notes.append(Note(title: "By Ben Larrabee", text: "Ben Larrabee is a TA with TEKY.  This app was created as part of a 9 month coding bootcamp.  Look him up, he's a cool guy."))
      notes.append(Note(title: "Getting Started", text: "Add Notes by clicking the plus button.\nSee full details by clicking on any note.  You can also edit a note by clicking on it, then making changes in the detail view, and then saving changes.  You can swipe left to delete a note."))
      notes.append(Note(title: "Welcome", text: "This is ElevenNote, an app created for TEKY"))
      print(notes)
    }
    let categoryFilePath = archiveFilePath(task: "CategoryStore.plist")
    let categoryFileManager = FileManager.default
    if categoryFileManager.fileExists(atPath: categoryFilePath) {
      print("found saved categories")
      categories = NSKeyedUnarchiver.unarchiveObject(withFile: categoryFilePath) as! [ToDoCategory]
      self.currentCategoryIndex = categories.count
      print(categories)
    } else {
      print("didn't find categories")
      categories = []
      print(categories)
      categories.append(ToDoCategory(name: "Unsorted", color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) ))
      categories.append(ToDoCategory(name: "Pa", color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1) ))
      print(categories)
      self.currentCategoryIndex = 2
    }
    save()
    sort()
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
  func getCount(section: Int) -> Int {
    return sortedNotes[(section)].count
  }
  func save() {
    print("started save")
    NSKeyedArchiver.archiveRootObject(notes, toFile: archiveFilePath(task: "NoteStore.plist"))
    NSKeyedArchiver.archiveRootObject(categories, toFile: archiveFilePath(task: "CategoryStore.plist"))
    print("completed save")
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
    currentCategoryIndex += 1
  }
  
  // Mark: - PRivate Functions
  fileprivate func archiveFilePath(task: String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths.first!
    let path = (documentDirectory as NSString).appendingPathComponent(task)
    return path
  }
  
}
