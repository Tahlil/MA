//
//  FriendsListCell.swift
//  Mission Athletics
//
//  Created by Mac on 11/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class FriendsListCell: UITableViewCell
{
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnViewProfile: MyButton!
    @IBOutlet weak var btnFollowing: MyButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
