//
//  UpcomingSessionTimeCell.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 17/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit

class UpcomingSessionTimeCell: UITableViewCell {

    @IBOutlet weak var imgGameIcon: UIImageView!
    @IBOutlet weak var lblTopLine: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
