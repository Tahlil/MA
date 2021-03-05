//
//  UpcomingSessionVC.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 17/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import ObjectMapper


class UpcomingSessionVC: UIViewController
{
    var isSelectedCell = -1
    
    @IBOutlet weak var vwCalender: FSCalendar!
    @IBOutlet weak var tblUpcomingList: UITableView!
    @IBOutlet weak var heightBookedTable: NSLayoutConstraint!
    
    var arrBookedSession = [Bookedsession]()
    var strDate = ""
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        if strDate != ""{
            GetBookedSessionAPICall(currentDate: strDate)
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "yyyy-MM-dd"
            dtFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            dtFormatter.locale = Locale.current
            let formatedStartDate = dtFormatter.date(from: strDate)
            
            vwCalender.setCurrentPage(formatedStartDate!, animated: false)
            vwCalender.select(formatedStartDate!, scrollToDate: false)
            vwCalender.reloadData()
        }else{
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "yyyy-MM-dd"
            dtFormatter.timeZone = .current
            let dtStr = dtFormatter.string(from: Date())
            GetBookedSessionAPICall(currentDate: dtStr)
        }

    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Check Bank Detail API Call
    func GetBookedSessionAPICall(currentDate:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            var url = ""
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//Coach
                    url = WebService.createURLForWebService(WebService.viewAllCoachBookedSession)
                }else{
                    url = WebService.createURLForWebService(WebService.viewAllBookedSession)
                }
            }
            
            var reqParam:[String:Any] = [:]
            reqParam["date"] = currentDate
            reqParam["limit"] = "10"
            reqParam["page"] = "1"

            print(url)
            print(reqParam)

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true{
                    HideProgress()
                    
                    if result?.contains("error") ?? false{
                        let mapData  = Mapper<TokenDetailsErorModel>().map(JSONString: result!)
                           
                        AlertView.showMessageAlert(mapData?.error?.message ?? "Something went wrong", viewcontroller: self)
                    }else{
                        let mapData  = Mapper<BookedSessionModel>().map(JSONString: result!)
                        
                        if mapData?.code == "200"{
                            self.arrBookedSession = mapData?.data?.bookedsession ?? []
                            
                            let tablCount = self.arrBookedSession.count
                            self.heightBookedTable.constant = CGFloat(70 * tablCount) + 55

                            self.tblUpcomingList.reloadData()

                        }else{
                            self.arrBookedSession = []
                            self.tblUpcomingList.setEmptyMessage("Session not found.")
                            self.tblUpcomingList.reloadData()
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
    
    func StartBookedSessionAPICall(strID:String,strSubID:String, strType:String, objSessionData:Bookedsession)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            //1= Accept, 2 = Cancel, 3 = Completed, 4= Reject
            let url = WebService.createURLForWebService(WebService.acceptCancelSessionRequest)
            var reqParam:[String:Any] = [:]
            if strType == "Accept"{
                reqParam["session_status"] = "1"
            }else{
                reqParam["session_status"] = "2"
            }
            reqParam["subscription_id"] = strSubID

            if objSessionData.subscriptionType == "free"{
                reqParam["athlete_subscription_id"] = strID
            }else{
                reqParam["booked_session_id"] = strID
            }
            
            
            print(url)
            print(reqParam)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true{
                    HideProgress()
                    
                    if result?.contains("error") ?? false{
                        let mapData  = Mapper<TokenDetailsErorModel>().map(JSONString: result!)
                        
                        AlertView.showMessageAlert(mapData?.error?.message ?? "Something went wrong", viewcontroller: self)
                    }else{
                        let mapData  = Mapper<BookedSessionModel>().map(JSONString: result!)
                        if strType == "Accept"{
                            let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "SessionLoadingVC") as! SessionLoadingVC
                            nextVC.objBookedSession = objSessionData
                            self.navigationController?.pushViewController(nextVC, animated: true)

                        }else{
                            let dtFormatter = DateFormatter()
                            dtFormatter.dateFormat = "yyyy-MM-dd"
                            dtFormatter.timeZone = .current
                            let dtStr = dtFormatter.string(from: Date())

                            AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                                self.GetBookedSessionAPICall(currentDate: dtStr)
                            })
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
//MARK:- Calendar datasource delegate methods

extension UpcomingSessionVC : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd"
        dtFormatter.timeZone = .current
        let dtStr = dtFormatter.string(from: date)
        isSelectedCell = -1
        GetBookedSessionAPICall(currentDate: dtStr)
    }
   
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let curDate = Date().addingTimeInterval(-24*60*60)
        if date < curDate {
            return false
        } else {
            return true
        }
    }
}

