//
//  MessegeReciverFileCell.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 30/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class MessegeReciverFileCell: UITableViewCell
{
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnViewDocument: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func SetMessageData(_ objData:MessageModel){
        lblFileName.text = objData.message?.removingPercentEncoding
        
        if let createdStr = objData.created_at {
            if createdStr.contains("T") {
                lblTime.text = checkTForAMPM(time: objData.created_at ?? "")
            } else {
                lblTime.text = checkForAMPM(time: objData.created_at ?? "")
            }
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
