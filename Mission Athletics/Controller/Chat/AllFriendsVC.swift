//
//  AllFriendsVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 09/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SDWebImage

class AllFriendsVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblFriendList: UITableView!
    
    var friendsDictionary = [String: [FriendListDataModel]]()
    var friendSectionTitles = [String]()
    var arrFriendList = [FriendListDataModel]()
    var isSearchActive = false
    var friendsDictionarySearch = [String: [FriendListDataModel]]()
    var friendSectionTitlesSearch = [String]()
    var arrFriendListSearch = [FriendListDataModel]()
    
    //MARK:- Viewlifecycle methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                self.lblTitle.text = "All Coaches"//"All Friends"
            } else {
                self.lblTitle.text = "All Athletes"
            }
        }
        
        getFriendListAPICall(isFromView: true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    func setResponseData()
    {
        for friend in arrFriendList {
            let friendName = friend.name ?? ""
            
            let friendKey = String(friendName.prefix(1).uppercased())
            if var friendValues = friendsDictionary[friendKey] {
                
                var names = [String]()
                for value in friendValues {
                    names.append(value.name!)
                }
                
                if !names.contains(friendName) {
                    friendValues.append(friend)
                    friendsDictionary[friendKey] = friendValues
                } else {
                    friendsDictionary[friendKey] = [friend]
                }
            } else {
                friendsDictionary[friendKey] = [friend]
            }
        }
        
        friendSectionTitles = [String](friendsDictionary.keys)
        friendSectionTitles = friendSectionTitles.sorted(by: { $0 < $1 })
        
        self.tblFriendList.dataSource = self
        self.tblFriendList.delegate = self
        self.tblFriendList.tableFooterView = UIView()
        self.tblFriendList.reloadData()
        self.tblFriendList.sectionIndexColor = UIColor.appBlueColor
    }
    
    //MARK:- Button Actions
    
    
    //MARK:- UITextfield delegate methods -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space
        
        var updatedTxt = ""
        if let text = textField.text, let textRange = Range(range, in: text)
        {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            updatedTxt = updatedText
        }
        
        if let char = string.cString(using: String.Encoding.utf8)
        {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                if updatedTxt != "" {
                    self.isSearchActive = true
                } else {
                    self.isSearchActive = false
                }
            } else {
                if updatedTxt != "" {
                    self.isSearchActive = true
                } else {
                    self.isSearchActive = false
                }
            }
        }
        
        if self.isSearchActive {
            self.friendsDictionarySearch.removeAll()
            self.friendSectionTitlesSearch.removeAll()
            self.arrFriendListSearch.removeAll()
            
            let matchingTerms = arrFriendList.filter({
                $0.name!.range(of: updatedTxt, options: .caseInsensitive) != nil
            })
        
            if matchingTerms.count > 0 {
                for friend in matchingTerms
                {
                    let friendName = friend.name ?? ""
                    let friendKey = String(friend.name!.prefix(1).uppercased())
                    if var friendValues = friendsDictionarySearch[friendKey] {
                        
                        var names = [String]()
                        for value in friendValues {
                            names.append(value.name!)
                        }
                        
                        if !names.contains(friendName) {
                            friendValues.append(friend)
                            friendsDictionarySearch[friendKey] = friendValues
                        } else {
                            friendsDictionarySearch[friendKey] = [friend]
                        }
                    } else {
                        friendsDictionarySearch[friendKey] = [friend]
                    }
                }
                friendSectionTitlesSearch = [String](friendsDictionarySearch.keys)
                friendSectionTitlesSearch = friendSectionTitlesSearch.sorted(by: { $0 < $1 })
            }
        } else {
        }
        
        self.tblFriendList.reloadData()
        
        return true
    }
}

