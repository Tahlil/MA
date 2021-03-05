//
//  NotificationsVC.swift
//  Mission Athletics
//
//  Created by apple on 11/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD

class NotificationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var isUpcomingSession = false//If there comes upcoming session's info from backend then make it true for UI changes.
    
    @IBOutlet weak var tvNotifications: UITableView!
    @IBOutlet weak var vwUpcomingSessions: UIView!
    @IBOutlet weak var vwTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitleBottom: NSLayoutConstraint!
    @IBOutlet weak var lblUpcomingSessionsInfo: UILabel!
    
    var arrayNotifiationList = [NotificationDataModel]()
    var selectedNotifID = -1
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tvNotifications.dataSource = self
        self.tvNotifications.delegate = self
        self.tvNotifications.tableFooterView = UIView()
        self.tvNotifications.reloadData()
        
        self.handleUpcomingSessionsUI()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.makeNotificationSeen(notification:)), name: Notification.Name("makeNotificationSeen"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.getAllNotificationListAPICall()
        self.vwUpcomingSessions.layer.removeAllGradiantLayers()
        addGradientBackground(view: self.vwUpcomingSessions, gradientColors: [UIColor.appBlueColor.cgColor, UIColor(red: 0/255, green: 100/255, blue: 246/255, alpha: 1.0).cgColor], direction: .leftRight)
    }
    
    //MARK:- objc methods
    @objc func makeNotificationSeen(notification: Notification)
    {
//        if let obj = notification.object as? String {
            self.SeenNotificationAPICall(notifID: "\(self.selectedNotifID)")
//        }
    }
    
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
    
    //Helpers
    func handleUpcomingSessionsUI()
    {
        if self.isUpcomingSession {
            self.vwTitleHeight.constant = 160
            self.lblTitleBottom.constant = 75
            self.vwUpcomingSessions.isHidden = false
        } else {
            self.vwTitleHeight.constant = 110
            self.lblTitleBottom.constant = 30
            self.vwUpcomingSessions.isHidden = true
        }
    }
    
    //MARK:- IBActions
    @IBAction func btnUpcomingSessionsAction(_ sender: UIButton)
    {
        print("Preview sessions tapped")
    }
    
    //MARK:- UITableView datasource delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayNotifiationList.count//return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotifiationList[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsListCell") as! NotificationsListCell
        
        if let imgUrl = URL(string: arrayNotifiationList[indexPath.section].data[indexPath.row].userimage!) {
            cell.ivUser.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "User_Placeholder_ChatList"), options: .refreshCached, completed: nil)
        }else{
            cell.ivUser.image = #imageLiteral(resourceName: "user")
        }
        
        let htmlText = arrayNotifiationList[indexPath.section].data[indexPath.row].message!
        if let htmlData = htmlText.data(using: String.Encoding.unicode) {
            do {
                let attributedText = try NSAttributedString(data: htmlData, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                cell.lblText.attributedText = attributedText
            } catch let e as NSError {
                print("Couldn't translate \(htmlText): \(e.localizedDescription) ")
            }
        }

        if let updatedDtStr = arrayNotifiationList[indexPath.section].data[indexPath.row].created_at {
//            let updatedDtStrCompo = updatedDtStr.components(separatedBy: " ")
            cell.lblTime.text = checkForAMPM(time: updatedDtStr)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)
        headerView.backgroundColor = UIColor.white
        
        let sectionTitle = UILabel()
        sectionTitle.frame = CGRect(x: 20, y: 25, width: tableView.bounds.width, height: 25)
        sectionTitle.font = UIFont(name: "BrandonGrotesque-Medium", size: 22.0)
        sectionTitle.textColor = UIColor.appBlueColor
        headerView.addSubview(sectionTitle)
        
        sectionTitle.text = arrayNotifiationList[section].day_time?.capitalized
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 115
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.selectedNotifID = arrayNotifiationList[indexPath.section].data[indexPath.row].id!
        let userID = arrayNotifiationList[indexPath.section].data[indexPath.row].sender_id//.id
        let chatID = arrayNotifiationList[indexPath.section].data[indexPath.row].chat_id
        
        if let msgId = arrayNotifiationList[indexPath.section].data[indexPath.row].message_id {
            if msgId == 1 { //Request received
                if let userData = getUserInfo() {
                    if userData.user_type == 2 {
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                        nextVC.isFromOtherUser = true
                        nextVC.userId = userID ?? 0
                        nextVC.chatId = chatID ?? 0
                        nextVC.isRequest = true
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
                        nextVC.isFromOtherUser = true
                        nextVC.userId = userID ?? 0
                        nextVC.chatId = chatID ?? 0
                        nextVC.isRequest = true
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
            if msgId == 2 { //Request accepted
                
                if let userData = getUserInfo() {
                    self.SeenNotificationAPICall(notifID: "\(self.selectedNotifID)")

                    if userData.user_type == 2 {
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                        nextVC.isFromOtherUser = true
                        nextVC.userId = userID ?? 0
                        nextVC.chatId = chatID ?? 0
                        nextVC.isRequest = false
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
                        nextVC.isFromOtherUser = true
                        nextVC.userId = userID ?? 0
                        nextVC.chatId = chatID ?? 0
                        nextVC.isRequest = false
                        nextVC.isFromCoachHomeList = true
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
            if msgId == 3 { //Video added notification
                if let userData = getUserInfo() {
                    self.SeenNotificationAPICall(notifID: "\(self.selectedNotifID)")

                    if userData.user_type == 2 {
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
            if msgId == 5 || msgId == 4{ //subscribe session

                if let userData = getUserInfo() {
                    self.SeenNotificationAPICall(notifID: "\(self.selectedNotifID)")

                    if userData.user_type == 2 {
                        let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "UpcomingSessionVC") as! UpcomingSessionVC
                        nextVC.strDate = arrayNotifiationList[indexPath.section].data[indexPath.row].booking_date ?? ""
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "UpcomingSessionVC") as! UpcomingSessionVC
                        nextVC.strDate = arrayNotifiationList[indexPath.section].data[indexPath.row].booking_date ?? ""
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        }
    }
    
    //MARK:- API Call
    func getAllNotificationListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getAllNotification)
            print(url)
            
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .get, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<NotificationModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.arrayNotifiationList = data
                            
                            if self.arrayNotifiationList.count > 0 {
                                GlobalConstants.appDelegate.getUnreadNotifyCountAPICall()
                                
                                self.tvNotifications.dataSource = self
                                self.tvNotifications.delegate = self
                                self.tvNotifications.reloadData()
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    //Request received notification tapped
                                    if self.arrayNotifiationList.count > 0, let id = GlobalConstants.appDelegate.notifiObjReqReceive["id"] as? Int {
                                        outerLoop: for i in 0..<self.arrayNotifiationList.count
                                        {
                                            for j in 0..<self.arrayNotifiationList[i].data.count
                                            {
                                                let notif = self.arrayNotifiationList[i].data[j]
                                                if notif.sender_id! == id
                                                {
                                                    self.selectedNotifID = notif.id!
                                                    let userID = notif.sender_id
                                                    let chatID = notif.chat_id
                                                    
                                                    if let userData = getUserInfo() {
                                                        if userData.user_type == 2 {
                                                            let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                                                            nextVC.isFromOtherUser = true
                                                            nextVC.userId = userID ?? 0
                                                            nextVC.chatId = chatID ?? 0
                                                            nextVC.isRequest = true
                                                            self.navigationController?.pushViewController(nextVC, animated: true)
                                                            GlobalConstants.appDelegate.notifiObjReqReceive = [:]
                                                            break outerLoop
                                                        } else {
                                                            let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
                                                            nextVC.isFromOtherUser = true
                                                            nextVC.userId = userID ?? 0
                                                            nextVC.chatId = chatID ?? 0
                                                            nextVC.isRequest = true
                                                            self.navigationController?.pushViewController(nextVC, animated: true)
                                                            GlobalConstants.appDelegate.notifiObjReqReceive = [:]
                                                            break outerLoop
                                                        }
                                                    }
                                                }
                                            }
                                        }//For loop
                                    }
                                    
                                    //Request accepted notification tapped
                                    if self.arrayNotifiationList.count > 0, let id = GlobalConstants.appDelegate.notifiObjReqAccepted["id"] as? Int {
                                        outerLoop: for i in 0..<self.arrayNotifiationList.count
                                        {
                                            for j in 0..<self.arrayNotifiationList[i].data.count
                                            {
                                                let notif = self.arrayNotifiationList[i].data[j]
                                                if notif.sender_id! == id
                                                {
                                                    self.selectedNotifID = notif.id!
                                                    let userID = notif.sender_id
                                                    let chatID = notif.chat_id
                                                    
                                                    if let userData = getUserInfo() {
                                                        if userData.user_type == 2 {
                                                            let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                                                            nextVC.isFromOtherUser = true
                                                            nextVC.userId = userID ?? 0
                                                            nextVC.chatId = chatID ?? 0
                                                            nextVC.isRequest = false
                                                            self.navigationController?.pushViewController(nextVC, animated: true)
                                                            GlobalConstants.appDelegate.notifiObjReqAccepted = [:]
                                                            break outerLoop
                                                        } else {
                                                            let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
                                                            nextVC.isFromOtherUser = true
                                                            nextVC.userId = userID ?? 0
                                                            nextVC.chatId = chatID ?? 0
                                                            nextVC.isRequest = false
                                                            self.navigationController?.pushViewController(nextVC, animated: true)
                                                            GlobalConstants.appDelegate.notifiObjReqAccepted = [:]
                                                            break outerLoop
                                                        }
                                                    }
                                                }
                                            }
                                        }//For loop
                                    }
                                    
                                    //Request session notification tapped
                                    if self.arrayNotifiationList.count > 0, let id = GlobalConstants.appDelegate.notifiObjReqSession["id"] as? Int {
                                        outerLoop: for i in 0..<self.arrayNotifiationList.count
                                        {
                                            for j in 0..<self.arrayNotifiationList[i].data.count
                                            {
                                                let notif = self.arrayNotifiationList[i].data[j]
                                                if notif.sender_id! == id
                                                {
                                                    self.selectedNotifID = notif.id!
                                                    
                                                    if let userData = getUserInfo() {
                                                        if userData.user_type == 2 {
                                                            let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "UpcomingSessionVC") as! UpcomingSessionVC
                                                            nextVC.strDate = notif.booking_date ?? ""
                                                            self.navigationController?.pushViewController(nextVC, animated: true)
                                                            GlobalConstants.appDelegate.notifiObjReqSession = [:]
                                                            break outerLoop

                                                        } else {
                                                            let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "UpcomingSessionVC") as! UpcomingSessionVC
                                                            nextVC.strDate = notif.booking_date ?? ""
                                                            self.navigationController?.pushViewController(nextVC, animated: true)
                                                            GlobalConstants.appDelegate.notifiObjReqSession = [:]
                                                            break outerLoop

                                                        }
                                                    }
                                                }
                                            }
                                        }//For loop
                                    }
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
    
    //MARK: Seen notification API Call
    func SeenNotificationAPICall(notifID:String){
        if Reachability.isConnectedToNetwork(){
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.seenNotification)
            print(url)
            let param:Parameters = ["notification_id":notifID]
            print(param)
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true{
                    HideProgress()
                    
                    let mapData  = Mapper<FriendListModel>().map(JSONString: result!)
                    if mapData?.code == "200"{
                        self.getAllNotificationListAPICall()
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
