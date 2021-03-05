//
//  MessegeSenderImageCell.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 19/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit

class MessegeSenderImageCell: UITableViewCell
{
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgSenderImage: UIImageView!
    @IBOutlet weak var ivSentReadIndicator: UIImageView!
    @IBOutlet weak var btnImgPreview: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func SetMessageData(_ objData:MessageModel){
        if let imgUrl = URL(string: objData.attachment_path!) {
            imgSenderImage.sd_cancelCurrentImageLoad()
            imgSenderImage.sd_setImage(with: imgUrl, placeholderImage: UIImage(), options: .refreshCached, completed: { (image, error, cacheType, url) in
                self.imgSenderImage.image = image
                if error != nil {
                    print(error!.localizedDescription)
                }
            })
        }
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

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
