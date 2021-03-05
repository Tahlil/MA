//
//  CompareVideoCell.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 23/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class CompareVideoCell: UITableViewCell {

    @IBOutlet weak var imgAthleteVideo: UIImageView!
    @IBOutlet weak var imgAthleteProfile: UIImageView!
    @IBOutlet weak var lblAthleteName: UILabel!
    @IBOutlet weak var btnPlayAthleteVideo: UIButton!
    
    @IBOutlet weak var imgCoachVideo: UIImageView!
    @IBOutlet weak var btnPlayCoachVideo: UIButton!
    @IBOutlet weak var imgCoachProfile: UIImageView!
    @IBOutlet weak var lblCoachName: UILabel!
    @IBOutlet weak var btnCompareStatus: UIButton!
    @IBOutlet weak var btnCompareReport: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCompareVideoDeails(_ objDetails:VideoDataComparisionModel){
        lblAthleteName.text = objDetails.athleteName
        lblCoachName.text = objDetails.coachName
        
        if let userAthleteImgUrl = URL(string: objDetails.athleteImage ?? "") {
            imgAthleteProfile.sd_setImage(with: userAthleteImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
        } else {
            imgAthleteProfile.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
        }
        
        if let userCoachImgUrl = URL(string: objDetails.coachImage ?? "") {
            imgCoachProfile.sd_setImage(with: userCoachImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
        } else {
            imgCoachProfile.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
        }
        
        if let VideoCoachImgUrl = URL(string: objDetails.coachVideoThumbnailImage ?? "") {
            imgCoachVideo.sd_setImage(with: VideoCoachImgUrl, placeholderImage: UIImage(named: "noImageHome"), options: .refreshCached, completed: nil)
        } else {
            imgCoachVideo.image = UIImage(named: "")
        }
        if let VideoAthleteImgUrl = URL(string: objDetails.athleteVideoThumbnailImage ?? "") {
            imgAthleteVideo.sd_setImage(with: VideoAthleteImgUrl, placeholderImage: UIImage(named: "noImageHome"), options: .refreshCached, completed: nil)
        } else {
            imgAthleteVideo.image = UIImage(named: "")
        }
        //status 1=Pending, 2=Accept, 3= Reject
        let strStatus = objDetails.status
        if strStatus == 1{
            btnCompareStatus.setTitle("Pending", for: .normal)
            btnCompareStatus.backgroundColor = UIColor.init(hexString: "#FFBF30")
        }else if strStatus == 2{
            btnCompareStatus.setTitle("accpeted", for: .normal)
            btnCompareStatus.backgroundColor = UIColor.init(hexString: "#2B7C22")
        }else if strStatus == 3{
            btnCompareStatus.setTitle("Rejected", for: .normal)
            btnCompareStatus.backgroundColor = UIColor.red
        }else if strStatus == 4{
            btnCompareStatus.setTitle("In progress", for: .normal)
            btnCompareStatus.backgroundColor = UIColor.init(hexString: "#FE7C96")
        }else{
            btnCompareStatus.setTitle("Report Failed", for: .normal)
            btnCompareStatus.backgroundColor = UIColor.init(hexString: "#FB2F0C")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
