//
//  categoryTableViewCell.swift
//  ToDoList
//
//  Created by Ehab Osama on 3/2/21.
//  Copyright © 2021 Ehab. All rights reserved.
//

import UIKit
import ChameleonFramework
import SwipeCellKit

class categoryTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var category_label: UILabel!
    @IBOutlet weak var background_view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(Name:String,color : UIColor) {
        background_view.layer.cornerRadius = 20
        category_label.text = Name
        category_label.textColor = ContrastColorOf(color, returnFlat: true)
        background_view.backgroundColor = color
    }
}
