//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Ben Larrabee on 10/18/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
  @IBOutlet weak var categoryBG: UIView!
  @IBOutlet weak var categoryImage: UIImageView!
  @IBOutlet weak var categoryName: UILabel!
  @IBOutlet weak var noteStatus: UIImageView!

  @IBOutlet weak var noteTitleLabel: UILabel!
  @IBOutlet weak var noteDateLabel: UILabel!

  
  weak var note: Note!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setupCell( _ note: Note) {
    self.note = note
    noteTitleLabel.text = note.title

    noteDateLabel.text = note.dateString

    categoryBG.backgroundColor = note.categoryBG
    categoryName.text = note.categoryName
    categoryImage.image = note.categoryImage
    noteStatus.image = note.isComplete ? #imageLiteral(resourceName: "checkeditem") : #imageLiteral(resourceName: "uncheckeditem")
  }
  
}
