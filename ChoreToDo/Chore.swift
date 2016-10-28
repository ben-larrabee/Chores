//
//  Chore.swift
//  ChoreToDo
//
//  Created by Ben Larrabee on 10/28/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit
class Chore: NSObject, NSCoding {
  var title: String
  var dateDue: Date = Date()
  var dateModified: Date = Date()
  var isComplete: Bool = false
  var index: Int
  var image: UIImage?
  var category: String = "Unclaimed"
  var background: UIColor
  
  var dateDueString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: dateDue)
  }
  var dateModifiedString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: dateModified)
  }
  
  let titleKey = "title"
  let textKey = "text"
  let dateDueKey = "dateDue"
  let imageKey = "image"
  let dateModifiedKey = "dateModified"
  let isCompleteKey = "isComplete"
  let indexKey = "index"
  let categoryKey = "category"
  let backgroundKey = "background"
  
  override init() {
    self.title = ""
    self.index = 0
    self.background = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    super.init()
  }
  
  init(allDetail title: String, dateDue: Date, index: Int, category: String, background: UIColor) {
    self.title = title
    self.dateDue = dateDue
    self.index = index
    self.category = category
    self.background = background
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.title = aDecoder.decodeObject(forKey: titleKey) as! String
    self.dateDue = aDecoder.decodeObject(forKey: dateDueKey) as! Date
    self.image = aDecoder.decodeObject(forKey: imageKey) as? UIImage
    self.dateModified = aDecoder.decodeObject(forKey: dateModifiedKey) as! Date
    self.isComplete = aDecoder.decodeBool(forKey: isCompleteKey)
    self.index = aDecoder.decodeInteger(forKey: indexKey)
    self.category = aDecoder.decodeObject(forKey: categoryKey) as! String
    self.background = aDecoder.decodeObject(forKey: backgroundKey) as! UIColor
  }
    
  func encode(with aCoder: NSCoder) {
    aCoder.encode(title, forKey: titleKey)
    aCoder.encode(dateDue, forKey: dateDueKey)
    aCoder.encode(image, forKey: imageKey)
    aCoder.encode(dateModified, forKey: dateModifiedKey)
    aCoder.encode(isComplete, forKey: isCompleteKey)
    aCoder.encode(index, forKey: indexKey)
    aCoder.encode(category, forKey: categoryKey)
    aCoder.encode(background, forKey: backgroundKey)
  }
  
}
