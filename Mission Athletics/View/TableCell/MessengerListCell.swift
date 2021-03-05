//
//  MessengerListCell.swift
//  Mission Athletics
//
//  Created by apple on 09/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class MessengerListCell: UITableViewCell
{
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var vwOnlineIndicator: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var vwUnreadCount: UIView!
    @IBOutlet weak var lblUnreadCount: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblLastMsgTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwUnreadCount.layer.cornerRadius = self.vwUnreadCount.bounds.height / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
