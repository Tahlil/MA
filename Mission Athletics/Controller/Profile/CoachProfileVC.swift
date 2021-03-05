//
//  CoachProfileVC.swift
//  Mission Athletics
//
//  Created by apple on 09/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Alamofire
import ObjectMapper
import StoreKit
import UIKit
import AVFoundation
import AVKit

class CoachProfileVC: UIViewController
{
    var chatId = -1
    var userId = -1
    var isFromOtherUser = false
    var isFromAthlete = false
    var isRequest = false
    var subscriptionInfo: AthleteSubscribeVideoModel?
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var ivUserCover: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblVideosCount: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var lblFriendsCount: UILabel!
    @IBOutlet weak var collVideoPost: UICollectionView!
    
    @IBOutlet weak var vwReqAcceptRejectHeight: NSLayoutConstraint!
    @IBOutlet weak var vwReqAcceptReject: UIView!
    
    //Subscribe popup
    @IBOutlet weak var vwSubscribeOptions: UIView!
    @IBOutlet weak var vwSettings: UIView!
    @IBOutlet weak var vwSettingsBG: UIView!
    @IBOutlet weak var vwSettingsBGSideLayer: UIView!
    @IBOutlet weak var vwSettingsWidth: NSLayoutConstraint!
    @IBOutlet weak var vwSettingsTrailing: NSLayoutConstraint!
    @IBOutlet weak var ivUserSideMenu: UIImageView!
    @IBOutlet weak var lblUserNameSideMenu: UILabel!
    @IBOutlet weak var lblUserTeamSideMenu: UILabel!
    @IBOutlet weak var btnSubscribeVideo: UIButton!
    @IBOutlet weak var btnSubscribeSession: UIButton!
    @IBOutlet weak var vwRatingReview: CosmosView!
    @IBOutlet weak var btnWriteReviewHeight: NSLayoutConstraint!
    
    var arrCoachVideo = [ViewVideosArrModel]()
    var isSubscribeForSession = 0
    var isTotalFreeSession = 0
    var isSubscribeForVideo = 0
    var freeVideosRemaining = 0
    var totalSubscribedSessionCount = 0

    //MARK:- Viewlifecycle methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwSubscribeOptions.alpha = 0.0
        self.setNavigationButtons()
                
        self.vwSettingsWidth.constant = UIScreen.main.bounds.width//0
        self.vwSettingsTrailing.constant = -UIScreen.main.bounds.width
        self.vwSettingsBG.isHidden = true
        
