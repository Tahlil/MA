//
//  FriendsListVC.swift
//  Mission Athletics
//
//  Created by Mac on 11/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SDWebImage

class FriendsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tvFriends: UITableView!
    @IBOutlet weak var btnAddFriend: UIButton!
    
    var friendsDictionary = [String: [FriendListDataModel]]()
    var friendSectionTitles = [String]()
    var friends = [String]()
    var arrFriendList = [FriendListDataModel]()
    var isSearchActive = false
    var isViewFrom = ""
    var friendsDictionarySearch = [String: [FriendListDataModel]]()
    var friendSectionTitlesSearch = [String]()
    var friendsSearch = [String]()
    var arrFriendListSearch = [FriendListDataModel]()
    var selectedFriendObj = FriendListDataModel()

    //MARK:- Viewlifecycle methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isViewFrom == "CoachProfile"{
            btnAddFriend.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigateToChatRoom(notification:)), name: Notification.Name("navigateToChatRoom"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        getFriendListAPICall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
                }
            } else {
                friendsDictionary[friendKey] = [friend]
            }
        }
        
        friendSectionTitles = [String](friendsDictionary.keys)
        friendSectionTitles = friendSectionTitles.sorted(by: { $0 < $1 })
        
        self.tvFriends.dataSource = self
        self.tvFriends.delegate = self
        self.tvFriends.tableFooterView = UIView()
        self.tvFriends.reloadData()
        self.tvFriends.sectionIndexColor = UIColor.appBlueColor
    }

    //MARK:- objc methods -
    @objc func navigateToChatRoom(notification: Notification)
    {
        if let msg = notification.object as? String {
            let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
            nextVC.isFromCompose = true
            nextVC.composeMsg = msg
            nextVC.userDataFrnd = self.selectedFriendObj
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //MARK:- IBActions -
    @IBAction func btnAddFriends(_ sender: UIButton) {
        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "AllFriendsVC") as! AllFriendsVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }

    //MARK:- UITableView datasource and delegate methods -
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
        
        if self.isSearchActive {
            let friendKey = friendSectionTitlesSearch[indexPath.section]
            if let friendValues = friendsDictionarySearch[friendKey] {
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
                }
            }
        } else {
            let friendKey = friendSectionTitles[indexPath.section]
            if let friendValues = friendsDictionary[friendKey] {
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
                }
            }
        }
        
        cell.btnViewProfile.section = indexPath.section
        cell.btnViewProfile.row = indexPath.row
        cell.btnViewProfile.addTarget(self, action: #selector(self.btnViewUserProfileAction(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
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
        
       // var strID: Int?
        
        let friendKey = self.isSearchActive == true ? friendSectionTitlesSearch[indexPath.section] : friendSectionTitles[indexPath.section]
        if let friendValues = self.isSearchActive == true ? friendsDictionarySearch[friendKey] : friendsDictionary[friendKey] {
            if friendValues.count > 0 {
                
                self.selectedFriendObj = friendValues[indexPath.row]
               // strID = friendValues[indexPath.row].id
                if isViewFrom == "CoachProfile"{
                }else{
                    if friendValues[indexPath.row].isChatCreated == 0 {
                        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                        nextVC.isFromCompose = true
                        nextVC.userDataFrnd = self.selectedFriendObj
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                        nextVC.isFromCompose = true
                        nextVC.userDataFrnd = self.selectedFriendObj
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }

                }
            }
        }
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
    
    //MARK:- UITextfield delegate methods -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
            self.friendsSearch.removeAll()
            
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
        
        self.tvFriends.reloadData()
        
        return true
    }
    
    //MARK:- API Call -
    func getFriendListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getFriends)
            print(url)
            
            let userData = getUserInfo()
            let strUserType = "\(String(describing: userData?.user_type ?? 0))"
            //1AllUser 2My friend
            let param:Parameters = ["user_type":strUserType,"friend_type": FriendType.MyFriends.rawValue]//"2"]
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<FriendListModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.arrFriendList = data
                            
                            if self.arrFriendList.count > 0 {
                                self.setResponseData()
                                self.tvFriends.dataSource = self
                                self.tvFriends.delegate = self
                                self.tvFriends.reloadData()
                            } else {
                                self.tvFriends.setEmptyMessage("Friends not found.")
                                self.tvFriends.reloadData()
                            }
                        }
                        print("success")
                    }else{
                        if self.arrFriendList.count == 0 {
                            self.tvFriends.setEmptyMessage("Friends not found.")
                            self.tvFriends.reloadData()
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
}
