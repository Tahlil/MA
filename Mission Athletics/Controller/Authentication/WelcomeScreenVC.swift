//
//  WelcomeScreenVC.swift
//  Mission Athletics
//
//  Created by Mac on 03/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class WelcomeScreenVC: UIViewController
{
    let objViewModel = WelcomeScreenVM()

    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        objViewModel.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalConstants.appDelegate.isPasswordChange == true {
            let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    // MARK: - IBActions
    @IBAction func btnSignupAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "SignupUserSelectionVC") as! SignupUserSelectionVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnSignInAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
