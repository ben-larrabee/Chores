//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Ben Larrabee on 10/18/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
  
  @IBOutlet weak var filteringComplete: UISwitch!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    if filteringComplete.isOn {
      NoteStore.shared.filterNotes()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 6
    //return NoteStore.shared.categories.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    print("checking section \(section)")
    if filteringComplete.isOn {
      if section < NoteStore.shared.categories.count {
        return NoteStore.shared.filteredNotes[section].count
      } else {
        return 0
      }
    } else {
      if section < NoteStore.shared.categories.count {
        print("The getCount method for section \(section) says \(NoteStore.shared.getCount(section: section))")
        return NoteStore.shared.getCount(section: section)
      } else {
        print("The section isn't implemented yet")
        return 0
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section < NoteStore.shared.categories.count {
      return NoteStore.shared.categories[section].name
    } else {
      return ""
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteTableViewCell.self)) as! NoteTableViewCell
    if filteringComplete.isOn {
      cell.setupCell(NoteStore.shared.filteredNotes[indexPath.section][indexPath.row])
    } else {
      cell.setupCell(NoteStore.shared.getNote(at: indexPath.section, index: indexPath.row))
    }
    return cell
  }
  
  
   // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
    if filteringComplete.isOn {
      return false
    } else {
    return true
    }
  }
  
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      NoteStore.shared.deleteNote(indexPath.section, index: indexPath.row)
      //trying again with this trick
      //using the following code in place of the commented out code below
      //tableView.reloadData()
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    NoteStore.shared.repositionNote(from: fromIndexPath, to: to)
    tableView.reloadData()
  }
  
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
    if filteringComplete.isOn {
      return false
    } else {
    return true
    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editChoreSegue" {
      if filteringComplete.isOn {
        print("About to do something bad")
      } else {
        let choreDetailVC = segue.destination as! ChoreEditDetailVC
        // Get the cell that generated this segue.
        if let selectedChoreCell = sender as? NoteTableViewCell {
          let indexPath = tableView.indexPath(for: selectedChoreCell)!
          let selectedChore = NoteStore.shared.sortedNotes[indexPath.section][indexPath.row]
          choreDetailVC.note = selectedChore
        }
      }
    }
  }
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "EditChoreSegue" {
//      print("Sending chore to edit screen")
//      let noteDetailVC = segue.destination as! ChoreEditDetailVC
//      let tableCell = sender as! NoteTableViewCell
//      print(tableCell.note.title)
//      noteDetailVC.note = tableCell.note
//    }
//  }
  // MARK: - Unwind Segue
  @IBAction func unwindToChoreList(sender: UIStoryboardSegue) {
    if filteringComplete.isOn {
      //do nothing
    } else {
      if let sourceViewController = sender.source as? ChoreEditDetailVC {
        let note = sourceViewController.note
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
          NoteStore.shared.sortedNotes[selectedIndexPath.section][selectedIndexPath.row] = note
          tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
          NoteStore.shared.updateNote(note, category: selectedIndexPath.section, index: selectedIndexPath.row)
        }
      }
    

//        let newIndexPath = IndexPath(row: NoteStore.shared.getCount(section: note.categoryIndex), section: note.categoryIndex)
//        NoteStore.shared.sortedNotes[note.categoryIndex].append(note)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
        // Add a new meal.
      if let sourceViewController = sender.source as? ChoreAddDetailVC {
        let note = sourceViewController.note
        let newIndexPath = IndexPath(row: NoteStore.shared.getCount(section: note.categoryIndex), section: note.categoryIndex)
        NoteStore.shared.sortedNotes[note.categoryIndex].append(note)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        print("appended new entry successfully")
        print("the contents of notes are now")
        print(NoteStore.shared.sortedNotes)
      }
    }
  }

  @IBAction func filtering(_ sender: UISwitch) {
    print("button detected")
    if filteringComplete.isOn {
      NoteStore.shared.filterNotes()
//    var indexPaths = [IndexPath]()
//    for i in 0..<NoteStore.shared.filteredNotes.count {
//      for j in 0..<NoteStore.shared.filteredNotes[i].count {
//        let indexPath = IndexPath(row: j, section: i)
//        indexPaths.append(indexPath)
//      }
//    }
    }
    tableView.reloadData()
  }
  @IBAction func switchflicked(_ sender: UIBarButtonItem) {
  
  }
  @IBAction func saveNoteDetail(_ segue: UIStoryboardSegue) {
//    let noteDetailVC = segue.source as! ChoreEditDetailVC
//    if let indexPath = tableView.indexPathForSelectedRow {
//      NoteStore.shared.updateNote(noteDetailVC.note, category: indexPath.section, index: indexPath.row)
//      // NoteStore.shared.sort()
//      var indexPaths: [IndexPath] = []
//      for section in 0...indexPath.section{
//        for index in 0...indexPath.row{
//          indexPaths.append(IndexPath(row: index, section: section))
//        }
//      }
//      tableView.reloadRows(at: indexPaths, with: .automatic)
//    } else {
//      NoteStore.shared.addNote(noteDetailVC.note)
//      //trying the following
//      tableView.reloadData()
//      // in place of this commented out code
//      //let indexPath = IndexPath(row: 0, section: 0)
//      //tableView.insertRows(at: [indexPath], with: .automatic)
//    }
  }
}
