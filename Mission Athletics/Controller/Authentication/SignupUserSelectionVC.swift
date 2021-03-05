//
//  SignupUserSelectionVC.swift
//  Mission Athletics
//
//  Created by Mac on 03/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class SignupUserSelectionVC: UIViewController
{
    @IBOutlet weak var ivBackground: UIImageView!
    @IBOutlet weak var vwCoachBg: UIView!
    @IBOutlet weak var vwPlayerBg: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func btnUserSelectionAction(_ sender: UIButton)
    {
        self.changeUI(tag: sender.tag)
        self.btnContinue.isHidden = false
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton)
    {
        var userType = 0
        if self.vwCoachBg.alpha == 0.5 {
            userType = 2
        } else {
            userType = 3
        }
        let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "signupVC") as! signupVC
        nextVC.userType = userType
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK:- Helpers
    func changeUI(tag: Int)
    {
        if tag == 0 {
            self.ivBackground.image = UIImage(named: "Sign_Up_Copy")
            addGradientBackground(view: self.vwCoachBg, gradientColors: [UIColor.blueGradientDark.cgColor, UIColor.blueGradientLight.cgColor], direction: .topBottom)
            self.vwCoachBg.alpha = 0.5
            self.vwCoachBg.layer.borderColor = UIColor.clear.cgColor
            
            self.vwPlayerBg.layer.removeAllGradiantLayers()
            self.vwPlayerBg.alpha = 1
            self.vwPlayerBg.layer.borderColor = UIColor.white.cgColor
        } else {
            self.ivBackground.image = UIImage(named: "Sign_Up_Copy2")
            addGradientBackground(view: self.vwPlayerBg, gradientColors: [UIColor.blueGradientDark.cgColor, UIColor.blueGradientLight.cgColor], direction: .topBottom)
            self.vwPlayerBg.alpha = 0.5
            self.vwPlayerBg.layer.borderColor = UIColor.clear.cgColor
            
            self.vwCoachBg.layer.removeAllGradiantLayers()
            self.vwCoachBg.alpha = 1
            self.vwCoachBg.layer.borderColor = UIColor.white.cgColor
        }
    }
    
}
