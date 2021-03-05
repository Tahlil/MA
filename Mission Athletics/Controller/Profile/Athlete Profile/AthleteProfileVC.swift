//
//  AthleteProfileVC.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 04/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class AthleteProfileVC: UIViewController
{
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var HeightBookmarkVideo: NSLayoutConstraint!
    
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var ivUserCover: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
//    @IBOutlet weak var lblUserTeam: UILabel!
//    @IBOutlet weak var lblEmail: UILabel!
//    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblTrainersCount: UILabel!
    @IBOutlet weak var lblPostsCount: UILabel!
    @IBOutlet weak var lblFriendsCount: UILabel!
    @IBOutlet weak var collVideoPost: UICollectionView!
    @IBOutlet weak var collBookmarkVideo: UICollectionView!
    
    @IBOutlet weak var vwReqAcceptRejectHeight: NSLayoutConstraint!
    @IBOutlet weak var vwReqAcceptReject: UIView!
    
    @IBOutlet weak var vwSettings: UIView!
    @IBOutlet weak var vwSettingsBG: UIView!
    @IBOutlet weak var vwSettingsBGSideLayer: UIView!
    @IBOutlet weak var vwSettingsWidth: NSLayoutConstraint!
    @IBOutlet weak var vwSettingsTrailing: NSLayoutConstraint!
    @IBOutlet weak var ivUserSideMenu: UIImageView!
    @IBOutlet weak var lblUserNameSideMenu: UILabel!
    @IBOutlet weak var lblUserTeamSideMenu: UILabel!
    
    var arrBookmarkVideos = [ViewVideosArrModel]()
    var arrAthletVideos = [ViewVideosArrModel]()
    var arrMyVideos = [AthleteMyVideosArrModel]()
    
    var chatId = -1
    var userId = -1
    var isRequest = false
    var isFromOtherUser = false
    var isFromCoachHomeList = false
    var freeVideosRemaining = 0

    
    //MARK:- Viewlifecycle methods-
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if isFromCoachHomeList{
//            HeightBookmarkVideo.constant = 0
//        }
        
        self.vwSettingsWidth.constant = UIScreen.main.bounds.width//0
        self.vwSettingsTrailing.constant = -UIScreen.main.bounds.width
        self.vwSettingsBG.isHidden = true
        
        collVideoPost.register(UINib.init(nibName: "VideoPostCell", bundle: nil), forCellWithReuseIdentifier: "VideoPostCell")
        collBookmarkVideo.register(UINib.init(nibName: "VideoPostCell", bundle: nil), forCellWithReuseIdentifier: "VideoPostCell")
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.tapHandle(gesture:)))
        self.vwSettingsBGSideLayer.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusBarAppearanceWhenComeBack(notification:)), name: Notification.Name("statusBarAppearanceWhenComeBack"), object: nil)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnBack.isHidden = !self.isFromOtherUser
        self.btnSettings.isHidden = self.isFromOtherUser
        
        if self.isFromOtherUser {
            self.tabBarController?.tabBar.isHidden = true
            
            if self.isRequest {
//                self.vwPersonalInfoHeight.constant = 290
                self.vwReqAcceptRejectHeight.constant = 78
                self.vwReqAcceptReject.alpha = 1.0
            } else {
//                self.vwPersonalInfoHeight.constant = 210
                self.vwReqAcceptRejectHeight.constant = 0
                self.vwReqAcceptReject.alpha = 0.0
            }
        } else {
//            self.vwPersonalInfoHeight.constant = 210
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
        
        if self.isFromOtherUser {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- objc methods-
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
    
    //MARK:- IBActions-
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
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteVideoListVC") as! AthleteVideoListVC
        nextVC.strViewTitle = "Bookmarked Videos"
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                nextVC.isFromViewVideo = "athlet_profile_bookMarkvideo"
            }else{
                if isFromOtherUser{
                    nextVC.isFromViewVideo = "athlet_profile_bookMarkvideo"
                }else{
                    nextVC.isFromViewVideo = "athlet_profile_video"

                }
            }
        }
        nextVC.coachVideoID = userId
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnSeeAllVideoPostAction(_ sender: UIButton) {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteVideoListVC") as! AthleteVideoListVC

        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if isFromCoachHomeList{
                    nextVC.strViewTitle = "Athlete Video"
                    nextVC.isFromViewVideo = "athlet_profile_videoPost"
                    nextVC.coachVideoID = userId

                }else{
                    nextVC.strViewTitle = "My Video"
                    nextVC.isFromViewVideo = "athlet_profile"
                    nextVC.coachVideoID = userData.id ?? 0
                }
            }else{
                if isFromOtherUser{
                    nextVC.strViewTitle = "Athlete Video"
                    nextVC.isFromViewVideo = "athlet_profile_videoPost"
                    nextVC.coachVideoID = userId

                }else{
                    nextVC.strViewTitle = "Athlete Video"
                    nextVC.isFromViewVideo = "athlet_profile"
                    nextVC.coachVideoID = userId
                }
            }
        }
        self.navigationController?.pushViewController(nextVC, animated: true)

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
    
    //Profile buttons
    @IBAction func btnAllrainers(_ sender: UIButton) {
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "CoachAllPlayerVC") as! CoachAllPlayerVC
        nextVC.isFromView = "athlete"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func btnAllFriends(_ sender: UIButton) {
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "FriendsListVC") as! FriendsListVC
        nextVC.isViewFrom = "CoachProfile"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func btnAllPosts(_ sender: UIButton) {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteVideoListVC") as! AthleteVideoListVC

        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if isFromCoachHomeList{
                    nextVC.strViewTitle = "Athlete Video"
                    nextVC.isFromViewVideo = "athlet_profile_videoPost"
                    nextVC.coachVideoID = userId
                }else{
                    nextVC.strViewTitle = "My Video"
                    nextVC.isFromViewVideo = "athlet_profile"
                    nextVC.coachVideoID = userData.id ?? 0
                }
            }else{
                if isFromOtherUser{
                    nextVC.strViewTitle = "Athlete Video"
                    nextVC.isFromViewVideo = "athlet_profile_videoPost"
                    nextVC.coachVideoID = userId
                }else{
                    nextVC.strViewTitle = "Athlete Video"
                    nextVC.isFromViewVideo = "athlet_profile"
                    nextVC.coachVideoID = userId
                }
            }
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    //MARK:- API Call-
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
                    
                    let mapData  = Mapper<AthleteGetProfileResModel>().map(JSONString: result!)
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
                            
                            
                            self.arrMyVideos = data.myVideos ?? []
                            self.collVideoPost.reloadData()
                            self.userId = data.id ?? 0
                            self.arrBookmarkVideos = data.bookmarkVideo ?? []
                            self.collBookmarkVideo.reloadData()
                            self.collVideoPost.restoreEmptyMessage()
                            self.collBookmarkVideo.restoreEmptyMessage()

                            if self.arrMyVideos.count == 0{
                                self.collVideoPost.setEmptyMessage("Video post not found.")
                                self.collVideoPost.reloadData()
                            }
                            if self.arrBookmarkVideos.count == 0{
                                self.collBookmarkVideo.setEmptyMessage("Bookmarked Videos not found.")
                                self.collBookmarkVideo.reloadData()
                            }
                            self.lblUserName.text = data.name ?? ""
                            self.lblBio.text = data.descrip ?? ""
                            self.lblTrainersCount.text = "\(data.totalTrainer ?? 0)"
                            self.lblFriendsCount.text = "\(data.totalFriends ?? 0)"
                            self.lblPostsCount.text = "\(data.totalPost ?? 0)"
                            self.freeVideosRemaining = data.free_videos ?? 0
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

