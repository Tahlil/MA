//
//  MessegeSenderTextCell.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 18/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit

class MessegeSenderTextCell: UITableViewCell
{
    @IBOutlet weak var lblMessege: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var ivSentReadIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func SetMessageData(_ objData:MessageModel){
        lblMessege.text = objData.message
        
        if let createdStr = objData.created_at {
            if createdStr.contains("T") {
                lblTime.text = checkTForAMPM(time: objData.created_at ?? "")
            } else {
                lblTime.text = checkForAMPM(time: objData.created_at ?? "")
            }
        }
        if let isRead = objData.is_read {
            if isRead == "0" {
                ivSentReadIndicator.image = UIImage(named: "icn_message_received")
            } else {
                ivSentReadIndicator.image = UIImage(named: "icn_message_read")
            }
        }
        selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
