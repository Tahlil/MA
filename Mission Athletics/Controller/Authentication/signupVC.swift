//
//  signupVC.swift
//  Mission Athletic
//
//  Created by Chirag gajjar on 03/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit
import SwiftValidators
import Alamofire
import ObjectMapper
import FBSDKLoginKit
import IQKeyboardManagerSwift


//Full Name ⃰
class signupVC: UIViewController, UITextFieldDelegate
{
    var userType = 0
    
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtBirthDate: UITextField!
    @IBOutlet weak var txtUserType: UITextField!
    @IBOutlet weak var btnAcceptTermsConditions: UIButton!
    
    
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var txtSocialUserEmail: UITextField!
    
    let datePicker = UIDatePicker()
    var fbLoginManager = LoginManager()
    var fbUserInfo:[String:AnyObject] = [:]
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBirthDatePicker()
        
        if self.userType == 2 {
            self.txtUserType.placeholder = "Coach"
        } else {
            self.txtUserType.placeholder = "Athlete"
        }
        
        UIView.animate(withDuration: 0.0, animations: {() -> Void in
            self.vwPopup.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            if finished {
                self.txtSocialUserEmail.text = ""
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.btnClosePopupAction(UIButton())
    }
    
    //MARK:- Helper
    func setBirthDatePicker()
    {
        self.datePicker.datePickerMode = .date
        txtBirthDate.inputView = self.datePicker
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.datePicker.setDate(Calendar.current.date(byAdding: .year, value: 0, to: Date())!, animated: false)
        self.datePicker.addTarget(self, action: #selector(birthdayDatePicker(sender:)), for: .valueChanged)
        
        self.txtBirthDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.btnDoneBirthday(sender:)))
    }
    
    //MARK:- objc methods
    @objc func birthdayDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.yyyy_MM_dd//"dd/MM/yyyy"
        txtBirthDate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func btnDoneBirthday(sender: Any)
    {
        if self.txtBirthDate.text!.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat.yyyy_MM_dd//"dd/MM/yyyy"
            self.txtBirthDate.text = dateFormatter.string(from: self.datePicker.date)
        }
    }
    
    //MARK:- IBActions
    //Popup
    @IBAction func btnSocialLoginPopup(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if (txtSocialUserEmail.text?.isEmpty)! {
            AlertView.showMessageAlert(AlertMessage.emptyEmail, viewcontroller: self)
            return
        }
        else if !Validator.isEmail().apply(self.txtSocialUserEmail.text!) {
            AlertView.showMessageAlert(AlertMessage.invalidEmail, viewcontroller: self)
            return
        } else {
            self.socialLoginApiCall(userInfo: self.fbUserInfo, isFromPopup: true)
        }
    }
    
