//
//  ScheduleSessionVC.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 13/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import FSCalendar

class ScheduleSessionVC: UIViewController
{
    var selectedDateIndex = -1
    var isTimePickSelect = -1
    var selectedTimeSlot = ""
    var reqSessionParam:[String:Any] = [:]
    var strSelectedDate = ""
    var isFromView = ""
    var arrTimeSlot = [ManageSlotListModel]()
    var arrDateSlot = [[String:Any]]()

    @IBOutlet weak var collDatePickup: UICollectionView!
    @IBOutlet weak var tblTimeSlots: UITableView!
    @IBOutlet weak var heightTableview: NSLayoutConstraint!
    @IBOutlet weak var topAvailableTimSlot: NSLayoutConstraint!
    @IBOutlet weak var topAvailableDates: NSLayoutConstraint!
    @IBOutlet weak var vwConfirmationPopup: UIView!
    @IBOutlet weak var vwSessionBookedPopup: UIView!
    @IBOutlet weak var lblSubSessionDuration: UILabel!
    @IBOutlet weak var vwConfirmSubPopup: UIView!
    @IBOutlet weak var scrollviewMain: UIScrollView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vwCalendar: FSCalendar!
    @IBOutlet weak var lblTimeSlotTitle: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!

    
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth:CGFloat = UIScreen.main.bounds.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: (screenWidth - 70)/4, height: screenWidth/4.0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collDatePickup.collectionViewLayout = layout
        
        if isFromView == "Coach"{
            self.btnBack.setImage(#imageLiteral(resourceName: "red_left"), for: .normal)
            lblTimeSlotTitle.text = "Select Timeslot(s)"
            lblHeaderTitle.text = "Set Unavailability"
        }
        
        heightTableview.constant = 0
        SelectedDateForNext10Days(strDate: Date())
    }
    
    func SelectedDateForNext10Days(strDate:Date){
        arrDateSlot = []
        for index in 0..<10 {
            
            var tenDaysfromNow: Date {
                return (Calendar.current as NSCalendar).date(byAdding: .day, value: index, to: strDate, options: [])!
            }
            
            let dtF = DateFormatter()
            dtF.dateFormat = "dd"
            dtF.timeZone = .current
            let dtStr = dtF.string(from: tenDaysfromNow)
            
            let dttF = DateFormatter()
            dttF.dateFormat = "MMM"
            dttF.timeZone = .current
            let moStr = dttF.string(from: tenDaysfromNow)
            
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "yyyy-MM-dd"
            dtFormatter.timeZone = .current
            strSelectedDate = dtFormatter.string(from:Date())

            arrDateSlot.append(["date":dtStr,"month":moStr,"fullDate":tenDaysfromNow])
        }
        collDatePickup.reloadData()
    }
    
    //MARK:- IBActions
    //MARK:-
    
    @IBAction func btnConfirm(_ sender: UIButton) {
        if isFromView == "Coach"{
            var strTimeSlot = [String]()
            for slot in arrTimeSlot{
                if slot.isSelected!{
                    strTimeSlot.append(slot.time ?? "")
                }else if slot.is_available == 0{
                    strTimeSlot.append(slot.time ?? "")
                }
            }
            if strSelectedDate == "" || strTimeSlot.count == 0{
                AlertView.showMessageAlert("Please select date and timeslot.", viewcontroller: self)
            }else{

                SetUnavailibityAPICall()
            }
        }else{
            if strSelectedDate == "" || selectedTimeSlot == ""{
                AlertView.showMessageAlert("Please select date and timeslot.", viewcontroller: self)
            }else{
                vwConfirmSubPopup.isHidden = false
                vwSessionBookedPopup.isHidden = true
                vwConfirmationPopup.isHidden = false
            }
        }
    }
    
    //Confirm Popup
    @IBAction func btnPopupCofirm(_ sender: UIButton) {
        BookSessionAPICall()
    }
    
    @IBAction func btnNeverMind(_ sender: UIButton) {
        vwConfirmationPopup.isHidden = true
    }
    
    //Booked Session
    @IBAction func btnScheduleSession(_ sender: UIButton) {
    }
    
