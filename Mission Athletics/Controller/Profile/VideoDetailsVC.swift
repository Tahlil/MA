//
//  VideoDetailsVC.swift
//  Mission Athletics
//
//  Created by MAC  on 17/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import AVFoundation
import AVKit
import ObjectMapper
import UIKit

class VideoDetailsVC: UIViewController
{
    @IBOutlet weak var ivVideoThumb: UIImageView!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblCoachName: UILabel!
    @IBOutlet weak var lblSubscribtionInfo: UILabel!
    @IBOutlet weak var lblVideoDuration: UILabel!
    @IBOutlet weak var vwVideoRating: CosmosView!
    @IBOutlet weak var btnWatchNowSubscribe: UIButton!
    @IBOutlet weak var vwBookmarkWidth: NSLayoutConstraint!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var lblVideoDesc: UILabel!
    @IBOutlet weak var btnSubscribeSession: UIButton!
    @IBOutlet weak var btnSubscribeVideo: UIButton!
    @IBOutlet weak var btnCompareVideo: UIButton!
    @IBOutlet weak var heightCompareVideoButton: NSLayoutConstraint!
    @IBOutlet weak var vwSubscribeOptions: UIView!
    @IBOutlet weak var vwRatingReview: CosmosView!
    
    var objAthleteVideo: ViewVideosArrModel?
    var objCoachVideo: CoachVideosArrModel?
    
    var coachID = -1
    
    var isFromViewController = ""
    var freeVideosRemaining = 0
    
    var isSubscribeForSession = false
    var isTotalFreeSession = 0
    var isSubscribeForVideo = false
    var totalSubscribedSessionCount = 0

    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        vwVideoRating.rating = 0.0
        
        self.vwSubscribeOptions.alpha = 0.0
        self.view.layoutIfNeeded()

