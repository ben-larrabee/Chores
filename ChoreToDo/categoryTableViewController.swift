//
//  categoryTableViewController.swift
//  ChoreToDo
//
//  Created by Ben Larrabee on 10/27/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class categoryTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

  
    self.navigationItem.rightBarButtonItem = self.editButtonItem
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NoteStore.shared.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: categoryTableViewCell.self)) as! categoryTableViewCell
      cell.setupCell(NoteStore.shared.categories[indexPath.row])
        return cell
    }
  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          if indexPath.row == 0 {
            let alertController = UIAlertController(title: "ChoreToDo Alert", message: "You Cannot Delete the Unclaimed Category!", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Dismiss",
                                         style: .default,
                                         handler: nil)
            alertController.addAction(dismiss)
            self.present(alertController, animated: true, completion: nil)
            return
          }
          else {
            for note in NoteStore.shared.sortedNotes[indexPath.row] {
              note.categoryName = "Unsorted"
              note.categoryBG = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
              if var unclaimed = NoteStore.shared.unclaimed {
                unclaimed.append(note)
              }
            }
            for i in indexPath.row..<NoteStore.shared.categories.count {
              NoteStore.shared.shiftCategory(indexPath: i)
            }
            NoteStore.shared.sortedNotes.remove(at: indexPath.row)
            NoteStore.shared.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
          }
          } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
          //tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
  

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "EditCategorySegue" {
        let categoryEditVC = segue.destination as! EditCategoryViewController
        let tableCell = sender as! categoryTableViewCell
        //let indexPath = tableView.indexPathForSelectedRow
        let indexPath = tableView.indexPath(for: tableCell)
        categoryEditVC.category = NoteStore.shared.categories[(indexPath?.row)!]
      } else if segue.identifier == "addCategorySegue" {
        
      }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
  // MARK: - Unwind Segue
  @IBAction func unwindToCategoryList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? EditCategoryViewController {
      let category = sourceViewController.category
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        NoteStore.shared.categories[selectedIndexPath.row] = category
        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
      } else {
        let newIndexPath = IndexPath(row: NoteStore.shared.categories.count, section: 0)
        NoteStore.shared.addCategory(newCategory: (ToDoCategory(name: category.name, color: category.categoryBG)))
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
//      if let sourceViewController = sender.source as? ChoreAddDetailVC {
//        let note = sourceViewController.note
//        let newIndexPath = IndexPath(row: NoteStore.shared.getCount(section: note.categoryIndex), section: note.categoryIndex)
//        NoteStore.shared.sortedNotes[note.categoryIndex].append(note)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
//        print("appended new entry successfully")
//        print("the contents of notes are now")
//        print(NoteStore.shared.sortedNotes)
    }
  }
}
