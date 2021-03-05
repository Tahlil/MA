//
//  CoachAllPlayerCell.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 27/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class CoachAllPlayerCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var btnViewProfile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
