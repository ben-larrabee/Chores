//
//  categoryTableViewCell.swift
//  ChoreToDo
//
//  Created by Ben Larrabee on 10/27/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class categoryTableViewCell: UITableViewCell {
  
  @IBOutlet weak var BGColor: UIView!
  @IBOutlet weak var categoryImage: UIImageView!
  @IBOutlet weak var categoryName: UILabel!
  weak var category: ToDoCategory!
  
  override func awakeFromNib() {
    super.awakeFromNib()
        // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
  }
  
  func setupCell( _ category: ToDoCategory) {
    self.category = category
    categoryName.text = category.name
    categoryImage.image = #imageLiteral(resourceName: "generic")
    BGColor.backgroundColor = category.categoryBG
  }

}