    @IBAction func btnScheduleLater(_ sender: UIButton) {
        vwConfirmationPopup.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        if isTimePickSelect != -1{
            print("time")
            isTimePickSelect = -1
            selectedTimeSlot = ""

            if selectedDateIndex != -1{
                topAvailableTimSlot.constant = 380
                self.btnBack.setImage(#imageLiteral(resourceName: "red_left"), for: .normal)
            }else{
                topAvailableTimSlot.constant = 690
                self.btnBack.setImage(#imageLiteral(resourceName: "can_red"), for: .normal)
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }

            tblTimeSlots.reloadData()
        }else if selectedDateIndex != -1{
            print("select")
            selectedDateIndex = -1
            strSelectedDate = ""
            topAvailableDates.constant = 305
            topAvailableTimSlot.constant = 690
            btnBack.setImage(#imageLiteral(resourceName: "can_red"), for: .normal)
            heightTableview.constant = 0
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }

            collDatePickup.reloadData()
        }else{
            print("other")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Check Bank Detail API Call
    func GetTimeSlotAPICall(currentDate:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.manageTimeSlot)
            
            print(url)
            
            var reqParam:[String:Any] = [:]
            reqParam = reqSessionParam
            reqParam["date"] = currentDate

            print(reqParam)

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    if result?.contains("error") ?? false{
                        let mapData  = Mapper<TokenDetailsErorModel>().map(JSONString: result!)
                        
                        AlertView.showMessageAlert(mapData?.error?.message ?? "Something went wrong", viewcontroller: self)
                        
                    }else{
                        let mapData  = Mapper<ManageSloatModel>().map(JSONString: result!)
                        self.arrTimeSlot = mapData?.data?.timeSlot ?? []
                                                
                        let tablCount = self.arrTimeSlot.count
                        self.heightTableview.constant = CGFloat(60 * tablCount) + 50
                        if self.selectedDateIndex != -1{
                            self.topAvailableTimSlot.constant = 380
                            self.btnBack.setImage(#imageLiteral(resourceName: "red_left"), for: .normal)
                        }else{
                            self.topAvailableTimSlot.constant = 690
                            self.btnBack.setImage(#imageLiteral(resourceName: "can_red"), for: .normal)
                        }
                        UIView.animate(withDuration: 0.5) {
                            self.view.layoutIfNeeded()
                        }

                        self.tblTimeSlots.reloadData()
                    }
                }else{
                    HideProgress()
                }
            }
        }else{
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
    //Book Session
    func BookSessionAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.sessionCoach)
            
            print(url)
            
            var reqParam:[String:Any] = [:]
            reqParam = reqSessionParam
            reqParam["date"] = strSelectedDate
            reqParam["time"] = selectedTimeSlot
            reqParam["sport_id"] = "1"
            print(reqParam)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    if result?.contains("error") ?? false{
                        let mapData  = Mapper<TokenDetailsErorModel>().map(JSONString: result!)
                        self.vwConfirmSubPopup.isHidden = true
                        self.vwSessionBookedPopup.isHidden = false
                        
                        AlertView.showMessageAlert(mapData?.error?.message ?? "Something went wrong", viewcontroller: self)
                        
                    }else{
                        let mapData  = Mapper<ManageSloatModel>().map(JSONString: result!)
                        if mapData?.code == "200"{
                            AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self) { (action) in
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }else{
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
    //Set unvailability coach
    func SetUnavailibityAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.addUnavailability)
            print(url)
            
            var strTimeSlot = [String]()
            for slot in arrTimeSlot{
                if slot.isSelected!{
                    strTimeSlot.append(slot.time ?? "")
                }else if slot.is_available == 0{
                    strTimeSlot.append(slot.time ?? "")
                }
            }
            
            var reqParam:[String:Any] = [:]
            reqParam = reqSessionParam
            reqParam["date"] = strSelectedDate
            reqParam["time_slot"] = strTimeSlot

            print(reqParam)

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    if result?.contains("error") ?? false{
                        let mapData  = Mapper<TokenDetailsErorModel>().map(JSONString: result!)
                        AlertView.showMessageAlert(mapData?.error?.message ?? "Something went wrong", viewcontroller: self)
                    }else{
                        let mapData  = Mapper<ManageSloatModel>().map(JSONString: result!)
                        if mapData?.code == "200"{
                            self.GetTimeSlotAPICall(currentDate: self.strSelectedDate)
                        }else{
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
}
//MARK:- Calendar datasource delegate methods
//MARK:-
extension ScheduleSessionVC : FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        SelectedDateForNext10Days(strDate: date)
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


//MARK:- UICollectionView datasource delegate methods
//MARK:-
extension ScheduleSessionVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDateSlot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookSessionPickupDateCell", for: indexPath) as! BookSessionPickupDateCell
        
        let objData = arrDateSlot[indexPath.row]
        cell.setBookSessionPickupDetails(objData: objData)
        
        if selectedDateIndex == indexPath.row{
            cell.vwBackground.backgroundColor = UIColor.init(hexString: "209CD0")
            cell.lblMonth.textColor = UIColor.white
            cell.lblDate.textColor = UIColor.white
        }else{
            cell.vwBackground.backgroundColor = UIColor.white
            cell.lblMonth.textColor = UIColor.init(hexString: "209CD0")
            cell.lblDate.textColor = UIColor.init(hexString: "209CD0")
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if selectedDateIndex == indexPath.row{
            selectedDateIndex = -1
            topAvailableDates.constant = 305
            topAvailableTimSlot.constant = 690
            btnBack.setImage(#imageLiteral(resourceName: "can_red"), for: .normal)
            heightTableview.constant = 0
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }else{
            let tablCount = arrTimeSlot.count
            heightTableview.constant = CGFloat(60 * tablCount) + 50
            
            btnBack.setImage(#imageLiteral(resourceName: "red_left"), for: .normal)
            selectedDateIndex = indexPath.row
            topAvailableDates.constant = 0
            topAvailableTimSlot.constant = 390
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            let objData = arrDateSlot[indexPath.row]
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "yyyy-MM-dd"
            dtFormatter.timeZone = .current
            let dtStr = dtFormatter.string(from: objData["fullDate"] as? Date ?? Date())
            strSelectedDate = dtStr
            GetTimeSlotAPICall(currentDate: dtStr)
        }
        collDatePickup.reloadData()
    }
}

//MARK:- UITableview delegate and datasource
//MARK:-
extension ScheduleSessionVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTimeSlot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickupTimeCell", for: indexPath) as! PickupTimeCell
        
        let objTime = arrTimeSlot[indexPath.row]
        cell.lblTime.text = objTime.time
        
        if objTime.is_available == 0{
            cell.vwTimeView.backgroundColor = UIColor.white
            cell.vwConfirm.backgroundColor = UIColor.init(hexString: "E9E9E9")
            cell.lblTime.textColor = UIColor.init(hexString: "B4D8E7")
            cell.imgSelect.image = #imageLiteral(resourceName: "slider_dot_fill")

        }else{
            cell.lblTime.textColor = UIColor.init(hexString: "209CD0")
            
            if isFromView == "Coach"{
                if arrTimeSlot[indexPath.row].isSelected == true{
                    cell.vwTimeView.backgroundColor = UIColor.init(hexString: "209CD0")
                    cell.vwConfirm.backgroundColor = UIColor.init(hexString: "2ABF26")
                    
                    cell.lblTime.textColor = UIColor.white
                    cell.imgSelect.image = #imageLiteral(resourceName: "slider_dot_fill")

                }else{
                    cell.vwTimeView.backgroundColor = UIColor.white
                    cell.vwConfirm.backgroundColor = UIColor.init(hexString: "BFBFBF")
                    
                    cell.lblTime.textColor = UIColor.init(hexString: "209CD0")
                    cell.imgSelect.image = #imageLiteral(resourceName: "slider_dot_outline")
                }
            }else{
                if isTimePickSelect == indexPath.row{
                    cell.vwTimeView.backgroundColor = UIColor.init(hexString: "209CD0")
                    cell.vwConfirm.backgroundColor = UIColor.init(hexString: "2ABF26")
                    
                    cell.lblTime.textColor = UIColor.white
                    cell.imgSelect.image = #imageLiteral(resourceName: "slider_dot_fill")
                }else{
                    cell.vwTimeView.backgroundColor = UIColor.white
                    cell.vwConfirm.backgroundColor = UIColor.init(hexString: "BFBFBF")
                    
                    cell.lblTime.textColor = UIColor.init(hexString: "209CD0")
                    cell.imgSelect.image = #imageLiteral(resourceName: "slider_dot_outline")
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if arrTimeSlot[indexPath.row].is_available != 0{
            if isFromView == "Coach"{
                
                if arrTimeSlot[indexPath.row].isSelected == true{
                    arrTimeSlot[indexPath.row].isSelected = false
                    if selectedDateIndex != -1{
                        topAvailableTimSlot.constant = 380
                        self.btnBack.setImage(#imageLiteral(resourceName: "red_left"), for: .normal)
                    }else{
                        topAvailableTimSlot.constant = 690
                        self.btnBack.setImage(#imageLiteral(resourceName: "can_red"), for: .normal)
                    }
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }else{
                    arrTimeSlot[indexPath.row].isSelected = true
                    topAvailableTimSlot.constant = 0
                    self.btnBack.setImage(#imageLiteral(resourceName: "red_left"), for: .normal)
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            }else{
                if isTimePickSelect == indexPath.row{
                    isTimePickSelect = -1
                    selectedTimeSlot = ""
                    if selectedDateIndex != -1{
                        topAvailableTimSlot.constant = 380
                        self.btnBack.setImage(#imageLiteral(resourceName: "red_left"), for: .normal)
                    }else{
                        topAvailableTimSlot.constant = 690
                        self.btnBack.setImage(#imageLiteral(resourceName: "can_red"), for: .normal)
                    }
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }else{
                    selectedTimeSlot = arrTimeSlot[indexPath.row].time ?? ""
                    isTimePickSelect = indexPath.row
                    topAvailableTimSlot.constant = 0
                    self.btnBack.setImage(#imageLiteral(resourceName: "red_left"), for: .normal)
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
            tblTimeSlots.reloadData()
        }
    }
}
