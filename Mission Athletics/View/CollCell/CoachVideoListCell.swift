//
//  CoachVideoListCell.swift
//  Mission Athletics
//
//  Created by MAC  on 17/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class CoachVideoListCell: UICollectionViewCell
{
    @IBOutlet weak var ivVideoThumb: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblCoachName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    
    func setCoachVideoData(_ objDetails:ViewVideosArrModel){
        
        lblVideoTitle.text = objDetails.title
        lblCoachName.text = objDetails.username
        if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
            ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
        }
    }
}
