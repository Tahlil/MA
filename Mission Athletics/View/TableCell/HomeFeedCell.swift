//
//  HomeFeedCell.swift
//  Mission Athletics
//
//  Created by Mac on 03/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class HomeFeedCell: UITableViewCell
{
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnViewUserProfile: UIButton!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var vwSeenCount: UIView!
    @IBOutlet weak var lblSeenCount: UILabel!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var ivVideoThumb: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnComment: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
