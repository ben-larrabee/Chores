//
//  Categories.swift
//  Notes
//
//  Created by Ben Larrabee on 10/25/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class ToDoCategory: NSObject, NSCoding{
  var name: String = ""
  var image: UIImage? = #imageLiteral(resourceName: "generic")
  var categoryBG: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
  
  let nameKey = "name"
  let imageKey = "image"
  let categoryBGKey = "categoryBG"
  
  override init(){
    super.init()
  }
  
  init(name: String, color: UIColor) {
    print("begin instantiation of category")
    self.name = name
    self.categoryBG = color
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: nameKey) as! String
    self.image = aDecoder.decodeObject(forKey: imageKey) as? UIImage
    self.categoryBG = aDecoder.decodeObject(forKey: categoryBGKey) as! UIColor
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: nameKey)
    aCoder.encode(image, forKey: imageKey)
    aCoder.encode(categoryBG, forKey: categoryBGKey)
  }
  
}

