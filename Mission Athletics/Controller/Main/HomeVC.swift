//
//  HomeVC.swift
//  Mission Athletics
//
//  Created by Mac on 03/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper

protocol HomeVC_Delegate: class {
    func scrollViewDidScroll(scrollView: UIScrollView, tableView: UIScrollView)
}


class HomeVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnPostCategory: UIButton!
    @IBOutlet weak var ivFilterArrow: UIImageView!
    @IBOutlet weak var tvCoachFeeds: UITableView!
    @IBOutlet weak var tvPlayerFeeds: UITableView!
    @IBOutlet weak var btnAddVideo: UIButton!
    @IBOutlet weak var btnFilterAction: UIButton!
    @IBOutlet weak var lblMyVideoTitle: UILabel!

    @IBOutlet weak var vwMyPlayers: UIView!
    @IBOutlet weak var cvMyPlayers: UICollectionView!
    @IBOutlet weak var cvMyVideos: UICollectionView!
    @IBOutlet weak var btnMyAthleteAction: UIButton!

    //Filter view
    @IBOutlet weak var vwFilter: UIView!
    @IBOutlet weak var vwFilterTop: NSLayoutConstraint!
    @IBOutlet weak var cvFilterCategories: UICollectionView!
    @IBOutlet weak var cvFilterCategoriesHeight: NSLayoutConstraint!
    @IBOutlet var btnDisplayPostsOptions: [UIButton]!
    @IBOutlet weak var scrollView : UIScrollView!

    
    var arrSelected = [Int]()
    var isFreeVideo = -1
    var Total_Videos = 0
    var PageOffset = 1
    var limit  = 10
    var freeVideosRemaining = 0

    var arrSportsList = [SportsListArrModel]()
    var arrAthleteVideos = [ViewVideosArrModel]()
    var arrCoachvideos = [CoachVideosArrModel]()
    var arrCoachPlayer = [CoachMyPlayersArrModel]()

    weak var delegate: HomeVC_Delegate?

   
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("changeHome"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.changeHome(notification:)), name: Notification.Name("changeHome"), object: nil)

//        NotificationCenter.default.removeObserver(self, name: Notification.Name("callingHome"), object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.callingHome(notification:)), name: Notification.Name("callingHome"), object: nil)

        
        self.vwFilter.backgroundColor = UIColor.clear
        self.vwFilterTop.constant = -UIScreen.main.bounds.height //+ 50.0
        
