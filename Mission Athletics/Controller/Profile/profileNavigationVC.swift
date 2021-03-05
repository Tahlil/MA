//
//  profileNavigationVC.swift
//  Mission Athletics
//
//  Created by MAC  on 23/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class profileNavigationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if getUserInfo() != nil
        {
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//userType == 2 {
                    let coachVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                    self.navigationController?.pushViewController(coachVC, animated: false)
                } else if userData.user_type == 3 { //userType == 3 {
                    let athleteVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
                    self.navigationController?.pushViewController(athleteVC, animated: false)
                }
            }
        }
    }
}