//MARK:- UITableView datasource and delegate methods -
extension AllFriendsVC:UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isSearchActive {
            return friendSectionTitlesSearch.count
        } else {
            return friendSectionTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearchActive {
            let friendKey = friendSectionTitlesSearch[section]
            if let friendValues = friendsDictionarySearch[friendKey] {
                return friendValues.count
            }
        } else {
            let friendKey = friendSectionTitles[section]
            if let friendValues = friendsDictionary[friendKey] {
                return friendValues.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsListCell", for: indexPath) as! FriendsListCell
        
        var frndObj = FriendListDataModel()
        
        let friendKey = self.isSearchActive == true ? friendSectionTitlesSearch[indexPath.section] : friendSectionTitles[indexPath.section]
        if let friendValues = self.isSearchActive == true ? friendsDictionarySearch[friendKey] : friendsDictionary[friendKey] {
            if friendValues.count > 0 {
                cell.lblUserName.text = friendValues[indexPath.row].name
                
                if let imgUrl = URL(string: friendValues[indexPath.row].userimage ?? "") {
                    cell.ivUser.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: { (image, error, cacheType, url) in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    })
                } else {
                    cell.ivUser.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                }
                
                frndObj = friendValues[indexPath.row]
            }
        }
        
        if let reqStatus = frndObj.request_status {
            if reqStatus == 0 {
                cell.btnFollowing.setTitle("Send Request", for: .normal)
                cell.btnFollowing.setTitleColor(UIColor.blueGradientDark, for: .normal)
                cell.btnFollowing.borderColor = UIColor.blueGradientDark
            } else if reqStatus == 1 {
                cell.btnFollowing.setTitle("Request Sent", for: .normal)
                cell.btnFollowing.setTitleColor(UIColor.appOrangeColor, for: .normal)
                cell.btnFollowing.borderColor = UIColor.appOrangeColor
            } else if reqStatus == 3 {
                cell.btnFollowing.setTitle("Respond", for: .normal)
                cell.btnFollowing.setTitleColor(UIColor(red: 42/255, green: 90/255, blue: 255/255, alpha: 1.0), for: .normal)
                cell.btnFollowing.borderColor = UIColor(red: 42/255, green: 90/255, blue: 255/255, alpha: 1.0)
            }
        }
        
        cell.btnFollowing.row = indexPath.row
        cell.btnFollowing.section = indexPath.section
        cell.btnFollowing.addTarget(self, action: #selector(SendFriendRequest(sender:)), for: .touchUpInside)
        
        cell.btnViewProfile.section = indexPath.section
        cell.btnViewProfile.row = indexPath.row
        cell.btnViewProfile.addTarget(self, action: #selector(self.btnViewUserProfileAction(_:)), for: .touchUpInside)

        cell.selectionStyle = .none
        return cell
    }
    @IBAction func btnViewUserProfileAction(_ sender: MyButton)
    {
        var userID: Int = 0
        
        let friendKey = self.isSearchActive == true ? friendSectionTitlesSearch[sender.section] : friendSectionTitles[sender.section]
        if let friendValues = self.isSearchActive == true ? friendsDictionarySearch[friendKey] : friendsDictionary[friendKey] {
            if friendValues.count > 0 {
                if let id = friendValues[sender.row].id {
                    userID = id
                }
            }
        }
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                nextVC.isFromOtherUser = true
                nextVC.userId = userID
                self.navigationController?.pushViewController(nextVC, animated: true)
            } else {
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
                nextVC.isFromOtherUser = true
                nextVC.userId = userID
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.isSearchActive {
            return friendSectionTitlesSearch
        } else {
            return friendSectionTitles
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func SendFriendRequest(sender:MyButton) {
        self.view.endEditing(true)
        
        var strID: Int?
        
        let friendKey = self.isSearchActive == true ? friendSectionTitlesSearch[sender.section] : friendSectionTitles[sender.section]
        if let friendValues = self.isSearchActive == true ? friendsDictionarySearch[friendKey] : friendsDictionary[friendKey] {
            if friendValues.count > 0 {
                if let id = friendValues[sender.row].id {
                    strID = id
                }
                
                if let reqStatus = friendValues[sender.row].request_status {
                    if reqStatus == 3 {
                        if let chatId = friendValues[sender.row].chat_id, let notifId = friendValues[sender.row].notification_id {
                            self.ChooseActionToRespondRequest(chatId: chatId, notifId: notifId)
                        }
                    } else {
                        SendFriendRequestAPICall(strUserID: "\(strID ?? 0)")
                    }
                }
            }
        }
    }
    
    func ChooseActionToRespondRequest(chatId: Int, notifId: Int)
    {
        let alert = UIAlertController(title: "Select action to respond friend request", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
            self.AcceptRejectRequestAPICall(reqStatus: ChatRequest.Accept.rawValue, chatId: "\(chatId)", notifiId: "\(notifId)")
        }))
        
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
            self.AcceptRejectRequestAPICall(reqStatus: ChatRequest.Reject.rawValue, chatId: "\(chatId)", notifiId: "\(notifId)")
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- API Call -
extension AllFriendsVC
{
    func getFriendListAPICall(isFromView: Bool)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getFriends)
            print(url)
            let userData = getUserInfo()
            
            let strUserType = "\(String(describing: userData?.user_type ?? 0))"
//            var frindType = ""
//            if strUserType == "2"{
//                frindType = "1"
//            }else{
//                frindType = "2"
//            }
            
            let param:Parameters = ["user_type":strUserType,"friend_type": FriendType.AllUser.rawValue]//"1"]
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<FriendListModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.arrFriendList = [FriendListDataModel]()
                            self.arrFriendList = data
                            
                            if self.arrFriendList.count > 0 {
                                self.setResponseData()
                                if isFromView {
                                    self.tblFriendList.dataSource = self
                                    self.tblFriendList.delegate = self
                                    self.tblFriendList.reloadData()
                                } else {
                                    self.tblFriendList.reloadData()
                                }
                            } else {
                                if let userData = getUserInfo() {
                                    if userData.user_type == 2 {//Coach
                                        self.tblFriendList.setEmptyMessage("Coaches not found.")
                                    } else {
                                        self.tblFriendList.setEmptyMessage("Athletes not found.")
                                    }
                                }
                                self.tblFriendList.reloadData()
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
    
    //MARK: Send Friend Request
    func SendFriendRequestAPICall(strUserID:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.sendFriendRequest)
            print(url)
            
            let param:Parameters = ["receiver_id":strUserID]
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<FriendListModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        self.getFriendListAPICall(isFromView: false)
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

    //MARK: Accept Reject API Call
    func AcceptRejectRequestAPICall(reqStatus: String, chatId: String, notifiId: String)
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
                        AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                            
                            if reqStatus == "1" {
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                                    self.getFriendListAPICall(isFromView: false)
                                    self.SeenNotificationAPICall(notifID: notifiId)
                                }
                            }
                        })
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
    func SeenNotificationAPICall(notifID:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.seenNotification)
            print(url)
            
            let param:Parameters = ["notification_id":notifID]
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<FriendListModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        print("Seen notification successfully from all users list")
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
