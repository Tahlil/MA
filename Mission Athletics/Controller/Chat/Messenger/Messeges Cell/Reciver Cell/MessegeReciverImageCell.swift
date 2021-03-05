//
//  MessegeReciverImageCell.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 19/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit

class MessegeReciverImageCell: UITableViewCell
{
    @IBOutlet weak var imgReciever: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnImgPreview: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func SetMessageData(_ objData:MessageModel){
        if let imgUrl = URL(string: objData.attachment_path!) {
            imgReciever.sd_cancelCurrentImageLoad()

            imgReciever.sd_setImage(with: imgUrl, placeholderImage: UIImage(), options: .refreshCached, completed: { (image, error, cacheType, url) in
                self.imgReciever.image = image

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
        

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
