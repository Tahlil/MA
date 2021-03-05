//
//  BookingMonthlySessionVC.swift
//  Mission Athletics
//
//  Created by MAC  on 13/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class BookingMonthlySessionVC: UIViewController
{
    @IBOutlet weak var vwScheduleSessionsBG: UIView!
    @IBOutlet weak var btnScheduleSessions: UIButton!
    @IBOutlet weak var btnScheduleLater: UIButton!

    var reqSessionParam:[String:Any] = [:]
    
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.vwScheduleSessionsBG.layer.removeAllGradiantLayers()
        addGradiantLayer(gradientView: vwScheduleSessionsBG)
        //        addGradientBackground(view: self.vwScheduleSessionsBG, gradientColors: [UIColor.white.cgColor, UIColor.clear.cgColor], direction: .bottomTop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    

    
    //MARK:- IBActions
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnScheduleActions(_ sender: UIButton)
    {
        if sender.tag == 0 {//Schedule Sessions
            UIView.animate(withDuration: 0.4, animations: {() -> Void in
                self.btnScheduleSessions.isSelected = true
                self.btnScheduleSessions.backgroundColor = UIColor.blueGradientDark
                self.btnScheduleLater.isSelected = false
                self.btnScheduleLater.backgroundColor = UIColor.white
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "ScheduleSessionVC") as! ScheduleSessionVC
                nextVC.reqSessionParam = self.reqSessionParam
                self.navigationController?.pushViewController(nextVC, animated: true)

            })
        } else {//Schedule Later
            UIView.animate(withDuration: 0.4, animations: {() -> Void in
                self.btnScheduleSessions.isSelected = false
                self.btnScheduleSessions.backgroundColor = UIColor.white
                self.btnScheduleLater.isSelected = true
                self.btnScheduleLater.backgroundColor = UIColor.blueGradientDark
            })
        }
    }
}