    @IBAction func btnClosePopupAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.vwPopup.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            if finished {
                self.txtSocialUserEmail.text = ""
            }
        })
    }//Popup
    
    @IBAction func btnSignup(_ sender: UIButton) {
        if isValidate() {
            self.signUpAPICall()
        }
    }
    
    @IBAction func btnFacebookLogin(_ sender: UIButton) {
        self.LoginWithFB()
    }
    
    @IBAction func btnAcceptTermsConditionsAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnViewTermsPrivacyAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "LegalVC") as! LegalVC
        nextVC.setSelectedTab = sender.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK:- API Call
    func signUpAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.register)
            print(url)
            
            var reqParams:[String:Any] = [:]
            reqParams["name"] = self.txtFullname.text!
            reqParams["email"] = self.txtEmail.text!
            reqParams["password"] = self.txtPassword.text!
            reqParams["confirm_password"] = self.txtConfirmPassword.text!
            reqParams["birth_date"] = self.txtBirthDate.text!
            reqParams["mobile_no"] = self.txtPhone.text!
            reqParams["user_type"] = self.userType
            if let fcmDeviceToken = UserDefaults.standard.value(forKey: UserDefaultsKey.FCM_TOKEN) {
                reqParams["device_token"] = String(describing: fcmDeviceToken)
            }else{
                reqParams["device_token"] = "123"
            }
            
            ServiceRequestResponse.servicecallNoHeader(VC: self, url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<LoginResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if (mapData?.data) != nil//let data = mapData?.data
                        {
                            AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                                let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            })
                        }
                    } else {
                        AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
                    }
                } else {
                    HideProgress()
                }
            }
        } else {
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
    //MARK:- Social login methods
    func LoginWithFB()
    {
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                if let fbloginresult = result {
                    //                let fbloginresult :LoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions.count != 0 {
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            self.getFBUserData()
                        }
                    }
                }
            }
        }
    }
    
     func getFBUserData()
    {
        var dict : [String : AnyObject]!
        if((AccessToken.current) != nil)
        {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name,gender, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    dict = result as? [String : AnyObject]
                    print("social user info: \(String(describing: dict))")
                    UserDefaults.standard.set(dict, forKey: "socialLoginUserInfo")
                    UserDefaults.standard.synchronize()
                    
                    self.fbUserInfo = dict
                    
                    let email = dict["email"] as? String ?? ""
                    if email != "" {
                        self.socialCheckApiCall(userInfo: dict)
                    } else {
                        self.socialCheckApiCall(userInfo: dict)
                    }
                }
            })
        }
    }
    
    func socialCheckApiCall(userInfo: [String:AnyObject])
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.socialCheck)
            print(url)
            
            var reqParams:[String:Any] = [:]
            reqParams["email"] = userInfo["email"] as? String ?? ""
            reqParams["facebook_id"] = userInfo["id"] as! String
            
            ServiceRequestResponse.servicecallNoHeader(VC: self, url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<SocialCheckResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            if data.user_type == 0 {//New user
                                let email = userInfo["email"] as? String ?? ""
                                if email != "" {
                                    self.socialLoginApiCall(userInfo: userInfo, isFromPopup: false)
                                } else {
                                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                                        self.vwPopup.alpha = 1.0
                                        self.view.layoutIfNeeded()
                                    }, completion: {(finished) in
                                        if finished {
                                        }
                                    })
                                }
                            } else {//Existing user
                                var user:[String:AnyObject] = [:]
                                user["email"] = data.email as AnyObject?//userInfo["email"] as AnyObject?
                                user["name"] = userInfo["name"] as AnyObject?
                                user["id"] = userInfo["id"] as AnyObject?
                                self.userType = data.user_type!
                                
                                if let objPicture = userInfo["picture"] as? [String:Any] {
                                    if let data = objPicture["data"] as? [String:Any] {
                                        if let imgUrl = data["url"] as? String {
                                            print(imgUrl)
                                            user["image"] = imgUrl as AnyObject
                                        }
                                    }
                                }
                                
                                self.socialLoginApiCall(userInfo: userInfo, isFromPopup: false)
                            }
                        }
                    } else {
                        AlertView.showMessageAlert(mapData?.message ?? "Invalid Email ID or Password", viewcontroller: self)
                    }
                } else {
                    HideProgress()
                }
            }
        } else {
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
    
    func socialLoginApiCall(userInfo: [String:AnyObject], isFromPopup: Bool)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.socialLogin)
            print(url)
            
            var reqParams:[String:Any] = [:]
            reqParams["email"] = isFromPopup == true ? self.txtSocialUserEmail.text! : userInfo["email"] as? String ?? ""
            reqParams["name"] = userInfo["name"] as? String ?? ""
            reqParams["facebook_id"] = userInfo["id"] as! String
            reqParams["user_type"] = self.userType
            if let fcmDeviceToken = UserDefaults.standard.value(forKey: UserDefaultsKey.FCM_TOKEN) {
                reqParams["device_token"] = String(describing: fcmDeviceToken)
            }else{
                reqParams["device_token"] = "123"
            }

            var fbImgUrl = ""
            if isFromPopup == true {
                if let objPicture = userInfo["picture"] as? [String:Any] {
                    if let data = objPicture["data"] as? [String:Any] {
                        if let imgUrl = data["url"] as? String {
                            print(imgUrl)
                            fbImgUrl = imgUrl
                        }
                    }
                }
            }
            
            reqParams["image"] = isFromPopup == true ? fbImgUrl : userInfo["image"] as? String ?? ""
            
            ServiceRequestResponse.servicecallNoHeader(VC: self, url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<LoginResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            saveUserInfo(data)
                            if getUserInfo() != nil
                            {
                                print("User data saved successfully")
                                GlobalConstants.appDelegate.isSocialLogin = true
                                GlobalConstants.appDelegate.setRootViewController()
                            }
                        }
                    } else {
                        AlertView.showMessageAlert(mapData?.message ?? "Invalid Email ID or Password", viewcontroller: self)
                    }
                } else {
                    HideProgress()
                }
            }
        } else {
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
    
    //MARK:- UITextfield delegate
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
        
        if textField == self.txtPhone
        {
            if let char = string.cString(using: String.Encoding.utf8)
            {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    if updatedTxt.count > 15 {
                        return false
                    } else {
                        return true
                    }
                } else {
                    if updatedTxt.count > 15 {
                        return false
                    } else {
                        return true
                    }
                }
            }
        }
        
        if textField == self.txtEmail
        {
            // Block multiple dot
//            if (textField.text?.contains("."))! && string == "." {
//                return false
//            }
//            // Block multiple @
//            if (textField.text?.contains("@"))! && string == "@" {
//                return false
//            }
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtBirthDate {
//            return false; //do not show keyboard nor cursor
        }
        return true
    }
}

extension signupVC
{
    //MARK:- Validation Methods
    func isValidate() -> Bool{
        if (txtFullname.text?.isEmpty)!{
            AlertView.showMessageAlert(AlertMessage.emptyFullName, viewcontroller: self)
            return false
        }
        if (txtEmail.text?.isEmpty)!{
            AlertView.showMessageAlert(AlertMessage.emptyEmail, viewcontroller: self)
            return false
        }
        if !Validator.isEmail().apply(self.txtEmail.text!) {
            AlertView.showMessageAlert(AlertMessage.invalidEmail, viewcontroller: self)
            return false
        }
//        if (txtPhone.text?.isEmpty)!{
//            AlertView.showMessageAlert(AlertMessage.emptyPhoneNo, viewcontroller: self)
//            return false
//        }
        if (txtPassword.text?.isEmpty)!{
            AlertView.showMessageAlert(AlertMessage.emptyPassword, viewcontroller: self)
            return false
        }
        if !Validator.minLength(8).apply(self.txtPassword.text!) {
            AlertView.showMessageAlert(AlertMessage.passwordLength, viewcontroller: self)
            return false
        }
//        if (txtBirthDate.text?.isEmpty)!{
//            AlertView.showMessageAlert(AlertMessage.emptyBirthdate, viewcontroller: self)
//            return false
//        }
        if (txtConfirmPassword.text?.isEmpty)!{
            AlertView.showMessageAlert(AlertMessage.enterPasswordAgain, viewcontroller: self)
            return false
        }
        if txtPassword.text! != self.txtConfirmPassword.text! {
            AlertView.showMessageAlert(AlertMessage.ConfirmPasswordMatch, viewcontroller: self)
            return false
        }
        if self.btnAcceptTermsConditions.isSelected == false {
            AlertView.showMessageAlert(AlertMessage.TermsConditions, viewcontroller: self)
            return false
        }
        return true
    }
}
