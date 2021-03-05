//
//  SideMenuVC.swift
//  Mission Athletics
//
//  Created by MAC  on 18/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage
import FBSDKLoginKit
import Alamofire

class SideMenuVC: UIViewController
{
    @IBOutlet weak var vwSettings: UIView!
    @IBOutlet weak var vwSettingsBG: UIView!
    @IBOutlet weak var vwSettingsBGSideLayer: UIView!
    @IBOutlet weak var ivUserSideMenu: UIImageView!
    @IBOutlet weak var lblUserNameSideMenu: UILabel!
    @IBOutlet weak var lblUserTeamSideMenu: UILabel!
    @IBOutlet weak var vwCompareVideo: UIView!
    @IBOutlet weak var vwPayment: UIView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblCompareVideo: UILabel!
    @IBOutlet weak var lblMySubscription: UILabel!
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProfileAPICall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.tapHandle(gesture:)))
        self.view.removeGestureRecognizer(tapGesture)
        self.vwSettingsBGSideLayer.addGestureRecognizer(tapGesture)
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//Coach
                lblPayment.text = "Payment"
                lblCompareVideo.text = "Set Unavailability"
                lblMySubscription.text = "Upcoming session"
            }else{
                lblPayment.text = "Upcoming session"
            }
        }
    }
    
    //MARK:- objc methods
    @objc func tapHandle(gesture: UITapGestureRecognizer)
    {
        if gesture.view == self.vwSettingsBGSideLayer {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false, completion: {
                NotificationCenter.default.post(name: Notification.Name("statusBarAppearanceWhenComeBack"), object: nil)
            })
        }
    }
    
    //MARK:- IBActions
    @IBAction func btnEditProfileMenuAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "EditCoachProfileVC") as! EditCoachProfileVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnSettingsMenuAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnMySubscriptions(_ sender: UIButton) {
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//Coach
                let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "UpcomingSessionVC") as! UpcomingSessionVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "MySubscriptionVC") as! MySubscriptionVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    @IBAction func btnPayment(_ sender: UIButton) {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//Coach
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "UpcomingSessionVC") as! UpcomingSessionVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    
    @IBAction func btnCompareVideoRequest(_ sender: UIButton) {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//Coach
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "ScheduleSessionVC") as! ScheduleSessionVC
                nextVC.isFromView = "Coach"
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CompareVideoRequestVC") as! CompareVideoRequestVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
       
    }
    
    
    @IBAction func btnSupportMenuAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnLegalMenuAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "LegalVC") as! LegalVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnLogoutAction(_ sender: UIButton)
    {
        self.showAlertForlogout()
    }
    
    //MARK:- Helper
    func showAlertForlogout()
    {
        let alert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.logoutAPICall()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- API Call -
    func getProfileAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getProfile)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<GetProfileResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            if data.profile_pic != nil {
                                if let imgUrl = URL(string: data.profile_pic!) {
                                    self.ivUserSideMenu.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "User_Placeholder_ChatList"), options: .refreshCached, completed: { (image, error, cacheType, url) in
                                        if error != nil {
                                            print(error!.localizedDescription)
                                        }
                                    })
                                } else {
                                    self.ivUserSideMenu.image = UIImage(named: "User_Placeholder_ChatList")
                                }
                            } else {
                                self.ivUserSideMenu.image = UIImage(named: "User_Placeholder_ChatList")
                            }
                            self.lblUserNameSideMenu.text = data.name ?? ""
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
    
    //MARK: LOGOUT API Call
    func logoutAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.logout)
            print(url)
            
            var reqParams:[String:Any] = [:]
            if let fcmDeviceToken = UserDefaults.standard.value(forKey: UserDefaultsKey.FCM_TOKEN) {
                reqParams["device_token"] = String(describing: fcmDeviceToken)
            }else{
                reqParams["device_token"] = "123"
            }

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CommonResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        self.logoutApiCallSuccessAction()
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
    
    func logoutApiCallSuccessAction()
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false) {
            if GlobalConstants.appDelegate.isSocialLogin {// FB Login
                LoginManager().logOut()
            }
            removeUserInfo(key: UserDefaultsKey.user)
            GlobalConstants.appDelegate.setRootViewController()
        }
    }
}
