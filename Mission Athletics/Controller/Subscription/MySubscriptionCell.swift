//
//  MySubscriptionCell.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 18/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class MySubscriptionCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblNextBillingDate: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var btnCancelSubscription: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSubscriptionDetails(_ objDetails:Mysubscription){
        lblName.text = objDetails.coachName
        
        if objDetails.amount == "0"{
            lblPrice.text = "Free"
            lblDateTitle.text = "Booking date"
            lblNextBillingDate.text = objDetails.bookingDate
        }else{
            lblPrice.text = "$\(objDetails.amount ?? "")"
            lblDateTitle.text = "Due Date"
            lblNextBillingDate.text = objDetails.dueDate
        }
        
        
        if objDetails.bookingStatus == 1{
            lblStatus.text = "Active"
            btnCancelSubscription.isHidden = false
        }else{
            lblStatus.text = "Canceled"
            btnCancelSubscription.isHidden = true
        }
        
        lblDetails.text = objDetails.subscriptionType
        
        if let userImgUrl = URL(string: objDetails.coachImage ?? "") {
            imgProfile.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
        } else {
            imgProfile.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
        }
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        imgProfile.clipsToBounds = true
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