        self.collVideoPost.register(UINib.init(nibName: "VideoPostCell", bundle: nil), forCellWithReuseIdentifier: "VideoPostCell")
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.tapHandle(gesture:)))
        self.vwSettingsBGSideLayer.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusBarAppearanceWhenComeBack(notification:)), name: Notification.Name("statusBarAppearanceWhenComeBack"), object: nil)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.TapViewReview(_:)))
        vwRatingReview.addGestureRecognizer(tap)

    }
    @objc func TapViewReview(_ sender: UITapGestureRecognizer? = nil) {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        nextVC.userId = self.userId
        nextVC.isViewFrom = "coachProfile"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                btnWriteReviewHeight.constant = 0
                if self.isFromAthlete || self.isFromOtherUser{
                    self.tabBarController?.tabBar.isHidden = true
                }else{
                    self.tabBarController?.tabBar.isHidden = false
                }
            }else{
                btnWriteReviewHeight.constant = 30
            }
        }

        if self.isFromOtherUser {
            self.tabBarController?.tabBar.isHidden = true
            
            if self.isRequest {
                self.vwReqAcceptRejectHeight.constant = 78
                self.vwReqAcceptReject.alpha = 1.0
            } else {
                self.vwReqAcceptRejectHeight.constant = 0
                self.vwReqAcceptReject.alpha = 0.0
            }
        } else {
            self.vwReqAcceptRejectHeight.constant = 0
            self.vwReqAcceptReject.alpha = 0.0
        }
        
        self.getProfileAPICall()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                self.tabBarController?.tabBar.isHidden = false
            }else{
                self.tabBarController?.tabBar.isHidden = false
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- objc methods -
    @objc func tapHandle(gesture: UITapGestureRecognizer)
    {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.vwSettingsTrailing.constant = -UIScreen.main.bounds.width
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func statusBarAppearanceWhenComeBack(notification: Notification)
    {
        self.setNeedsStatusBarAppearanceUpdate()
        self.getProfileAPICall()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                self.btnSettingsAction(UIButton())
                break
            default:
                break
            }
        }
    }
    
    //MARK:- Helpers -
    func setNavigationButtons()
    {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if self.isFromAthlete || self.isFromOtherUser{
                    self.btnBack.isHidden = false
                    self.btnCalendar.isHidden = true
                    self.btnSettings.isHidden = false
                }else{
                    self.btnBack.isHidden = true
                    self.btnCalendar.isHidden = true
                    self.btnSettings.isHidden = false
                }
            }else{//Athlete
                if self.isFromAthlete || self.isFromOtherUser{
                    self.btnBack.isHidden = false
                    self.btnCalendar.isHidden = false
                    self.btnSettings.isHidden = true
                }else{
                    self.btnBack.isHidden = true
                    self.btnCalendar.isHidden = true
                    self.btnSettings.isHidden = false
                }
            }
        }
    }
    
    //MARK:- IBActions -
    
    @IBAction func btnWriteReview(_ sender: UIButton) {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "RatingReviewPopupVC") as! RatingReviewPopupVC
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.coach_id = userId
        self.present(nextVC, animated: false) {
            
        }
    }
    
    @IBAction func btnCalendarAction(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.vwSubscribeOptions.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func closeSubscribePopupAction(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.vwSubscribeOptions.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnSettingsAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        let navVC = UINavigationController(rootViewController: nextVC)
        navVC.setNavigationBarHidden(true, animated: false)
        navVC.modalPresentationStyle = .overCurrentContext
        navVC.view.backgroundColor = UIColor.clear
        self.tabBarController?.present(navVC, animated: false, completion: nil)
    }
    
    @IBAction func btnAcceptRejectAction(_ sender: UIButton)
    {
        if sender.tag == 0 {//Accept
            self.AcceptRejectRequestAPICall(reqStatus: ChatRequest.Accept.rawValue, chatId: "\(chatId)")
        } else {
            self.AcceptRejectRequestAPICall(reqStatus: ChatRequest.Reject.rawValue, chatId: "\(chatId)")
        }
    }
    
    @IBAction func btnSeeAllAction(_ sender: UIButton)
    {
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachesVideoListVC") as! CoachesVideoListVC

                if isFromOtherUser{
                    nextVC.userId = self.userId
                    nextVC.isFromViewController = "notification"
                }else{
                    nextVC.userId = userData.id ?? -1
                    nextVC.isFromViewController = "coach_profile"
                }
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            } else { //Athlete
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachesVideoListVC") as! CoachesVideoListVC
                nextVC.userId = self.userId
                nextVC.isFromViewController = ""
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    //MARK: Subscribe popup actions
    @IBAction func btnSubscribeForVideoAction(_ sender: UIButton)
    {
        CheckDetailfunc(strBookType: "Video")
    }
    
    @IBAction func btnSubscribeForSessionAction(_ sender: UIButton)
    {
        CheckDetailfunc(strBookType: "Session")
    }
    
    //Sidemenu actions
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
    
    @IBAction func btnAllVideos(_ sender: UIButton) {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachesVideoListVC") as! CoachesVideoListVC

                if isFromOtherUser{
                    nextVC.userId = self.userId
                    nextVC.isFromViewController = "notification"
                }else{
                    nextVC.userId = userData.id ?? -1
                    nextVC.isFromViewController = "coach_profile"
                }
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            } else { //Athlete
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachesVideoListVC") as! CoachesVideoListVC
                nextVC.userId = self.userId
                nextVC.isFromViewController = ""
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    @IBAction func btnAllSubscribers(_ sender: UIButton) {
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "CoachAllPlayerVC") as! CoachAllPlayerVC
        nextVC.isFromView = "coachProfile_athlLogin"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func btnAllFriends(_ sender: UIButton) {
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "FriendsListVC") as! FriendsListVC
        nextVC.isViewFrom = "CoachProfile"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func setUserDetails(){
        if self.isSubscribeForSession == 1{
            btnWriteReviewHeight.constant = 30
            self.btnSubscribeSession.setTitle("Book Session", for: .normal)
        }else{
            btnWriteReviewHeight.constant = 0
            if isTotalFreeSession == 0{
                self.btnSubscribeSession.setTitle("Subscribe for Session", for: .normal)
            }else{
                self.btnSubscribeSession.setTitle("Free Session", for: .normal)
            }
        }
        if self.isSubscribeForVideo == 1{
            btnWriteReviewHeight.constant = 30
            self.btnSubscribeVideo.setTitle("Already Subscribed", for: .normal)
        }else{
            btnWriteReviewHeight.constant = 0
            self.btnSubscribeVideo.setTitle("Subscribe to Coach", for: .normal)
        }
    }
    
    func CheckDetailfunc(strBookType:String){
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd"
        dtFormatter.timeZone = .current
        let dtStr = dtFormatter.string(from: Date())
        
        if strBookType == "Video"{
            CheckBankDetailAPICall(strBookType: "Video")
        }else{
            if isTotalFreeSession != 0{
                
                var reqParam:[String:Any] = [:]
                reqParam["coach_id"] = "\(self.userId)"
                reqParam["subscription_id"] = "2"
                reqParam["date"] = dtStr
                
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "ScheduleSessionVC") as! ScheduleSessionVC
                nextVC.reqSessionParam = reqParam
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                if isSubscribeForSession == 1{
                
                    if totalSubscribedSessionCount != 0{
                        var reqParam:[String:Any] = [:]
                        reqParam["coach_id"] = "\(self.userId)"
                        reqParam["subscription_id"] = isTotalFreeSession == 0 ? "3" : "2"
                        reqParam["date"] = dtStr
                        
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "ScheduleSessionVC") as! ScheduleSessionVC
                        nextVC.reqSessionParam = reqParam
                        self.navigationController?.pushViewController(nextVC, animated: true)

                    }else{
                        AlertView.showMessageAlert("Your subscription limit is over wait for next subscription cycle.", viewcontroller: self)
                    }
                }else{
                    CheckBankDetailAPICall(strBookType: "Session")
                }
            }
        }
    }
    
    //MARK:- API Call -
    func getProfileAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getProfile)
            print(url)
            
            var reqParam:[String:Any] = [:]
            if self.isFromOtherUser {
                reqParam["user_id"] = self.userId
            }
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: self.isFromOtherUser == true ? reqParam : [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<GetProfileResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            if let imgUrl = URL(string: data.image ?? "") {
                                self.ivUser.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "User_Placeholder_ChatList"), options: .refreshCached, completed: { (image, error, cacheType, url) in
                                    if error != nil {
                                        print(error!.localizedDescription)
                                    }
                                })
                                
                                self.ivUserCover.setBlurImgeView()
                                self.ivUserCover.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "img-not-found-350x195"), options: .refreshCached, completed: { (image, error, cacheType, url) in
                                    if error != nil {
                                        print(error!.localizedDescription)
                                    }
                                })

                            } else {
                                self.ivUser.image = UIImage(named: "User_Placeholder_ChatList")
                            }
                            self.userId = data.id ?? -1
                            self.arrCoachVideo = data.videoData ?? []
                            self.collVideoPost.reloadData()
                            self.lblUserName.text = data.name ?? ""
                            self.lblBio.text = data.description ?? ""
                            self.lblVideosCount.text = "\(data.total_videos ?? 0)"
                            self.lblFriendsCount.text = "\(data.totalFriends ?? 0)"
                            self.lblFollowersCount.text = "\(data.total_subscribers ?? 0)"
                            self.vwRatingReview.rating = data.rate ?? 0.0
                            self.vwRatingReview.text = "\(data.rate ?? 0.0) (\(data.review ?? 0) Reviews)"
                            self.isSubscribeForSession = data.subscribe_session ?? 0
                            self.isSubscribeForVideo = data.subscribe_video ?? 0
                            self.isTotalFreeSession = data.free_session ?? 0
                            self.setUserDetails()
                            self.freeVideosRemaining = data.free_videos ?? 0
                            self.totalSubscribedSessionCount = data.booked_subscribe_session ?? 0
                            self.collVideoPost.restoreEmptyMessage()
                            if self.arrCoachVideo.count == 0{
                                self.collVideoPost.setEmptyMessage("Training video not found.")
                                self.collVideoPost.reloadData()
                            }
                            
