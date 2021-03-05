//
//  TermsPrivacyVC.swift
//  Mission Athletics
//
//  Created by Mac on 04/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class TermsPrivacyVC: UIViewController
{
    var currentTab = 0

    var termsContent = ""
    var privacyContent = ""
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.setTermsPrivacy(notification:)), name: Notification.Name("setTermsPrivacy"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    //MARK:- objc methods
    @objc func setTermsPrivacy(notification: Notification)
    {
        if let obj = notification.object as? Int {
            if obj == 0 {
                
            } else {
                
            }
        }
    }
}
