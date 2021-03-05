//
//  AddCardBankDetailsVC.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 14/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import ObjectMapper
import SwiftValidators
import UIKit

class AddCardBankDetailsVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCVVNumber: UITextField!

    
    let arrMonths = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var arrYears = [String]()
    var selectedMonth = 0
    var selectedYear = 0
    var strBankID = 0
    let datePicker = UIPickerView()
    
    // MARK: - ViewLifecycle methods -
    override func viewDidLoad() {
        super.viewDidLoad()

        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "MM/yyyy"
        dtFormatter.timeZone = .current
        let dtStr = dtFormatter.string(from: Date())
        
        if let year = dtStr.components(separatedBy: "/").last {
            for i in 0..<51
            {
                let updatedYear = (Int(year) ?? 0) + i
                self.arrYears.append("\(updatedYear)")
            }
        }
       // print(self.arrYears)
        
        datePicker.dataSource = self
        datePicker.delegate = self
        self.txtExpiryDate.inputView = datePicker
        self.txtExpiryDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.handleDoneButtonExpiryfield(sender:)))
        // Do any additional setup after loading the view.
        
        CheckBankDetailAPICall()
    }
    
    //MARK:- objc functions
    @objc func handleDoneButtonExpiryfield(sender: Any)
    {
        self.txtExpiryDate.text = "\(self.arrMonths[self.selectedMonth])/\(self.arrYears[self.selectedYear])"
    }
    
    // MARK: - IBActions -
    @IBAction func btnEditAction(_ sender: UIButton)
    {
        self.makeFieldsEditable(bool: true)
        self.btnEdit.isHidden = true
    }
    
    @IBAction func btnSaveChangesAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.isValidate() {
            self.AddBankDetailAPICall()
        }
    }

    //MARK:- UITextfield delegate methods -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }
        if textField == txtCardNumber{
            if (self.txtCardNumber.text!.count > 19 && range.length == 0){
                return false
            }
        }
        if textField == txtCardHolderName{
            if (self.txtCardHolderName.text!.count > 50 && range.length == 0){
                return false
            }
        }
        if textField == txtCVVNumber{
            if (self.txtCVVNumber.text!.count > 3 && range.length == 0){
                return false
            }
        }
        return true
    }
    
    //MARK:- API Call -
    //MARK: Check Bank Detail API Call
    func CheckBankDetailAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.checkBankDetail)
            print(url)
            
            var reqParam:[String:Any] = [:]
            if let userData = getUserInfo() {
                reqParam["user_id"] = "\(userData.id ?? 0)"
            }
            
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
                                    self.makeFieldsEditable(bool: true)
                                    self.btnEdit.isHidden = true
                                    
                                    self.txtCardNumber.text = ""
                                    self.txtCardHolderName.text = ""
                                    self.txtExpiryDate.text = ""
                                    self.txtCVVNumber.text = ""
                                } else {
                                    self.makeFieldsEditable(bool: false)
                                    self.btnEdit.isHidden = false
                                    
                                    self.txtCardNumber.text = "\(data.bankDetail?.card_number ?? "")"
                                    self.txtCardHolderName.text = data.bankDetail?.account_name ?? ""
                                    self.txtExpiryDate.text = data.bankDetail?.expiry_date ?? ""
                                    self.strBankID = data.bankDetail?.id ?? 0
                                    if self.txtExpiryDate.text != "" {
                                        let expiryCompo = self.txtExpiryDate.text?.components(separatedBy: "/")
                                        let month = expiryCompo?.first ?? ""
                                        let year = expiryCompo?.last ?? ""
                                        
                                        for i in 0..<self.arrMonths.count {
                                            if self.arrMonths[i] == month {
                                                self.datePicker.selectRow(i, inComponent: 0, animated: true)
                                                break
                                            }
                                        }
                                        for i in 0..<self.arrYears.count {
                                            if self.arrYears[i] == year {
                                                self.datePicker.selectRow(i, inComponent: 1, animated: true)
                                            }
                                        }
                                    }
                                    self.txtCVVNumber.text = ""
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
    func AddBankDetailAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.addBankDetails)
            print(url)
            
            var reqParam:[String:Any] = [:]
            reqParam["account_name"] = self.txtCardHolderName.text!
            reqParam["card_number"] = self.txtCardNumber.text!
            reqParam["expiry_date"] = self.txtExpiryDate.text!
            reqParam["cvv"] = self.txtCVVNumber.text!
            if strBankID != 0{
                reqParam["bank_id"] = "\(strBankID)"
            }else{
                reqParam["bank_id"] = ""
            }
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<AddCoachBankDetailResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            if let flag = mapData?.flag {
                                if flag == 0 {
                                    self.makeFieldsEditable(bool: true)
                                } else {
                                    self.makeFieldsEditable(bool: false)
                                    self.btnEdit.isHidden = false
                                    self.txtCardNumber.text = "\(data.card_number ?? "")"
                                    self.txtCardHolderName.text = data.account_name ?? ""
                                    self.txtExpiryDate.text = data.expiry_date ?? ""
                                    self.txtCVVNumber.text = ""
                                    self.strBankID = data.id ?? 0
                                    AlertView.showMessageAlert(mapData?.message ?? "", viewcontroller: self)

                                }
                            }
                        }
                        print("success")
                    }else{
                        AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
                    }
                }else{
                    HideProgress()
                    AlertView.showMessageAlert("Something went wrong", viewcontroller: self)
                }
            }
        }else{
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
    
    //MARK:- Custom helper methods
    func makeFieldsEditable(bool: Bool)
    {
        self.txtCardNumber.isUserInteractionEnabled = bool
        self.txtCardHolderName.isUserInteractionEnabled = bool
        self.txtExpiryDate.isUserInteractionEnabled = bool
        self.txtCVVNumber.isUserInteractionEnabled = bool
    }
    
    func isValidate() -> Bool {
        if !Validator.required().apply(self.txtCardNumber.text!) {
            AlertView.showMessageAlert("Please enter your card number", viewcontroller: self)
            return false
        } else if !Validator.isCreditCard().apply(self.txtCardNumber.text!) {
            AlertView.showMessageAlert("Please enter valid card number", viewcontroller: self)
            return false
        } else if !Validator.required().apply(self.txtCardHolderName.text!) {
            AlertView.showMessageAlert("Please enter card holder name", viewcontroller: self)
            return false
        } else if !Validator.required().apply(self.txtExpiryDate.text!) {
            AlertView.showMessageAlert("Please select expiry date", viewcontroller: self)
            return false
        } else if !Validator.required().apply(self.txtCVVNumber.text!) {
            AlertView.showMessageAlert("Please enter your card cvv number", viewcontroller: self)
            return false
        }else if (self.txtCVVNumber.text!.count < 3){
            AlertView.showMessageAlert("Please enter correct card cvv number", viewcontroller: self)
            return false
        }
        return true
    }
}
//MARK:- UIPickerview datasource delegate methods
//MARK:-
extension AddCardBankDetailsVC:UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 2
       }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           if component == 0 {
               return self.arrMonths.count
           } else {
               return self.arrYears.count
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if component == 0 {
               return self.arrMonths[row]
           } else {
               return self.arrYears[row]
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           if component == 0 {
               self.selectedMonth = row
           } else {
               self.selectedYear = row
           }
           self.txtExpiryDate.text = "\(self.arrMonths[self.selectedMonth])/\(self.arrYears[self.selectedYear])"
       }
}
