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

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let indexPath = tableView.indexPath(for: tableCell)
        categoryEditVC.category = NoteStore.shared.categories[(indexPath?.row)!]
      }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
  
  @IBAction func unwindToCategoryTableVC (sender: UIStoryboardSegue){
    if let sourceViewController = sender.source as? EditCategoryViewController {
      let category = sourceViewController.category
      let newIndexPath = IndexPath(row: NoteStore.shared.categories.count - 1, section: 0)
      tableView.insertRows(at: [newIndexPath], with: .automatic)
      //NoteStore.shared.categories.append(category)
    }
  }
}
