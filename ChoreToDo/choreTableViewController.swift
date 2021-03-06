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
  let searchController = UISearchController(searchResultsController: nil)
  var searchfilteredNotes = [[Note]]()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let unclaimed = NoteStore.shared.unclaimed {
      while unclaimed.count != 0 {
        let note = NoteStore.shared.unclaimed.popLast()
        print(note?.title)
        let newIndexPath = IndexPath(row: NoteStore.shared.getCount(section: 0), section: 0)
        NoteStore.shared.sortedNotes[0].append(note!)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    }
    self.navigationItem.rightBarButtonItem = self.editButtonItem
    if filteringComplete.isOn {
      NoteStore.shared.filterNotes()
    }
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 6
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("checking section \(section)")
    if searchController.isActive && searchController.searchBar.text != "" {
      return searchfilteredNotes[section].count
    } else if filteringComplete.isOn {
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
    if searchController.isActive && searchController.searchBar.text != "" {
      cell.setupCell(searchfilteredNotes[indexPath.section][indexPath.row])
    } else if filteringComplete.isOn {
      cell.setupCell(NoteStore.shared.filteredNotes[indexPath.section][indexPath.row])
    } else {
      cell.setupCell(NoteStore.shared.getNote(at: indexPath.section, index: indexPath.row))
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if filteringComplete.isOn {
      return false
    } else {
    return true
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      NoteStore.shared.deleteNote(indexPath.section, index: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
      // handled in unwind from segue
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
  func filterContentForSearchText(searchText: String, scope: String = "All") {
    searchfilteredNotes = [[],[],[],[],[],[]]
    for category in 0..<NoteStore.shared.sortedNotes.count {
      for note in NoteStore.shared.sortedNotes[category] {
        if note.title.lowercased().contains(searchText.lowercased()) {
        searchfilteredNotes[category].append(note)
        }
      }
    }
    tableView.reloadData()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editChoreSegue" {
      if searchController.isActive && searchController.searchBar.text != "" {
        let choreDetailVC  = segue.destination as! ChoreEditDetailVC
        if let selectedChoreCell = sender as? NoteTableViewCell {
          let indexPath = tableView.indexPath(for: selectedChoreCell)!
          let selectedChore = searchfilteredNotes[indexPath.section][indexPath.row]
          choreDetailVC.note = selectedChore
        }
      }
      if filteringComplete.isOn {
        // do nothing
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
      if let sourceViewController = sender.source as? ChoreAddDetailVC {
        let note = sourceViewController.note
        let newIndexPath = IndexPath(row: NoteStore.shared.getCount(section: note.categoryIndex), section: note.categoryIndex)
        NoteStore.shared.sortedNotes[note.categoryIndex].append(note)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    }
  }

  @IBAction func filtering(_ sender: UISwitch) {
    if filteringComplete.isOn {
      NoteStore.shared.filterNotes()
    }
    tableView.reloadData()
  }
  @IBAction func switchflicked(_ sender: UIBarButtonItem) {
  }
  @IBAction func saveNoteDetail(_ segue: UIStoryboardSegue) {
  }
}
extension NotesTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for: UISearchController) {
    filterContentForSearchText(searchText: searchController.searchBar.text!)
  }
}