//MARK:- Collectionview Delegate Datasource-
//MARK:-
extension AthleteProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collBookmarkVideo == collectionView {
            return self.arrBookmarkVideos.count//10
        }else{
           // if self.isFromCoachHomeList{
         //       return arrAthletVideos.count
          //  }else{
                return self.arrMyVideos.count//10
         //   }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collBookmarkVideo == collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoPostCell", for: indexPath) as! VideoPostCell
            
            let objDetails = arrBookmarkVideos[indexPath.row]
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

            cell.lblPostDate.text = getDayWithDate(stringDate: objDetails.date ?? "")
            cell.lblPostTitle.text = objDetails.title ?? ""
            if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
                cell.imgVideoPost.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoPostCell", for: indexPath) as! VideoPostCell
            
            let objDetails = arrMyVideos[indexPath.row]
            
            cell.lblPostDate.text = getDayWithDate(stringDate: objDetails.date ?? "")
            cell.lblPostTitle.text = objDetails.title ?? ""
            if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
                cell.imgVideoPost.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collBookmarkVideo == collectionView {
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//coach
                    if let videoUrl = arrBookmarkVideos[indexPath.row].videourl{
                        videoCountAPICall(strVideoID: "\(arrBookmarkVideos[indexPath.row].id ?? 0)")
                        if let url = URL.init(string: videoUrl){
                            playVideoAvPlayerViewController(videoUrl: url)
                        }
                    }
                }else{
                    if isFromOtherUser{
                        if let videoUrl = arrBookmarkVideos[indexPath.row].videourl{
                            videoCountAPICall(strVideoID: "\(arrBookmarkVideos[indexPath.row].id ?? 0)")
                            if let url = URL.init(string: videoUrl){
                                playVideoAvPlayerViewController(videoUrl: url)
                            }
                        }
                    }else{
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
                        nextVC.isFromViewController = "athlete_profile"
                        nextVC.freeVideosRemaining = self.freeVideosRemaining
                        nextVC.objAthleteVideo = arrBookmarkVideos[indexPath.row]
                        nextVC.coachID = arrBookmarkVideos[indexPath.row].user_id ?? 0

                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        
        } else {
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//coach
                    if let videoUrl = arrMyVideos[indexPath.row].videourl{
                        if let url = URL.init(string: videoUrl){
                            playVideoAvPlayerViewController(videoUrl: url)
                        }
                    }
                }else{
                    if isFromOtherUser{
                        if let videoUrl = arrMyVideos[indexPath.row].videourl{
                            if let url = URL.init(string: videoUrl){
                                playVideoAvPlayerViewController(videoUrl: url)
                            }
                        }
                    }else{
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
                        nextVC.objAthleteVideo = arrMyVideos[indexPath.row]
                        nextVC.isFromViewController = "athlete_video"
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        }
    }
}
