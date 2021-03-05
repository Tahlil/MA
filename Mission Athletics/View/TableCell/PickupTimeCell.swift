//
//  PickupTimeCell.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 16/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit

class PickupTimeCell: UITableViewCell
{
    @IBOutlet weak var vwTimeView: UIView!
    @IBOutlet weak var vwConfirm: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
