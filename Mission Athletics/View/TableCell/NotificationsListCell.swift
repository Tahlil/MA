//
//  NotificationsListCell.swift
//  Mission Athletics
//
//  Created by apple on 11/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class NotificationsListCell: UITableViewCell
{
    @IBOutlet weak var contentVw: UIView!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.contentVw.layer.masksToBounds = true
//        self.contentVw.clipsToBounds = false
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.contentVw.dropShadow(color: UIColor.darkGray, opacity: 0.1, offSet: CGSize(width: 3, height: 0), radius: 8, scale: true)//.addShadow(offset: CGSize(width: 3, height: 0), color: UIColor.darkGray, radius: 8, opacity: 0.1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