//        self.cvMyPlayers.dataSource = self
//        self.cvMyPlayers.delegate = self
//        self.cvMyPlayers.reloadData()
//        cvMyVideos.register(UINib.init(nibName: "VideoPostCell", bundle: nil), forCellWithReuseIdentifier: "VideoPostCell")

        self.cvMyVideos.dataSource = self
        self.cvMyVideos.delegate = self
        self.cvMyVideos.reloadData()

        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    func prominentTabTaped() {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
        nextVC.isFromViewController = "coach_new_add_video"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func callingHome(notification: Notification)
    {
        if GlobalConstants.appDelegate.notifiObjHome == "videoCall"{
             GlobalConstants.appDelegate.notifiObjHome = ""
             let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CallingVC") as! CallingVC
             self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @objc func changeHome(notification: Notification)
    {
        if GlobalConstants.appDelegate.notifiObjHome == "videoCall"{
             GlobalConstants.appDelegate.notifiObjHome = ""
             let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "SessionLoadingVC") as! SessionLoadingVC
             self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupTableViewBasedOnUser()
        self.setFilterCollHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let flowLayout = self.cvMyVideos.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 25
            flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 65) / 2, height: 270)
            self.cvMyVideos.reloadData()
        }
        self.cvMyVideos.reloadData()
        if GlobalConstants.appDelegate.notifiObjHome == "videoCall"{
            GlobalConstants.appDelegate.notifiObjHome = ""
             let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "SessionLoadingVC") as! SessionLoadingVC
             self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            PageOffset = 1
            self.getSportsListAPICall()
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//coach
                    self.getCoachVideosAPICall(strSearch: "")
                }
            }
        }

    }
    
    //MARK:- objc methods
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
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
                break
            default:
                break
            }
        }
    }
    
    //MARK:- Helpers
    func setupTableViewBasedOnUser()
    {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//2 {//coach
                self.btnAddVideo.isHidden = false
//                self.btnPostCategory.isHidden = false//false
//                self.ivFilterArrow.isHidden = false//false
//                self.tvPlayerFeeds.isHidden = false
//                self.tvCoachFeeds.isHidden = false
//
//                self.tvCoachFeeds.dataSource = self
//                self.tvCoachFeeds.delegate = self
////                self.tvCoachFeeds.tableFooterView = UIView()
//                self.tvCoachFeeds.reloadData()
                
                self.btnMyAthleteAction.isHidden = false
                self.btnFilterAction.isHidden = false
                self.lblTitle.isHidden = true
                self.lblMyVideoTitle.isHidden = false

//                self.btnAddVideo.isHidden = true
                self.btnPostCategory.isHidden = true//true
                self.ivFilterArrow.isHidden = true//true
                self.tvCoachFeeds.isHidden = true
                self.tvPlayerFeeds.isHidden = true
                self.cvMyVideos.isHidden = false
                
                self.cvMyVideos.delegate = self
                self.cvMyVideos.dataSource = self

                self.cvMyVideos.reloadData()
//                self.tabBarController?.tabBar.addSubview(btnAddVideo)
//
//                self.tabBarController?.tabBar.centerXAnchor.constraint(equalTo: btnAddVideo.centerXAnchor).isActive = true
//                self.tabBarController?.tabBar.topAnchor.constraint(equalTo: btnAddVideo.centerYAnchor, constant: 15).isActive = true

                
//                self.tvPlayerFeeds.dataSource = self
//                self.tvPlayerFeeds.delegate = self
//                //                self.tvPlayerFeeds.tableFooterView = UIView()
//                self.tvPlayerFeeds.reloadData()

            } else {
                self.btnMyAthleteAction.isHidden = true
                self.btnFilterAction.isHidden = true
                self.lblTitle.isHidden = false
                self.lblMyVideoTitle.isHidden = true
                self.cvMyVideos.isHidden = true

                self.btnAddVideo.isHidden = true
                self.btnPostCategory.isHidden = false//true
                self.ivFilterArrow.isHidden = false//true
                self.tvCoachFeeds.isHidden = true
                self.tvPlayerFeeds.isHidden = false
                
                self.tvPlayerFeeds.dataSource = self
                self.tvPlayerFeeds.delegate = self
//                self.tvPlayerFeeds.tableFooterView = UIView()
                self.tvPlayerFeeds.reloadData()
            }
        }
    }
    
    func openFilterPopup()
    {
        UIView.animate(withDuration: 0.8, animations: {() -> Void in
            self.ivFilterArrow.transform = self.ivFilterArrow.transform.rotated(by: CGFloat(Double.pi * 0.999))
            self.vwFilterTop.constant = 0
            self.vwFilter.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.btnFilterAction.isSelected = true
                self.btnMyAthleteAction.isHidden = true
                self.btnPostCategory.isSelected = true
                self.lblTitle.text = "Filter"
//                self.view.layoutIfNeeded()
            }
        })
    }
    
    func closeFilterPopup(callApiWithClose: Bool)
    {
        UIView.animate(withDuration: 0.8, animations: {() -> Void in
            self.ivFilterArrow.transform = CGAffineTransform.identity
            self.vwFilterTop.constant = -UIScreen.main.bounds.height
            self.vwFilter.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.btnFilterAction.isSelected = false
                self.btnMyAthleteAction.isHidden = false

                self.btnPostCategory.isSelected = false
                self.lblTitle.text = "Feed"
                self.view.layoutIfNeeded()
                if callApiWithClose {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        var sportId = [Int]()
                        for i in 0..<self.arrSportsList.count
                        {
                            let sport = self.arrSportsList[i]
                            if self.arrSelected.contains(i) {
                                sportId.append(sport.id!)
                            }
                        }
                        self.saveSportsAPICall(sportId: "\(sportId.map{String($0)}.joined(separator: ","))")
                    }
                }
            }
        })
    }
    
    //MARK:- IBActions
    
    @IBAction func btnMyAthleteAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "CoachAllPlayerVC") as! CoachAllPlayerVC
        self.navigationController?.pushViewController(nextVC, animated: true)

        self.view.endEditing(true)

    }
    
    @IBAction func btnFilterAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if sender.isSelected == false {
            self.openFilterPopup()
        } else {
            self.closeFilterPopup(callApiWithClose: false)
        }
    }
    
    @IBAction func btnAddVideoAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
        nextVC.isFromViewController = "coach_new_add_video"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnSelectPostFilterAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if sender.isSelected == false {
            self.openFilterPopup()
        } else {
            self.closeFilterPopup(callApiWithClose: false)
        }
    }
    
    @IBAction func btnSeeAllPlayersAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "CoachAllPlayerVC") as! CoachAllPlayerVC
        self.navigationController?.pushViewController(nextVC, animated: true)

        self.view.endEditing(true)
    }
    
    @IBAction func btnViewPlayerProfileAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
        
        nextVC.isFromOtherUser = true
        nextVC.isFromCoachHomeList = true
        nextVC.userId = arrCoachPlayer[sender.tag].id ?? 0
        self.navigationController?.pushViewController(nextVC, animated: true)

    }
    
    //MARK:- API Call
    func getSportsListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getSports)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .get, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<SportsListResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.arrSportsList = data
                            
                            if self.arrSportsList.count > 0 {
                                self.cvFilterCategories.dataSource = self
                                self.cvFilterCategories.delegate = self
                                self.cvFilterCategories.reloadData()
                                
                                if let userData = getUserInfo() {
                                    if userData.user_type == 3 {//athlete
                                        self.saveSportsAPICall(sportId: "")
                                    }
                                }
                            }
                        }
                        print("success")
                    }else if mapData?.code == "401"{
                        self.logoutApiCallSuccessAction()
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
    
    //MARK: Save Sports filter for athlete
    func saveSportsAPICall(sportId: String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.saveSports)
            print(url)
            
            var reqParam:[String: Any] = [:]
            reqParam["sport_id"] = "\(sportId)"
            print(reqParam)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<SaveFilterResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        self.arrSelected = []
                        if let data = mapData?.data {
                            if let sportsIdStr = data.sport_id
                            {
                                if sportsIdStr != "" {
                                    if sportsIdStr.contains(",")
                                    {
                                        let arrId = sportsIdStr.components(separatedBy: ",")
                                        
                                        for i in 0..<self.arrSportsList.count
                                        {
                                            let sport = self.arrSportsList[i]
                                            if arrId.contains("\(sport.id!)") {
                                                self.arrSelected.append(i)
                                            }
                                        }
                                        self.cvFilterCategories.reloadData()
                                        self.PageOffset = 1
                                        if let userData = getUserInfo() {
                                            if userData.user_type == 2 {//coach
                                                self.getCoachVideosAPICall(strSearch: "")
                                            }else{
                                                self.getAthleteVideosAPICall(strSearch: "")
                                            }
                                        }
                                    } else {
                                        if let intId = Int(sportsIdStr) {
                                            for i in 0..<self.arrSportsList.count
                                            {
                                                let sport = self.arrSportsList[i]
                                                if intId == sport.id! {
                                                    self.arrSelected.append(i)
                                                }
                                            }
                                            self.cvFilterCategories.reloadData()
                                            self.PageOffset = 1
                                            if let userData = getUserInfo() {
                                                if userData.user_type == 2 {//coach
                                                    self.getCoachVideosAPICall(strSearch: "")
                                                }else{
                                                    self.getAthleteVideosAPICall(strSearch: "")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        print("success")
                    } else {
                        if let userData = getUserInfo() {
                            if userData.user_type == 2 {//Coach
                                AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
                            } else {
                                self.openFilterPopup()
//                                AlertView.showAlert("", strMessage: "Please enter sport id", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
//
//                                    self.openFilterPopup()
//                                })
                            }
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
    
    //MARK: Athlete video list
    func getAthleteVideosAPICall(strSearch:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            if self.PageOffset == 1{
                ShowProgress()
            }
            let url = WebService.createURLForWebService(WebService.viewVideos)
            print(url)
            
            var sportId = [Int]()
            for i in 0..<self.arrSportsList.count
            {
                let sport = self.arrSportsList[i]
                if self.arrSelected.contains(i) {
                    sportId.append(sport.id!)
                }
            }
            
            var reqParam:[String: Any] = [:]
            reqParam["sport_id"] = "\(sportId.map{String($0)}.joined(separator: ","))"
            reqParam["limit"] = limit
            reqParam["page"] = PageOffset
            reqParam["keyword"] = strSearch
            print(reqParam)
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()

                    let mapData  = Mapper<ViewVideosResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.Total_Videos = data.total_videos ?? 0

                            if let videos = data.videodata {
                                if self.PageOffset == 1{
                                    self.arrAthleteVideos = []
                                    self.arrAthleteVideos = videos
                                }else{
                                    self.arrAthleteVideos += videos
                                }
                                self.isFreeVideo = data.free_videos ?? -1
                                if self.arrAthleteVideos.count > 0 {
                                    if self.PageOffset == 1{
                                        self.tvPlayerFeeds.restoreEmptyMessage()
                                        self.setupTableViewBasedOnUser()
                                    }else{
                                        self.tvPlayerFeeds.reloadData()
                                    }
                                } else {
                                    self.tvPlayerFeeds.setEmptyMessage("Feeds not found.")
                                    self.tvPlayerFeeds.reloadData()
                                }
                            } else {
                                self.arrAthleteVideos = [ViewVideosArrModel]()
                                self.tvPlayerFeeds.setEmptyMessage("Feeds not found.")
                                self.tvPlayerFeeds.reloadData()
                            }
                            if let freeVideosCount = data.free_videos {
                                self.freeVideosRemaining = freeVideosCount
                            }
                        } else {
                            self.arrAthleteVideos = [ViewVideosArrModel]()
                            self.tvPlayerFeeds.setEmptyMessage("Feeds not found.")
                            self.tvPlayerFeeds.reloadData()
                        }
                        print("success")
                    } else {
                        if let msg = mapData?.message {
                            if msg == "Please enter sport id" {
                                self.arrAthleteVideos = [ViewVideosArrModel]()
                                self.tvPlayerFeeds.setEmptyMessage("Feeds not found.")
                                self.tvPlayerFeeds.reloadData()
                                AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                                    
                                    self.openFilterPopup()
                                })
                            } else {
                                AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
                            }
                        } else {
                            AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
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
    
    //MARK: Coach video list
    func getCoachVideosAPICall(strSearch:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            
            if self.PageOffset == 1{
                ShowProgress()
            }
            var sportId = [Int]()
            for i in 0..<self.arrSportsList.count
            {
                let sport = self.arrSportsList[i]
                if self.arrSelected.contains(i) {
                    sportId.append(sport.id!)
                }
            }
            let url = WebService.createURLForWebService(WebService.viewCoachVideos)
            print(url)
            var reqParam:[String: Any] = [:]
            reqParam["sport_id"] = "\(sportId.map{String($0)}.joined(separator: ","))"
            reqParam["limit"] = limit
            reqParam["page"] = PageOffset
            reqParam["keyword"] = strSearch

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CoachVideosResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            self.Total_Videos = data.total_records ?? 0
//                            self.arrCoachPlayer = data.players ?? []
                            self.cvMyVideos.reloadData()
                            
                            if let videos = data.video {
                                
                                if self.PageOffset == 1{
                                    self.arrCoachvideos = []
                                    self.arrCoachvideos = videos
                                }else{
                                    self.arrCoachvideos += videos
                                }
                                if self.arrCoachvideos.count > 0 {
                                    self.setupTableViewBasedOnUser()
                                } else {
                                    self.cvMyVideos.setEmptyMessage("Feeds not found.")
                                }
                                self.cvMyVideos.reloadData()

//                                self.tvCoachFeeds.reloadData()
//                                 self.cvMyPlayers.reloadData()
                            } else {
                                self.arrCoachvideos = []
                                self.cvMyVideos.setEmptyMessage("Feeds not found.")
                                self.cvMyVideos.reloadData()
                            }
                        }
                        print("success")
                    }else if mapData?.code == "401"{
                        self.logoutApiCallSuccessAction()
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
              
              removeUserInfo(key: UserDefaultsKey.user)
              GlobalConstants.appDelegate.setRootViewController()
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
    //MARK: View user profile
    @IBAction func btnViewUserProfileAction(_ sender: UIButton)
    {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if self.arrCoachvideos.count > 0 {
                    let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                    nextVC.isFromAthlete = true
                    nextVC.userId = self.arrCoachvideos[sender.tag].user_id ?? 0
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            } else {
                if self.arrAthleteVideos.count > 0 {
                    let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                    nextVC.isFromOtherUser = true
                    nextVC.userId = self.arrAthleteVideos[sender.tag].user_id ?? 0
                    nextVC.subscriptionInfo = self.arrAthleteVideos[sender.tag].subscriptionInfo?.subscribecoach
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
    
    //MARK:- UITextfield delegate methods
    //MARK:-
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.PageOffset = 1
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space

        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                self.getCoachVideosAPICall(strSearch: newString as String)
            }else{
                getAthleteVideosAPICall(strSearch: newString as String)
            }
        }

        return true
    }
}

//MARK:- UITableview datasource delegate methods
//MARK:-

extension HomeVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                return self.arrCoachvideos.count
            } else {
                return self.arrAthleteVideos.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let homeCell = tableView.dequeueReusableCell(withIdentifier: "HomeFeedCell") as! HomeFeedCell
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if self.arrCoachvideos.count > 0 {
                    let videoObj = self.arrCoachvideos[indexPath.row]
                    
                    if let userImgUrl = URL(string: videoObj.userimage ?? "") {
                        homeCell.ivUser.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
                    } else {
                        homeCell.ivUser.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                    }
                    homeCell.ivUser.cornerRadius = homeCell.ivUser.frame.height / 2
                    homeCell.ivUser.clipsToBounds = true
                    if let userName = videoObj.username {
                        homeCell.lblUserName.text = userName
                    }
                    if let title = videoObj.title {
                        homeCell.lblVideoTitle.text = title
                    }
                    homeCell.lblSeenCount.text = "\(videoObj.totalviews ?? 0)"
                    if let videoThumbUrl = URL(string: videoObj.thumbnail_image ?? "") {
                        homeCell.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(named: "noImageHome"), options: .refreshCached, completed: nil)
                    }
                    homeCell.lblTime.text = getUploadTIme(timeStr: videoObj.created_at ?? "")
                }
            } else {
                if self.arrAthleteVideos.count > 0 {
                    let videoObj = self.arrAthleteVideos[indexPath.row]
                    
                    if let userImgUrl = URL(string: videoObj.image ?? "") {
                        homeCell.ivUser.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
                    } else {
                        homeCell.ivUser.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                    }
                    homeCell.ivUser.cornerRadius = homeCell.ivUser.frame.height / 2
                    homeCell.ivUser.clipsToBounds = true
                    
                    if let totalView = videoObj.totalviews {
                        homeCell.lblSeenCount.text = "\(totalView)"
                    }
                    
                    if let userName = videoObj.username {
                        homeCell.lblUserName.text = userName
                    }
                    if let title = videoObj.title {
                        homeCell.lblVideoTitle.text = title
                    }
                    if let videoThumbUrl = URL(string: videoObj.thumbnail_image ?? "") {
                        homeCell.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(named: "noImageHome"), options: .refreshCached, completed: nil)
                    }
                    homeCell.lblTime.text = getUploadTIme(timeStr: videoObj.created_at ?? "")
                }
            }
        }
        
        homeCell.btnViewUserProfile.tag = indexPath.row
        homeCell.btnViewUserProfile.addTarget(self, action: #selector(self.btnViewUserProfileAction(_:)), for: .touchUpInside)
        
        homeCell.selectionStyle = .none
        return homeCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310//360
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
                if self.arrCoachvideos.count > 0 {
                    nextVC.objCoachOwnvideos = self.arrCoachvideos[indexPath.row]
                }
                nextVC.isFromViewController = "coach_own_video"
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            } else {
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
                if self.arrAthleteVideos.count > 0 {
                    nextVC.objAthleteVideo = self.arrAthleteVideos[indexPath.row]
                    nextVC.freeVideosRemaining = self.freeVideosRemaining
                    nextVC.objAthleteVideo = arrAthleteVideos[indexPath.row]
                    nextVC.isFromViewController = "athlete_profile"
                    nextVC.coachID = self.arrAthleteVideos[indexPath.row].user_id ?? 0
                }
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}


//MARK:- Collectionview Delegate Datasource Filter view
//MARK:-
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBAction func btnDisplayPostsAction(_ sender: UIButton)//not in use currently as we removed display post option from filter view
    {
        self.changeUI(tag: sender.tag)
    }
    
    @IBAction func btnSaveFiltersAction(_ sender: UIButton)
    {
        self.closeFilterPopup(callApiWithClose: true)
    }
    
    func changeUI(tag: Int)//not in use currently as we removed display post option from filter view
    {
        if tag == 0 {
            if self.btnDisplayPostsOptions[0].titleLabel?.textColor == UIColor.white {
                self.btnDisplayPostsOptions[0].layer.removeAllGradiantLayers()
                self.btnDisplayPostsOptions[0].setTitleColor(UIColor.blueGradientDark, for: .normal)
            } else {
                addGradientBackground(view: self.btnDisplayPostsOptions[0], gradientColors: [UIColor.blueGradientDark.cgColor, UIColor.blueGradientLight.cgColor], direction: .leftRight)
                self.btnDisplayPostsOptions[0].setTitleColor(UIColor.white, for: .normal)
            }
            self.btnDisplayPostsOptions[1].layer.removeAllGradiantLayers()
            self.btnDisplayPostsOptions[1].setTitleColor(UIColor.blueGradientDark, for: .normal)
        } else {
            if self.btnDisplayPostsOptions[1].titleLabel?.textColor == UIColor.white {
                self.btnDisplayPostsOptions[1].layer.removeAllGradiantLayers()
                self.btnDisplayPostsOptions[1].setTitleColor(UIColor.blueGradientDark, for: .normal)
            } else {
                addGradientBackground(view: self.btnDisplayPostsOptions[1], gradientColors: [UIColor.blueGradientDark.cgColor, UIColor.blueGradientLight.cgColor], direction: .leftRight)
                self.btnDisplayPostsOptions[1].setTitleColor(UIColor.white, for: .normal)
            }
            self.btnDisplayPostsOptions[0].layer.removeAllGradiantLayers()
            self.btnDisplayPostsOptions[0].setTitleColor(UIColor.blueGradientDark, for: .normal)
        }
    }
    
    func setFilterCollHeight()
    {
        if self.arrSportsList.count < 4 {
            self.cvFilterCategoriesHeight.constant = 40
        } else if self.arrSportsList.count < 7 {
            self.cvFilterCategoriesHeight.constant = 90
        } else {
            self.cvFilterCategoriesHeight.constant = 140
        }
    }
    
    //MARK:- UICollectionView DataSource Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvMyPlayers {
            return self.arrCoachPlayer.count
        }else if collectionView == self.cvMyVideos {
            return self.arrCoachvideos.count
        } else {
            return self.arrSportsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == self.cvMyPlayers {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMyPlayersCell", for: indexPath) as! HomeMyPlayersCell
            
            let objDetails = arrCoachPlayer[indexPath.row]
            cell.lblUserName.text = objDetails.name
            if let videoThumbUrl = URL(string: objDetails.userimage ?? "") {
                cell.ivUser.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
            }else{
                cell.ivUser.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
            }
            
            cell.btnViewProfile.tag = indexPath.item
            cell.btnViewProfile.addTarget(self, action: #selector(self.btnViewPlayerProfileAction(_:)), for: .touchUpInside)
            
            return cell
        }else if collectionView == self.cvMyVideos {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoachVideoListCell", for: indexPath) as! CoachVideoListCell
            
            let objDetails = arrCoachvideos[indexPath.row]
            
            cell.lblVideoTitle.text = objDetails.title
            cell.lblCoachName.text = objDetails.username
            if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
                cell.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
            }
//            cell.lblPostDate.text = getDayWithDate(stringDate: objDetails.date ?? "")
//            cell.lblPostTitle.text = objDetails.title ?? ""
//            if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
//                cell.imgVideoPost.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
//            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCategoriesCell", for: indexPath) as! FilterCategoriesCell
            
            let sport = self.arrSportsList[indexPath.item]
            
            cell.btnCategory.setTitle(sport.title, for: .normal)
            
            if self.arrSelected.count > 0 {
                if self.arrSelected.contains(indexPath.item) {
                    addGradientBackground(view: cell.btnCategory, gradientColors: [UIColor.blueGradientDark.cgColor, UIColor.blueGradientLight.cgColor], direction: .leftRight)
                    cell.btnCategory.setTitleColor(UIColor.white, for: .normal)
                } else {
                    cell.btnCategory.layer.removeAllGradiantLayers()
                    cell.btnCategory.setTitleColor(UIColor.blueGradientDark, for: .normal)
                }
            } else {
                cell.btnCategory.layer.removeAllGradiantLayers()
                cell.btnCategory.setTitleColor(UIColor.blueGradientDark, for: .normal)
            }
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.cvMyPlayers {
//            return CGSize(width: 90, height: 90)
//        }
////        else if collectionView == self.cvMyVideos {
////            return CGSize(width: (collectionView.bounds.width - 65) / 2, height: 270)
////        }
//        else {
//            return CGSize(width: (collectionView.bounds.width - 20) / 3, height: 40.0)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.cvMyPlayers {
            
        }else if collectionView == self.cvMyVideos {
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//coach
                    if userData.id == self.arrCoachvideos[indexPath.row].user_id{
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
                        if self.arrCoachvideos.count > 0 {
                            nextVC.objCoachOwnvideos = self.arrCoachvideos[indexPath.row]
                        }
                        nextVC.isFromViewController = "coach_own_video"
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }else{
                        if let videoUrl = arrCoachvideos[indexPath.row].videourl{
                            videoCountAPICall(strVideoID: "\(arrCoachvideos[indexPath.row].id ?? 0)")
                            if let url = URL.init(string: videoUrl){
                                playVideoAvPlayerViewController(videoUrl: url)
                            }
                        }
                    }
                }else{
                    let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
                    if self.arrCoachvideos.count > 0 {
                        nextVC.objCoachOwnvideos = self.arrCoachvideos[indexPath.row]
                    }
                    nextVC.isFromViewController = "coach_own_video"
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            
    
        }else {
            if self.arrSelected.contains(indexPath.item) {
                self.arrSelected.remove(at: self.arrSelected.index(of: indexPath.item)!)
            } else {
                self.arrSelected.append(indexPath.item)
            }
            self.cvFilterCategories.reloadData()
        }
    }
}
//MARK:- Scrollview method
//MARK:-
extension HomeVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: self.scrollView, tableView: self.scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if ((self.tvCoachFeeds.contentOffset.y + self.tvCoachFeeds.frame.size.height) >= tvCoachFeeds.contentSize.height)
        {
            if let userData = getUserInfo() {
                if userData.user_type == 2 {
                    if self.arrCoachvideos.count < self.Total_Videos{
                        AppData.showLoaderInFooter(on: self.tvCoachFeeds)

                        self.PageOffset += 1
                        print("PAGination")
                        self.getCoachVideosAPICall(strSearch: "")
                    }else{
                        AppData.hideLoaderInFooter(on: self.tvCoachFeeds)
                    }
                } else {
                    if self.arrAthleteVideos.count < self.Total_Videos{
                        AppData.showLoaderInFooter(on: self.tvPlayerFeeds)

                        self.PageOffset += 1
                        print("PAGination")
                        self.getAthleteVideosAPICall(strSearch: "")
                    }else{
                        AppData.hideLoaderInFooter(on: self.tvPlayerFeeds)
                    }
                }
            }
        }
    }
}


class ProminentTabBar: UITabBar {
    var prominentButtonCallback: (()->())?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let items = items, items.count>0 else {
            return super.hitTest(point, with: event)
        }

        let middleItem = items[items.count/2]
        let middleExtra = middleItem.imageInsets.top
        let middleWidth = bounds.width/CGFloat(items.count)
        let middleRect = CGRect(x: (bounds.width-middleWidth)/2, y: middleExtra, width: middleWidth, height: abs(middleExtra))
        if middleRect.contains(point) {
            prominentButtonCallback?()
            return nil
        }
        return super.hitTest(point, with: event)
    }
}
