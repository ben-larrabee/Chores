//
//  ChoreAddDetailVC.swift
//  Notes
//
//  Created by Ben Larrabee on 10/18/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

//@IBAction func send10SecNotification(_ sender: UIButton) {
//  if isGrantedNotificationAccess{
//    //add notification code here
//  }
//}
//let trigger = UNTimeIntervalNotificationTrigger(
//  timeInterval: 10.0,
//  repeats: false)
//let request = UNNotificationRequest(
//  identifier: "10.second.message",
//  content: content,
//  trigger: trigger
//)
//UNUserNotificationCenter.current().add(
//  request, withCompletionHandler: nil

//UNUserNotificationCenter.current().requestAuthorization(
//  options: [.alert,.sound,.badge],
//  completionHandler: { (granted,error) in
//    self.isGrantedNotificationAccess = granted
//  }
//)


import UIKit
import UserNotifications

class ChoreAddDetailVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UNUserNotificationCenterDelegate {
  
  @IBOutlet weak var noteTitleField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var categoryPicker: UIPickerView!
  @IBOutlet weak var dateTimePicker: UIDatePicker!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  
  var gestureRecognizer: UITapGestureRecognizer!
  var note = Note()
  var pickerData : [String] = []
  var dueDate = Note().date
  var categoryIndex = Note().categoryIndex
  var categoryBG = Note().categoryBG
  var category : String = "Unclaimed"
  var isGrantedNotificationAccess:Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //dateTimePicker.minuteInterval = 15
    categoryPicker.dataSource = self
    categoryPicker.delegate = self
    populatePickerData()
    noteTitleField.text = note.title
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert,.sound,.badge],
      completionHandler: { (granted,error) in
        self.isGrantedNotificationAccess = granted
      }
    )
    
    if let image = note.image {
      imageView.image = image
      addGestureRecognizer()
    } else {
      imageView.isHidden = true
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func addGestureRecognizer() {
    gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewImage))
    imageView.addGestureRecognizer(gestureRecognizer)
  }
  
  func viewImage() {
    if let image = imageView.image {
      NoteStore.shared.selectedImage = image
      let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageNavController")
      present(viewController, animated: true, completion: nil)
    }
  }
  
  @IBAction func dateTimeSelection(_ sender: AnyObject) {
    dueDate = dateTimePicker.date
    
  }
  
  fileprivate func showPicker(_ type: UIImagePickerControllerSourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = type
    present(imagePicker, animated: true, completion: nil)
  }
  func populatePickerData() {
    for category in NoteStore.shared.categories {
      pickerData.append(category.name)
      print(pickerData)
      
    }
  }
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    note.title = noteTitleField.text!
    note.dateModified = Date()
    note.image = imageView.image
    note.date = dueDate
    note.isComplete = false
    note.categoryIndex = categoryIndex
    note.categoryName = category
    note.categoryBG = categoryBG
    if isGrantedNotificationAccess{
      //add notification code here
      
      //Set the content of the notification
      let content = UNMutableNotificationContent()
      content.title = category + " has a chore to do"
      content.subtitle = "from Chore To Do"
      content.body = noteTitleField.text!
      let dateformatter = NSCalendar(calendarIdentifier: .gregorian)
      
      var dueDateComponent = DateComponents()
      dueDateComponent.month = (dateformatter?.component(.month, from: dueDate))!
      dueDateComponent.day = (dateformatter?.component(.day, from: dueDate))!
      dueDateComponent.hour = (dateformatter?.component(.hour, from: dueDate))!
      dueDateComponent.minute = (dateformatter?.component(.minute, from: dueDate))!
      print("The due date is")
      print(dueDateComponent)
      //testing
      var mod = DateComponents()
      mod.month = (dateformatter?.component(.month, from: Date()))!
      mod.day = (dateformatter?.component(.day, from: Date()))!
      mod.hour = (dateformatter?.component(.hour, from: Date()))!
      mod.minute = (dateformatter?.component(.minute, from: Date()))!
      print("The current date is")
      print(mod)
      
      let trigger = UNCalendarNotificationTrigger.init(dateMatching: dueDateComponent, repeats: false)
      
      //Set the trigger of the notification -- here a timer.
//      let trigger = UNTimeIntervalNotificationTrigger(
//        timeInterval: 10.0,
//        repeats: false)
//      
      //Set the request for the notification from the above
      let request = UNNotificationRequest(
        identifier: note.title,
        content: content,
        trigger: trigger
      )
      
      //Add the notification to the currnet notification center
      UNUserNotificationCenter.current().add(
        request, withCompletionHandler: nil)
      
    }
    //NoteStore.shared.addNote(note)
    
  }
  
  //MARK: - Delegates and data sources
  //MARK: Data Sources
  func numberOfComponents(in: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return NoteStore.shared.categories.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    category = pickerData[row]
    categoryIndex = row
    categoryBG = NoteStore.shared.categories[row].categoryBG
  }
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let pickerLabel = UILabel()
    let titleData = pickerData[row]
    let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
    pickerLabel.attributedText = myTitle
    //color  and center the label's background
    pickerLabel.backgroundColor = NoteStore.shared.categories[row].categoryBG
    pickerLabel.textAlignment = .center
    return pickerLabel
  }
  
  
  // MARK: - IBActions
  @IBAction func choosePhoto(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Picture", message: "Choose a Picture", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action) in
      self.showPicker(.camera)
    }))
    alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action) in
      self.showPicker(.photoLibrary)
    }))
    present(alert, animated: true, completion: nil)
  }
  @IBAction func saveNote(_ sender: AnyObject) {
  }
  
}

extension ChoreAddDetailVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    
    if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      let maxSize: CGFloat = 512
      //      let scale = maxSize / image.size.width
      //      let newHeight = image.size.height * scale
      //      UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
      //      image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
      //      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      //      UIGraphicsEndImageContext()
      //      if image.size.width < image.size.height {
      let scale = maxSize / image.size.width
      let newHeight = image.size.height * scale
      UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
      image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      //      UIGraphicsEndImageContext()
      //      } else {
      //        let scale = maxSize / image.size.height
      //        let newWidth = image.size.width * scale
      //        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: maxSize))
      //
      //      }
      
      
      imageView.image = resizedImage
      
      imageView.isHidden = false
      if gestureRecognizer != nil {
        imageView.removeGestureRecognizer(gestureRecognizer)
        
      }
      addGestureRecognizer()
    }
  }
}




