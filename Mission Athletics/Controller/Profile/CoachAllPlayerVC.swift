//
//  CoachAllPlayerVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 27/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

protocol CoachAllPlayerVC_Delegate: class {
    func scrollViewDidScroll(scrollView: UIScrollView, tableView: UIScrollView)
}

class CoachAllPlayerVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tblAllPlayer: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lbltitle: UILabel!
    
    weak var delegate: CoachAllPlayerVC_Delegate?
    @IBOutlet weak var scrollView : UIScrollView!

    var arrAllPlayer = [CoachMyPlayersArrModel]()
    var arrAllSearchPlayer = [CoachMyPlayersArrModel]()

    var Total_Videos = 0
    var PageOffset = 1
    var limit  = 10

    
    var isSearchActive = false
    var isFromView = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromView == "athlete"{
            lbltitle.text = "My Coach"
        }else if isFromView == "coachProfile_athlLogin"{
            lbltitle.text = "My Athlete"
        } else{
            
        }
        PageOffset = 1
        getAllSubscribeAthleteListAPICall()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- API Call
    func getAllSubscribeAthleteListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            if self.PageOffset == 1{
                ShowProgress()
            }
            
            var url = ""
            if isFromView == "athlete"{
                url = WebService.createURLForWebService(WebService.viewAllTrainers)
            }else{
                url = WebService.createURLForWebService(WebService.viewAllPlayers)
            }
            
            print(url)
            var reqParam:[String:Any] = [:]
            reqParam["page"] = PageOffset
            reqParam["limit"] = limit

            print(reqParam)
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CoachAllSubscribeAthleteModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            
                            if self.isFromView == "athlete"{
                                if self.PageOffset == 1{
                                    self.arrAllPlayer = []
                                    self.arrAllSearchPlayer = []

                                    self.arrAllPlayer = data.trainers ?? []
                                    self.arrAllSearchPlayer = data.trainers ?? []
                                }else{
                                    self.arrAllPlayer += data.trainers ?? []
                                    self.arrAllSearchPlayer += data.trainers ?? []
                                }
                            }else{
                                if self.PageOffset == 1{
                                    self.arrAllPlayer = []
                                    self.arrAllSearchPlayer = []

                                    self.arrAllPlayer = data.players ?? []
                                    self.arrAllSearchPlayer = data.players ?? []
                                }else{
                                    self.arrAllPlayer += data.players ?? []
                                    self.arrAllSearchPlayer += data.players ?? []
                                }
                            }
                           
                            if self.arrAllPlayer.count > 0 {
                                self.tblAllPlayer.restoreEmptyMessage()
                                self.tblAllPlayer.dataSource = self
                                self.tblAllPlayer.delegate = self
                                self.tblAllPlayer.reloadData()
                            }else{
                                self.tblAllPlayer.setEmptyMessage("No athlete found.")
                                self.tblAllPlayer.reloadData()
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
    
    
    //MARK:- UITableView datasource and delegate methods -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllPlayer.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachAllPlayerCell", for: indexPath) as! CoachAllPlayerCell
        
        let objAthlete = arrAllPlayer[indexPath.row]
        
        cell.lblPlayerName.text = objAthlete.name
        if let imgUrl = URL(string: objAthlete.image ?? "") {
            cell.imgProfile.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: { (image, error, cacheType, url) in
                if error != nil {
                    print(error!.localizedDescription)
                }
            })
        } else {
            cell.imgProfile.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
        }
        
        
        cell.btnViewProfile.tag = indexPath.row
        cell.btnViewProfile.addTarget(self, action: #selector(self.ViewUserProfileAction(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func ViewUserProfileAction(sender:UIButton){
        if self.arrAllPlayer.count > 0 {
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//coach
                    let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
                    nextVC.isFromOtherUser = true
                    nextVC.isFromCoachHomeList = true
                    nextVC.userId = arrAllPlayer[sender.tag].id ?? 0
                    self.navigationController?.pushViewController(nextVC, animated: true)

                }else{
                    if isFromView != "coachProfile_athlLogin"{
                        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                        nextVC.isFromOtherUser = true
                        nextVC.userId = arrAllPlayer[sender.tag].id ?? 0
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
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
            self.arrAllPlayer.removeAll()
            self.arrAllPlayer = arrAllSearchPlayer.filter({
                $0.name!.range(of: updatedTxt, options: .caseInsensitive) != nil
            })
        }else{
            self.arrAllPlayer = arrAllSearchPlayer
        }
        self.tblAllPlayer.reloadData()
        
        return true
    }
    
}
//MARK:- Scrollview method
//MARK:-
extension CoachAllPlayerVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: self.scrollView, tableView: self.scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if ((self.tblAllPlayer.contentOffset.y + self.tblAllPlayer.frame.size.height) >= tblAllPlayer.contentSize.height)
        {
            if self.arrAllPlayer.count < self.Total_Videos{
                AppData.showLoaderInFooter(on: self.tblAllPlayer)

                self.PageOffset += 1
                print("PAGination")
                self.getAllSubscribeAthleteListAPICall()
            }else{
                AppData.hideLoaderInFooter(on: self.tblAllPlayer)
            }
        }
    }
}
