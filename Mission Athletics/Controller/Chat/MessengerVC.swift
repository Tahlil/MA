//
//  MessengerVC.swift
//  Mission Athletics
//
//  Created by apple on 09/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SocketIO
import SVProgressHUD
import ObjectMapper

class MessengerVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnPlayers: UIButton!
    @IBOutlet weak var btnCoaches: UIButton!
    @IBOutlet weak var tvChatList: UITableView!

    var socket: SocketIOClient!
    var manager = SocketManager(socketURL: URL(string: "\(WebService.LivesocketUrl)")!)
    var pageNumber:Int = 1
    var arrChatUserList = [ChatUserDataModel]()
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvChatList.dataSource = self
        self.tvChatList.delegate = self
        self.tvChatList.tableFooterView = UIView()
        self.tvChatList.reloadData()
        self.tvChatList.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let userData = getUserInfo()
        let strUserID = "\(String(describing: userData?.id ?? 0))"
        
        manager = SocketManager(socketURL: URL(string: "\(WebService.LivesocketUrl)")!, config: [.path("\(WebService.LivesocketNode)"),.connectParams(["user_id":strUserID]), .reconnects(false)])
        socket = manager.defaultSocket

        pageNumber = 1
        addHandlers()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        socket.disconnect()
        SVProgressHUD.dismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.changeUI(tag: 0)
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
    
    //MARK:- IBActions
    @IBAction func btnCreateNewChatAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "FriendsListVC") as! FriendsListVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnPlayersCoachesSelectionAction(_ sendeR: UIButton)
    {
        self.view.endEditing(true)
        self.changeUI(tag: sendeR.tag)
    }
    
    //MARK:- Helpers
    func changeUI(tag: Int)
    {
        if tag == 0 {
            addGradientBackground(view: self.btnPlayers, gradientColors: [UIColor.blueGradientDark.cgColor, UIColor.blueGradientLight.cgColor], direction: .topBottom)
            self.btnPlayers.setTitleColor(UIColor.white, for: .normal)
            
            self.btnCoaches.layer.removeAllGradiantLayers()
            self.btnCoaches.setTitleColor(UIColor.blueGradientDark, for: .normal)
            self.btnCoaches.setImage(#imageLiteral(resourceName: "Coaches_blue"), for: .normal)
        } else {
            addGradientBackground(view: self.btnCoaches, gradientColors: [UIColor.blueGradientDark.cgColor, UIColor.blueGradientLight.cgColor], direction: .topBottom)
            self.btnCoaches.setTitleColor(UIColor.white, for: .normal)
            self.btnCoaches.setImage(#imageLiteral(resourceName: "whistle"), for: .normal)
            
            self.btnPlayers.layer.removeAllGradiantLayers()
            self.btnPlayers.setTitleColor(UIColor.blueGradientDark, for: .normal)
        }
    }
    
    //MARK:- UITextfield delegate methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space
        
        if self.btnPlayers.titleLabel?.textColor == UIColor.white { //Search Players
            
        } else { //Search Coaches
            
        }
        
        return true
    }
    
    
    func getSocketChatUsers(intPage: Int){
        
        SVProgressHUD.show()
        let userData = getUserInfo()
        let UDID = UIDevice.current.identifierForVendor!.uuidString

        let objReqModdel : MyChatListReqModel = MyChatListReqModel()
        objReqModdel.userid = userData?.id
        objReqModdel.device_id = UDID
        objReqModdel.page = intPage
        objReqModdel.limit = 20
        let jsonString = Mapper().toJSONString(objReqModdel)

        
        socket.emit("chatUserList", jsonString!)
        socket.on("chatUserList-\(UDID)") { (dataArray, socketAck) -> Void in
            self.socket.off("chatUserList-\(UDID)")
            print(dataArray)
            
            let messageData = Mapper<ChatUserListModel>().map(JSON: dataArray[0] as! [String : Any])

            self.arrChatUserList = messageData?.Data ?? []
            self.tvChatList.reloadData()
            
            SVProgressHUD.dismiss()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if self.arrChatUserList.count > 0, let id = GlobalConstants.appDelegate.notifiObjChat["chat_id"] as? Int {//} != nil {
                    for user in self.arrChatUserList
                    {
                        if user.id! == id//GlobalConstants.appDelegate.notifiObj["sender_id"] as! Int
                        {
                            let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                            nextVC.objChatUser = user
                            self.navigationController?.pushViewController(nextVC, animated: true)
                            GlobalConstants.appDelegate.notifiObjChat = [:]
                            break
                        }
                    }
                }
            }
            if self.arrChatUserList.count > 0 {
                self.tvChatList.restoreEmptyMessage()
                self.tvChatList.reloadData()
            } else {
                self.tvChatList.setEmptyMessage("No conversations found.")
                self.tvChatList.reloadData()
            }
        }
    }
}

//MARK:- UITableView datasource delegate methods
extension MessengerVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChatUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessengerListCell") as! MessengerListCell
        
        let objDetails = arrChatUserList[indexPath.row]

        
        let isOnline = objDetails.is_online
        if isOnline == "1" {
            cell.vwOnlineIndicator.isHidden = false
        } else {
            cell.vwOnlineIndicator.isHidden = true
        }
        
        var newMsg = false
        
        if let newMsgCount = objDetails.count {
            if newMsgCount == "0" {
                newMsg = false
            } else {
                newMsg = true
                cell.lblUnreadCount.text = "\(newMsgCount)"
            }
        }
        if newMsg {
            cell.lblUserName.textColor = UIColor.blueGradientDark
            cell.vwUnreadCount.isHidden = false
        } else {
            cell.lblUserName.textColor = UIColor.chatBlack100
            cell.vwUnreadCount.isHidden = true
        }
        
        cell.lblUserName.text = objDetails.receiver_name
        cell.lblLastMsg.text = objDetails.last_message?.removingPercentEncoding
        
        if let _ = objDetails.last_message_at?.components(separatedBy: "T") {
            cell.lblLastMsgTime.text = checkTForAMPM(time: objDetails.last_message_at ?? "")
        }
        
        if objDetails.profile_pic != nil {
            if let imgURL = URL(string: (objDetails.profile_pic)!) {
                cell.ivUser.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "User_Placeholder_ChatList"), options: .refreshCached, completed: nil)
            } else {
                cell.ivUser.image = UIImage(named: "User_Placeholder_ChatList")
            }
        } else {
            cell.ivUser.image = UIImage(named: "User_Placeholder_ChatList")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        nextVC.objChatUser = arrChatUserList[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK:- SOCKET EVENT HANDLER
extension MessengerVC
{
    func addHandlers() {
        SVProgressHUD.dismiss()
        //Socket connection events
        socket.on(clientEvent: .connect) { (data, ack) in
            self.getSocketChatUsers(intPage: self.pageNumber)
        }
        socket.on(clientEvent: .disconnect) { (data, ack) in
            SVProgressHUD.dismiss()
            print("Disconnected...")
        }
        socket.on(clientEvent: .error) { (data, ack) in
            print("error...")
            SVProgressHUD.dismiss()
        }
        socket.connect()
    }
    
}
