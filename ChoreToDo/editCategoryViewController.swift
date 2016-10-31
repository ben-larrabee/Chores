//
//  EditCategoryViewController.swift
//  Notes
//
//  Created by Ben Larrabee on 10/25/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class EditCategoryViewController: UIViewController {
  
  @IBOutlet weak var editCategoryBGColor: UIView!
  @IBOutlet weak var editCategoryName: UITextField!
  @IBOutlet weak var editRedBGColor: UISlider!
  @IBOutlet weak var editGreenBGColor: UISlider!
  @IBOutlet weak var editBlueBGColor: UISlider!
  @IBOutlet weak var save: UIBarButtonItem!
  let defaults = UserDefaults.standard
  var category = ToDoCategory()
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    let colorData = defaults.data(forKey: "editBGColor")
//    if let colorData = colorData {
//      editCategoryBGColor.backgroundColor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    } else {
//      editCategoryBGColor.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
//    }
//    let BGColor = CIColor(color: editCategoryBGColor.backgroundColor!)
    editCategoryBGColor.backgroundColor = category.categoryBG
    let BGColor = CIColor(color: editCategoryBGColor.backgroundColor!)
    editRedBGColor.value = Float(BGColor.red)
    editGreenBGColor.value = Float(BGColor.green)
    editBlueBGColor.value = Float(BGColor.blue)
    editCategoryName.text = category.name
    
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    
//    let colorData = NSKeyedArchiver.archivedData(withRootObject: editCategoryBGColor.backgroundColor!)
//    defaults.set(colorData, forKey: "editBGColor")
//    
//    defaults.synchronize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
   // MARK: - Navigation
   
   @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
   }
   // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
    print("saving a category")
    if let name = editCategoryName.text {
      category.name = name
    } else {
      category.name = "No name found"
    }
    category.image = #imageLiteral(resourceName: "generic")
    category.categoryBG = editCategoryBGColor.backgroundColor!
  }
  
  @IBAction func categoryColorChange(_ sender: AnyObject) {
    editCategoryBGColor.backgroundColor = UIColor(red: CGFloat(editRedBGColor.value), green: CGFloat(editGreenBGColor.value), blue: CGFloat(editBlueBGColor.value), alpha: 1.0)
    
  }
//  @IBAction func addCategory(_ sender: AnyObject) {
//    if editCategoryName.text != "CategoryName" {
//      NoteStore.shared.addCategory(newCategory: (ToDoCategory(name: editCategoryName.text!, color: editCategoryBGColor.backgroundColor!)))
//      let alertController = UIAlertController(title: "To Do Alert", message: "Your category was created.", preferredStyle: .alert)
//      let actionOk = UIAlertAction(title: "Dismiss",
//                                   style: .default,
//                                   handler: nil)
//      alertController.addAction(actionOk)
//      self.present(alertController, animated: true, completion: nil)
//    } else {
//      let alertController = UIAlertController(title: "To Do Alert", message: "A name is required.", preferredStyle: .alert)
//      let actionOk = UIAlertAction(title: "OK",
//                                   style: .default,
//                                   handler: nil)
//      alertController.addAction(actionOk)
//      self.present(alertController, animated: true, completion: nil)
//    }
//  }
  
  
}
