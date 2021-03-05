//
//  FilterCategoriesCell.swift
//  Mission Athletics
//
//  Created by apple on 05/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class FilterCategoriesCell: UICollectionViewCell
{
    @IBOutlet weak var btnCategory: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnCategory.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
