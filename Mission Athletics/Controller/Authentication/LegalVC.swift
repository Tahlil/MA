//
//  LegalVC.swift
//  Mission Athletics
//
//  Created by Mac on 04/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper

class LegalVC: UIViewController
{
    var setSelectedTab = -1
    
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var vwTermsIndicator: UIView!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var vwPrivacyPolicyIndicator: UIView!
    @IBOutlet weak var txtvwContent: UITextView!

    var terms: TermsPrivacyDetailsDataModel?
    var privacy: TermsPrivacyDetailsDataModel?
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getTermsPrivacyAPICall()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK:- IBACtions
    @IBAction func btnTermsPrivacyAction(_ sender: UIButton)
    {
        self.changeUI(tag: sender.tag)
    }
    
    //MARK:- Helpers
    func changeUI(tag: Int)
    {
        if tag == 0 {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.btnTerms.isSelected = true
                self.vwTermsIndicator.backgroundColor = UIColor.blueGradientDark
                self.btnPrivacyPolicy.isSelected = false
                self.vwPrivacyPolicyIndicator.backgroundColor = UIColor.clear
                self.txtvwContent.attributedText = self.terms?.body?.htmlAttributedString
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.btnTerms.isSelected = false
                self.vwTermsIndicator.backgroundColor = UIColor.clear
                self.btnPrivacyPolicy.isSelected = true
                self.vwPrivacyPolicyIndicator.backgroundColor = UIColor.blueGradientDark
                self.txtvwContent.attributedText = self.privacy?.body?.htmlAttributedString
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //MARK:- API Call
    func getTermsPrivacyAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getTermsPrivacyData)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .get, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<TermsPrivacyResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.terms = data.Terms
                            self.privacy = data.Privacy
                            if self.setSelectedTab == -1 {
                                self.changeUI(tag: 0)
                            } else {
                                self.changeUI(tag: self.setSelectedTab)
                            }
                        }
                        print("success")
                    }else{
                        AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
                    }
                }else{
                    HideProgress()
                }
            }
        }else{
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
}