//MARK:- UITableView datasource delegate methods
extension UpcomingSessionVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBookedSession.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSelectedCell == indexPath.row{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingSelectedCell", for: indexPath) as! UpcomingSessionTimeCell
            
            let objDetails = arrBookedSession[indexPath.row]
            
            cell.lblTime.text = objDetails.bookingTime
            
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//Coach
                    if let userImgUrl = URL(string: objDetails.athleteImage ?? "") {
                        cell.imgUser.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
                    } else {
                        cell.imgUser.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                    }
                    cell.lblUserName.text = "with athlete \(objDetails.athleteName ?? "")"
                }else{
                    if let userImgUrl = URL(string: objDetails.coach_image ?? "") {
                        cell.imgUser.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
                    } else {
                        cell.imgUser.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                    }
                    cell.lblUserName.text = "with coach \(objDetails.coach_name ?? "")"
                }
            }
            cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height / 2
            cell.imgUser.clipsToBounds = true
            
//            cell.lblMessage.text = "Message: \(objDetails.m)"
            //1= Accept, 2 = Cancel, 3 = Completed, 4= Reject
            if objDetails.bookingStatus == 3{
                cell.btnStart.setTitle("Completed", for: .normal)
                cell.btnCancel.isHidden = true
            }else{
                cell.btnStart.setTitle("Start", for: .normal)
                cell.btnCancel.isHidden = false
            }
            
            cell.btnStart.tag = indexPath .row
            cell.btnStart.addTarget(self, action: #selector(self.startSessionAction(_:)), for: .touchUpInside)
            cell.btnCancel.tag = indexPath .row
            cell.btnCancel.addTarget(self, action: #selector(self.cancelSessionAction(_:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingSessionTimeCell", for: indexPath) as! UpcomingSessionTimeCell
            
            let objDetails = arrBookedSession[indexPath.row]
            
            cell.lblTime.text = objDetails.bookingTime
            
            
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//Coach
                    if let userImgUrl = URL(string: objDetails.athleteImage ?? "") {
                        cell.imgUser.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
                    } else {
                        cell.imgUser.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                    }
                }else{
                    if let userImgUrl = URL(string: objDetails.coach_image ?? "") {
                        cell.imgUser.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
                    } else {
                        cell.imgUser.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                    }
                }
            }
            
            cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height / 2
            cell.imgUser.clipsToBounds = true
            
            if indexPath.row == 0{
                if isSelectedCell + 1 == indexPath.row{
                    cell.lblTopLine.isHidden = true
                }
                if isSelectedCell - 1 == indexPath.row{
                    cell.lblBottomLine.isHidden = true
                }else{
                    cell.lblTopLine.isHidden = true
                }
            }else if indexPath.row == 9{
                cell.lblBottomLine.isHidden = true
            }else if isSelectedCell + 1 == indexPath.row{
                cell.lblTopLine.isHidden = true
            }else if isSelectedCell - 1 == indexPath.row{
                cell.lblBottomLine.isHidden = true
            }else{
                cell.lblTopLine.isHidden = false
                cell.lblBottomLine.isHidden = false
            }
            if indexPath.row == arrBookedSession.count - 1{
                cell.lblBottomLine.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tablCount = self.arrBookedSession.count

        if isSelectedCell == indexPath.row{
            isSelectedCell = -1
            self.heightBookedTable.constant = CGFloat(70 * tablCount) + 55
        }else{
            isSelectedCell = indexPath.row
            self.heightBookedTable.constant = CGFloat(70 * tablCount) + 200
        }
        tblUpcomingList.reloadData()
    }
    
    //MARK:- IBActions
    @IBAction func startSessionAction(_ sender: UIButton)
    {
        let objDetails = arrBookedSession[sender.tag]
        if objDetails.bookingStatus != 3{
            StartBookedSessionAPICall(strID: "\(objDetails.id ?? 0)", strSubID: "\(objDetails.subscriptionId ?? 0)", strType: "Accept", objSessionData: objDetails)
        }
    }
    
    @IBAction func cancelSessionAction(_ sender: UIButton)
    {
        AlertView.showAlert("", strMessage: "Are you sure you want to cancel the session?", button: ["Yes","No"], viewcontroller: self, blockButtonClicked: { (button) in
            if button == 0{
                let objDetails = self.arrBookedSession[sender.tag]
                self.StartBookedSessionAPICall(strID: "\(objDetails.id ?? 0)", strSubID: "\(objDetails.subscriptionId ?? 0)", strType: "Cancel", objSessionData: objDetails)
            }
        })
    }
}