//                            self.lblContact.text = data.mobile_no ?? ""
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
    
    //MARK: Accept Reject API Call
    func AcceptRejectRequestAPICall(reqStatus: String, chatId: String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.acceptReject)
            print(url)
            
            var param:Parameters = ["request_status":reqStatus]
            param["chat_id"] = chatId
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<FriendListModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
//                        self.vwPersonalInfoHeight.constant = 210
                        self.vwReqAcceptRejectHeight.constant = 0
                        self.vwReqAcceptReject.alpha = 0.0
                        
                        NotificationCenter.default.post(name: Notification.Name("makeNotificationSeen"), object: nil)
                        AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
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
    
    //MARK: Check Bank Detail API Call
    func CreateCardTokenAPICall(objcBankDetails:CoachBankDetailsModel?,strBookType:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.generateCardToken
            print(url)
            
            let strDate = objcBankDetails?.expiry_date?.string
            let strFullDate = strDate?.components(separatedBy: "/")

            let strCardExpMonth = strFullDate?[0]
            let strExpYear = strFullDate?[1]
            
            
            var reqParam:[String:Any] = [:]
            if self.isFromOtherUser {
                reqParam["card[number]"] = objcBankDetails?.card_number
                reqParam["card[exp_month]"] = strCardExpMonth
                reqParam["card[exp_year]"] = strExpYear
                reqParam["card[cvc]"] = objcBankDetails?.cvv
            }
            
            ServiceRequestResponse.servicecallStripeWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: self.isFromOtherUser == true ? reqParam : [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    if result?.contains("error") ?? false{
                        let mapData  = Mapper<TokenDetailsErorModel>().map(JSONString: result!)
                           
                        AlertView.showMessageAlert(mapData?.error?.message ?? "Something went wrong", viewcontroller: self)
                        
                    }else{
                        let mapData  = Mapper<TokenDetailsModel>().map(JSONString: result!)
                        
                        let strToken = mapData?.id ?? ""
                        
                        let subscribeId = "1"
                        let amount = self.subscriptionInfo?.amount ?? ""
                        let tax = self.subscriptionInfo?.tax ?? ""
                        let val = self.subscriptionInfo?.validity ?? 0
                        let taxAmount = (Double(amount) ?? 0)*((Double(tax) ?? 0)/100)
                        let total = (Double(amount) ?? 0) + taxAmount
                        let strBankDeailID = objcBankDetails?.id ?? -1
                        
                        let dtFormatter = DateFormatter()
                        dtFormatter.dateFormat = "yyyy-MM-dd"
                        dtFormatter.timeZone = .current
                        let dtStr = dtFormatter.string(from: Date())

                        if strBookType == "Video"{
                            self.SubscribeVideosAPICall(subscriptionId: subscribeId, amount: amount, tax: tax, validity: "\(val)", total: "\(total)", date: dtStr, bank_detail_ID: "\(strBankDeailID)", strCardToken: strToken)

                        }else{
                            var reqParam:[String:Any] = [:]
                            reqParam["coach_id"] = "\(self.userId)"
                            reqParam["subscription_id"] = "3"
                            reqParam["amount"] = amount
                            reqParam["tax"] = tax
                            reqParam["validity"] = "\(val)"
                            reqParam["total"] = total
                            reqParam["date"] = dtStr
                            reqParam["bank_detail_id"] = "\(strBankDeailID)"
                            reqParam["stripeToken"] = strToken
                            
                            let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "ScheduleSessionVC") as! ScheduleSessionVC

                            nextVC.reqSessionParam = reqParam
                            self.navigationController?.pushViewController(nextVC, animated: true)

                        }
                    }
                }else{
                    HideProgress()
                }
            }
        }else{
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }

    
    func CheckBankDetailAPICall(strBookType:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.checkBankDetail)
            print(url)
            
            var reqParam:[String:Any] = [:]
            if self.isFromOtherUser {
                reqParam["user_id"] = "\(self.userId)"
            }
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: self.isFromOtherUser == true ? reqParam : [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CheckCoachBankDetailResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            if let flag = data.flag {
                                if flag == 0 {
                                    AlertView.showMessageAlert(mapData?.message ?? "", viewcontroller: self)
                                } else {
                                    
                                    self.CreateCardTokenAPICall(objcBankDetails: data.bankDetail!, strBookType: strBookType)
                                    
                                }
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
    
    //MARK: Subscribe to coach for videos
    func SubscribeVideosAPICall(subscriptionId: String, amount: String, tax: String, validity: String, total: String, date: String, bank_detail_ID:String,strCardToken:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.subscribeCoach)
            print(url)
            
            var reqParam:[String:Any] = [:]
            if self.isFromOtherUser {
                reqParam["coach_id"] = "\(self.userId)"
                reqParam["subscription_id"] = subscriptionId
                reqParam["amount"] = amount
                reqParam["tax"] = tax
                reqParam["validity"] = validity
                reqParam["total"] = total
                reqParam["date"] = date
                reqParam["bank_detail_id"] = bank_detail_ID
                reqParam["stripeToken"] = strCardToken
            }
            
            print(url)
            print(reqParam)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<SubscribeCoachResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let _ = mapData?.data//data = mapData?.data
                        {
                            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                                self.vwSubscribeOptions.alpha = 0.0
                                self.view.layoutIfNeeded()
                            })

                            AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
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
    //Increase video count
    func videoCountAPICall(strVideoID:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = WebService.createURLForWebService(WebService.videoviews)
            print(url)
            var reqParam:[String: Any] = [:]
            reqParam["video_id"] = strVideoID
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
            }
        }else{
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
}

