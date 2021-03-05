//
//  ReviewCell.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 05/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var vwRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setReviewDetatils(_ objDetails:ReviewDataModel){
        lblName.text = objDetails.athleteName
        lblReview.text = objDetails.review
        if let videoThumbUrl = URL(string: objDetails.athleteImage ?? "") {
            imgProfile.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
        }
        vwRating.rating = Double(objDetails.rate ?? "0.0") ?? 0.0
        vwRating.text = objDetails.rate
        selectionStyle = .none

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