        DispatchQueue.main.async {
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//coach
                    if let videoThumbUrl = URL(string: self.objCoachVideo?.thumbnail_image ?? "") {
                        self.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                    }
                    if let videoTitle = self.objCoachVideo?.title {
                        self.lblVideoTitle.text = videoTitle
                    }
                    if let videoUploadedBy = self.objCoachVideo?.username {
                        self.lblCoachName.text = videoUploadedBy
                    }
                    if let videoDesc = self.objCoachVideo?.descrip {
                        self.lblVideoDesc.text = videoDesc
                    }
                } else {
                    if self.isFromViewController == "athlete_profile"{
                        if let videoThumbUrl = URL(string: self.objAthleteVideo?.thumbnail_image ?? "") {
                            self.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                        }
                        if let videoTitle = self.objAthleteVideo?.title {
                            self.lblVideoTitle.text = videoTitle
                        }
                        if let videoUploadedBy = self.objAthleteVideo?.username {
                            self.lblCoachName.text = videoUploadedBy
                        }
                        if let videoDesc = self.objAthleteVideo?.descrip {
                            self.lblVideoDesc.text = videoDesc
                        }
                        if let videoDuration = self.objAthleteVideo?.duration {
                            self.lblVideoDuration.text = videoDuration
                        }
                        self.vwRatingReview.rating = Double(self.objAthleteVideo?.rate ?? 0)
                        self.vwRatingReview.text = "\(self.objAthleteVideo?.rate ?? 0) (\(self.objAthleteVideo?.review ?? 0) Reviews)"

                        if let bookmarkStatus = self.objAthleteVideo?.isBookmarkVideo {
                            if bookmarkStatus {
                                self.btnBookmark.setImage(UIImage(named: "bookmarked_btn"), for: .normal)
                            } else {
                                self.btnBookmark.setImage(UIImage(named: "bookmark_btn"), for: .normal)
                            }
                        }
                        self.isSubscribeForSession = self.objAthleteVideo?.subscriptionInfo?.subscribesession?.status ?? false
                        self.isSubscribeForVideo = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.status ?? false
//                        self.isTotalFreeSession = self.objAthleteVideo.free_session ?? 0
                        self.totalSubscribedSessionCount = self.objAthleteVideo?.subscriptionInfo?.subscribesession?.no_of_available ?? 0
                        self.setUserDetails()

                    }else{
                        if let videoThumbUrl = URL(string: self.objAthleteVideo?.thumbnail_image ?? "") {
                            self.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                        }
                        if let videoTitle = self.objAthleteVideo?.title {
                            self.lblVideoTitle.text = videoTitle
                        }
                        if let videoUploadedBy = self.objAthleteVideo?.username {
                            self.lblCoachName.text = videoUploadedBy
                        }
                        if let videoDesc = self.objAthleteVideo?.descrip {
                            self.lblVideoDesc.text = videoDesc
                        }
                        self.vwRatingReview.rating = Double(self.objAthleteVideo?.rate ?? 0)
                        self.vwRatingReview.text = "\(self.objAthleteVideo?.rate ?? 0) (\(self.objAthleteVideo?.review ?? 0) Reviews)"

                        if let bookmarkStatus = self.objAthleteVideo?.isBookmarkVideo {
                            if bookmarkStatus {
                                self.btnBookmark.setImage(UIImage(named: "bookmarked_btn"), for: .normal)
                            } else {
                                self.btnBookmark.setImage(UIImage(named: "bookmark_btn"), for: .normal)
                            }
                        }
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.TapViewReview(_:)))
        vwRatingReview.addGestureRecognizer(tap)
    }
    
    @objc func TapViewReview(_ sender: UITapGestureRecognizer? = nil) {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "RatingReviewPopupVC") as! RatingReviewPopupVC
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.video_id = self.objAthleteVideo?.id ?? -1
        nextVC.isFromView = "details"

        if self.isSubscribeForSession == true{
            self.present(nextVC, animated: false) {}
        }
        if self.isSubscribeForVideo == true{
            self.present(nextVC, animated: false) {}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                self.vwBookmarkWidth.constant = 0
            } else {
                self.vwBookmarkWidth.constant = 65
                
                let subscribeStatus = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.status ?? false
                let amount = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.amount ?? "0"
                let amountSession = self.objAthleteVideo?.subscriptionInfo?.subscribesession?.amount ?? "0"

                if subscribeStatus {
                    self.btnWatchNowSubscribe.setTitle("Watch Video", for: .normal)
                    self.btnWatchNowSubscribe.backgroundColor = UIColor.blueGradientDark//(red: 104/255, green: 154/255, blue: 205/255, alpha: 1.0)
                    self.lblSubscribtionInfo.text = "Subscribed"
                    self.heightCompareVideoButton.constant = 50
                    self.btnCompareVideo.setTitle("Compare Video", for: .normal)

                } else {
                    
                    if self.freeVideosRemaining > 0 {
                        self.btnCompareVideo.setTitle("Subscribe", for: .normal)
                        self.btnWatchNowSubscribe.setTitle("Watch Now", for: .normal)
                        self.btnWatchNowSubscribe.backgroundColor = UIColor.blueGradientDark//(red: 104/255, green: 154/255, blue: 205/255, alpha: 1.0)
                        self.lblSubscribtionInfo.text = "$\(amount) Coach subscription\n$\(amountSession) Online session"
                    } else {
                        self.heightCompareVideoButton.constant = 0
                        self.btnWatchNowSubscribe.setTitle("Subscribe", for: .normal)
                        self.btnWatchNowSubscribe.backgroundColor = UIColor(red: 255/255, green: 70/255, blue: 27/255, alpha: 1.0)
                        self.lblSubscribtionInfo.text = "$\(amount) Coach subscription\n$\(amountSession) Online session"
                    }
                }
            }
        }
    }
    func setUserDetails(){
        
        if self.isSubscribeForSession == true{
            self.btnSubscribeSession.setTitle("Book Session", for: .normal)
        }else{
            if isTotalFreeSession == 0{
                self.btnSubscribeSession.setTitle("Subscribe for Session", for: .normal)
            }else{
                self.btnSubscribeSession.setTitle("Free Session", for: .normal)
            }
        }
        if self.isSubscribeForVideo == true{
            self.btnSubscribeVideo.setTitle("Already Subscribed", for: .normal)
        }else{
            self.btnSubscribeVideo.setTitle("Subscribe to Coach", for: .normal)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override open var prefersStatusBarHidden: Bool
    {
        return false
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
                reqParam["coach_id"] = "\(coachID)"
                reqParam["subscription_id"] = "2"
                reqParam["date"] = dtStr
                
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "ScheduleSessionVC") as! ScheduleSessionVC
                nextVC.reqSessionParam = reqParam
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                if isSubscribeForSession == true{
                    
                    if totalSubscribedSessionCount != 0{
                        var reqParam:[String:Any] = [:]
                        reqParam["coach_id"] = "\(coachID)"
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
    //MARK:- IBActions
    @IBAction func btnPlayAction(_ sender: UIButton)
    {
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if let videoUrl = URL.init(string: objCoachVideo?.videourl ?? ""){
                    playVideoAvPlayerViewController(videoUrl:videoUrl)
                }
            } else {
                let subscribeStatus = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.status ?? false

                if subscribeStatus {
                    if let videoUrl = URL.init(string: objAthleteVideo?.videourl ?? ""){
                        videoCountAPICall(strVideoID: "\(objAthleteVideo?.id ?? 0)")
                        playVideoAvPlayerViewController(videoUrl:videoUrl)
                    }
                } else {
                    if self.freeVideosRemaining > 0 {
                        if let videoUrl = URL.init(string: objAthleteVideo?.videourl ?? ""){
                            playVideoAvPlayerViewController(videoUrl:videoUrl)
                            let strVideoID = "\(objAthleteVideo?.id ?? 0)"
                            videoCountAPICall(strVideoID: strVideoID)
                            VideoWatchcountAPICall(videoId: strVideoID == "0" ? "" : strVideoID)
                        }

                    } else {
                        UIView.animate(withDuration: 0.3, animations: {() -> Void in
                            self.vwSubscribeOptions.alpha = 1.0
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func btnSubscribeForVideo(_ sender: UIButton) {
        CheckDetailfunc(strBookType: "Video")
    }
    @IBAction func btnSubscriveForSession(_ sender: UIButton) {
        CheckDetailfunc(strBookType: "Session")
    }
    
    @IBAction func btnWatchSubscribeVideoAction(_ sender: UIButton)
    {
        if let subscribeStatus = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.status {
            if subscribeStatus {
                if let userData = getUserInfo(){
                    if userData.user_type == 2 {//coach
                        if let videoUrl = URL.init(string: objCoachVideo?.videourl ?? ""){
                            playVideoAvPlayerViewController(videoUrl:videoUrl)
                        }
                    } else {
                        if let videoUrl = URL.init(string: objAthleteVideo?.videourl ?? ""){
                            let strVideoID = "\(objAthleteVideo?.id ?? 0)"
                            videoCountAPICall(strVideoID: strVideoID)
                            playVideoAvPlayerViewController(videoUrl:videoUrl)
                        }
                    }
                }
            }else{
                if self.freeVideosRemaining > 0 {
                    if let videoUrl = URL.init(string: objAthleteVideo?.videourl ?? ""){
                        playVideoAvPlayerViewController(videoUrl:videoUrl)
                        let strVideoID = "\(objAthleteVideo?.id ?? 0)"
                        VideoWatchcountAPICall(videoId: strVideoID == "0" ? "" : strVideoID)
                        videoCountAPICall(strVideoID: strVideoID)

                    }
                } else {
                    UIView.animate(withDuration: 0.3, animations: {() -> Void in
                        self.vwSubscribeOptions.alpha = 1.0
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.vwSubscribeOptions.alpha = 1.0
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBAction func btnClosesubscribeview(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.vwSubscribeOptions.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnBookmarkAction(_ sender: UIButton)
    {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                
            } else {
                if let bookmarkStatus = self.objAthleteVideo?.isBookmarkVideo {
                    if bookmarkStatus || self.btnBookmark.image(for: .normal) == UIImage(named: "bookmarked_btn"){
                        self.removeBookmarkVideoAPICall(videoId: "\(self.objAthleteVideo?.id ?? 0)")
                    } else {
                        self.bookmarkVideoAPICall(videoId: "\(self.objAthleteVideo?.id ?? 0)")
                    }
                }
            }
        }
    }
    @IBAction func btnCompareVideoRequest(_ sender: UIButton) {
        let subscribeStatus = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.status ?? false
        
        if subscribeStatus{
            if let userData = getUserInfo() {
                if userData.user_type != 2 {//coach
                    let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteVideoListVC") as! AthleteVideoListVC
                    nextVC.strViewTitle = "My Videos"
                    nextVC.isFromViewVideo = "athlet_compare_profile"
                    nextVC.coachVideoID = userData.id ?? 0
                    nextVC.compareCoachID = objAthleteVideo?.id ?? 0
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.vwSubscribeOptions.alpha = 1.0
                self.view.layoutIfNeeded()
            })
        }
    }
        
    //MARK:- API Calls -
    func CheckBankDetailAPICall(strBookType:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.checkBankDetail)
            print(url)
            
            var reqParam:[String:Any] = [:]
            if isFromViewController == "athlete_profile"{
                let usrid = objAthleteVideo?.user_id
                reqParam["user_id"] = "\(usrid ?? 0)"
            }
            print(reqParam)
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
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
                reqParam["card[number]"] = objcBankDetails?.card_number
                reqParam["card[exp_month]"] = strCardExpMonth
                reqParam["card[exp_year]"] = strExpYear
                reqParam["card[cvc]"] = objcBankDetails?.cvv
            
            ServiceRequestResponse.servicecallStripeWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
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
                        
                        let amount = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.amount ?? ""
                        let tax = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.tax ?? ""
                        let val = self.objAthleteVideo?.subscriptionInfo?.subscribecoach?.validity ?? 0
                        let taxAmount = (Double(amount) ?? 0)*((Double(tax) ?? 0)/100)
                        let total = (Double(amount) ?? 0) + taxAmount
                        
                        
                        let amountSession = self.objAthleteVideo?.subscriptionInfo?.subscribesession?.amount ?? ""
                        let taxSession = self.objAthleteVideo?.subscriptionInfo?.subscribesession?.tax ?? ""
                        let valSession = self.objAthleteVideo?.subscriptionInfo?.subscribesession?.validity ?? 0
                        let taxAmountSession = (Double(amountSession) ?? 0)*((Double(taxSession) ?? 0)/100)
                        let totalSession = (Double(amountSession) ?? 0) + taxAmountSession

                        
                        let strBankDeailID = objcBankDetails?.id ?? -1
                        
                        let dtFormatter = DateFormatter()
                        dtFormatter.dateFormat = "yyyy-MM-dd"
                        dtFormatter.timeZone = .current
                        let dtStr = dtFormatter.string(from: Date())

                        if strBookType == "Video"{
                            self.SubscribeVideosAPICall(subscriptionId: subscribeId, amount: amount , tax: tax, validity: "\(val)", total: "\(total)", date: dtStr, bank_detail_ID: "\(strBankDeailID)", strCardToken: strToken)
                        }else{
                            var reqParam:[String:Any] = [:]
                            reqParam["coach_id"] = "\(self.coachID)"
                            reqParam["subscription_id"] = "3"
                            reqParam["amount"] = amountSession
                            reqParam["tax"] = taxAmountSession
                            reqParam["validity"] = "\(valSession)"
                            reqParam["total"] = totalSession
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

    //MARK: Subscribe to coach for videos
    func SubscribeVideosAPICall(subscriptionId: String, amount: String, tax: String, validity: String, total: String, date: String, bank_detail_ID:String,strCardToken:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.subscribeCoach)
            print(url)
            
            var reqParam:[String:Any] = [:]
            let usrid = objAthleteVideo?.user_id ?? 0
            
            reqParam["coach_id"] = "\(usrid)"
            reqParam["subscription_id"] = subscriptionId
            reqParam["amount"] = amount
            reqParam["tax"] = tax
            reqParam["validity"] = validity
            reqParam["total"] = total
            reqParam["date"] = date
            reqParam["bank_detail_id"] = bank_detail_ID
            reqParam["stripeToken"] = strCardToken
            
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

    
    //MARK: Bookmark Video
    func bookmarkVideoAPICall(videoId: String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.bookmarkVideo)
            print(url)
            let reqParams:[String:Any] = ["video_id":"\(videoId)"]
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<AddRemoveBookmarkVideoResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            if let isBooked = data.is_book {
                                if isBooked {
                                    self.btnBookmark.setImage(UIImage(named: "bookmarked_btn"), for: .normal)
                                } else {
                                    self.btnBookmark.setImage(UIImage(named: "bookmark_btn"), for: .normal)
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
    
    //MARK: Remove Bookmark Video
    func removeBookmarkVideoAPICall(videoId: String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.removeBookmarkVideo)
            print(url)
            let reqParams:[String:Any] = ["video_id":"\(videoId)"]
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
//                    let mapData  = Mapper<AddRemoveBookmarkVideoResModel>().map(JSONString: result!)
                    if let resultDict = JsonToDict(Json: result!) {
                        if resultDict["code"] as! String == "200" {
                            self.btnBookmark.setImage(UIImage(named: "bookmark_btn"), for: .normal)
                        } else{
                            AlertView.showMessageAlert((resultDict["message"] as? String ?? "") , viewcontroller: self)
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

    //MARK: Check Bank Detail API Call
    
    func VideoWatchcountAPICall(videoId: String){
        if Reachability.isConnectedToNetwork(){
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.watchVideoCount)
            print(url)
            
            let reqParams:[String:Any] = ["video_id":"\(videoId)"]

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true{
                    HideProgress()
                    let mapData  = Mapper<CheckCoachBankDetailResModel>().map(JSONString: result!)
                    if mapData?.code == "200"{
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