//MARK:- Collectionview Delegate Datasource -
//MARK:-
extension CoachProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCoachVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoPostCell", for: indexPath) as! VideoPostCell
        let objDetails = arrCoachVideo[indexPath.row]
        
        if let userData = getUserInfo() {
            if userData.user_type != 2 {//not coach
                if (objDetails.subscriptionInfo?.subscribecoach!.status)!{
                    cell.imgVideoPost.removeBlurEffect()
                    cell.isUserInteractionEnabled = true
                }else{
                    if freeVideosRemaining >= indexPath.row {
                        cell.imgVideoPost.removeBlurEffect()
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.imgVideoPost.setBlurImgeView()
                        cell.isUserInteractionEnabled = false
                    }
                }
            }
        }
        
        cell.lblPostTitle.text = objDetails.title
        if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
            cell.imgVideoPost.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
        }
        cell.lblPostDate.text = getDayWithDate(stringDate: objDetails.date ?? "")

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if let videoUrl = arrCoachVideo[indexPath.row].videourl{
                    videoCountAPICall(strVideoID: "\(arrCoachVideo[indexPath.row].id ?? 0)")
                    if let url = URL.init(string: videoUrl){
                        playVideoAvPlayerViewController(videoUrl: url)
                    }
                }
            }else{
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
                    nextVC.objAthleteVideo = arrCoachVideo[indexPath.row]
                    nextVC.freeVideosRemaining = self.freeVideosRemaining
                    nextVC.isFromViewController = "athlete_profile"
                    nextVC.coachID = arrCoachVideo[indexPath.row].user_id ?? 0

                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: collectionView.bounds.height)
    }

}
