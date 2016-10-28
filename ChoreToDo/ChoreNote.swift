//
//  Note.swift
//  Notes
//
//  Created by Ben Larrabee on 10/18/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class Note: NSObject, NSCoding{
  var title = ""
  var text = ""
  var date = Date()
  var image: UIImage?
  var dateModified = Date()
  var isComplete = false
  var priority: Float = 500
  var categoryIndex = 0
  var categoryName = "Unclaimed"
  var categoryImage: UIImage? = #imageLiteral(resourceName: "generic")
  var categoryBG: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
  
  let titleKey = "title"
  let textKey = "text"
  let dateKey = "date"
  let imageKey = "image"
  let dateModifiedKey = "dateModified"
  let isCompleteKey = "isComplete"
  let priorityKey = "priority"
  let categoryIndexKey = "categoryIndex"
  let categoryNameKey = "categoryName"
  let categoryImageKey = "categoryImage"
  let categoryBGKey = "categoryBG"
  
  var dateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: date)
  }
  
  override init(){
    super.init()
  }
  
  init(title: String, text: String) {
    self.title = title
    self.text = text
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.title = aDecoder.decodeObject(forKey: titleKey) as! String
    self.text = aDecoder.decodeObject(forKey: textKey) as! String
    self.date = aDecoder.decodeObject(forKey: dateKey) as! Date
    self.image = aDecoder.decodeObject(forKey: imageKey) as? UIImage
    self.dateModified = aDecoder.decodeObject(forKey: dateModifiedKey) as! Date
    self.isComplete = aDecoder.decodeBool(forKey: isCompleteKey)
    self.priority = aDecoder.decodeFloat (forKey: priorityKey)
    self.categoryIndex = aDecoder.decodeInteger(forKey: categoryIndexKey)
    self.categoryName = aDecoder.decodeObject(forKey: categoryNameKey) as! String
    self.categoryImage = aDecoder.decodeObject(forKey: categoryImageKey) as? UIImage
    self.categoryBG = aDecoder.decodeObject(forKey: categoryBGKey) as! UIColor
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(title, forKey: titleKey)
    aCoder.encode(text, forKey: textKey)
    aCoder.encode(date, forKey: dateKey)
    aCoder.encode(image, forKey: imageKey)
    aCoder.encode(dateModified, forKey: dateModifiedKey)
    aCoder.encode(isComplete, forKey: isCompleteKey)
    aCoder.encode(priority, forKey: priorityKey)
    aCoder.encode(categoryIndex, forKey: categoryIndexKey)
    aCoder.encode(categoryName, forKey: categoryNameKey)
    aCoder.encode(categoryImage, forKey: categoryImageKey)
    aCoder.encode(categoryBG, forKey: categoryBGKey)
    
    
    
  }
  
}
