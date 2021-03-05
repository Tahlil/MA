//
//  LoginVC.swift
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

class LoginVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var lblPopupSubTitle: UILabel!
    @IBOutlet weak var vwEmailHeight: NSLayoutConstraint!
    @IBOutlet weak var txtSocialUserEmail: UITextField!
    @IBOutlet weak var vwUserTypeTop: NSLayoutConstraint!
    @IBOutlet weak var vwUserTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var txtUserType: UITextField!
    @IBOutlet weak var btnUserTypeSelect: UIButton!
    var hasEmail = false
    
    var fbLoginManager = LoginManager()
    var fbUserInfo:[String:AnyObject] = [:]
    
    var dropDownUserTypeSelect = DropDown()
    var userType = 0
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        GlobalConstants.appDelegate.isPasswordChange = false
        
//        self.txtEmail.text = "maulikp@mailinator.com"
//        self.txtPassword.text = "12345678"
        
        self.setupDropDowns()
        
        UIView.animate(withDuration: 0.0, animations: {() -> Void in
            self.vwPopup.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            if finished {
                self.txtSocialUserEmail.text = ""
                self.txtUserType.text = "Select user type"
            }
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.btnClosePopupAction(UIButton())
    }
    
    //MARK:- Helper
    func setupDropDowns()
    {
        let dataSourceUserType = ["Coach", "Athlete"]
        self.dropDownUserTypeSelect.anchorView = self.btnUserTypeSelect
        self.dropDownUserTypeSelect.bottomOffset = CGPoint(x: 0, y:(self.dropDownUserTypeSelect.anchorView?.plainView.bounds.height)!)
        self.dropDownUserTypeSelect.dataSource = dataSourceUserType
        self.dropDownUserTypeSelect.backgroundColor = UIColor.white
        self.dropDownUserTypeSelect.shadowColor = UIColor.appBlueColor
        self.dropDownUserTypeSelect.shadowRadius = 1.5
        self.dropDownUserTypeSelect.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.dropDownUserTypeSelect.shadowOpacity = 0.5
        self.dropDownUserTypeSelect.textFont = UIFont(name: "BrandonGrotesque-Medium", size: 15.0)!
        self.dropDownUserTypeSelect.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtUserType.text = item
            
            if item == "Coach" {
                self.userType = 2
            } else {
                self.userType = 3
            }
        }
    }
    
    //MARK:- IBActions
    //Popup
    @IBAction func btnUserTypeSelectAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.dropDownUserTypeSelect.show()
    }
    
    @IBAction func btnSocialLoginPopup(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.socialLoginApiCall(userInfo: self.fbUserInfo, isFromPopup: true)
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
                self.txtUserType.text = "Select user type"
            }
        })
    }//Popup
    
    @IBAction func btnForgotPasswordAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.isValidate() {
            self.loginApiCall()
        }
    }
    
    @IBAction func btnFacebookLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        self.LoginWithFB()
    }
    
    @IBAction func btnViewTermsPrivacyAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let nextVC = GlobalConstants.AuthenticationStoryboard.instantiateViewController(withIdentifier: "LegalVC") as! LegalVC
        nextVC.setSelectedTab = sender.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK:- API Call
    func loginApiCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.login)
            print(url)
            
            var reqParams:[String:Any] = [:]
            reqParams["email"] = self.txtEmail.text!
            reqParams["password"] = self.txtPassword.text!
            if let fcmDeviceToken = UserDefaults.standard.value(forKey: UserDefaultsKey.FCM_TOKEN) {
                reqParams["device_token"] = String(describing: fcmDeviceToken)//"sdkjshfisigiu" //
            }else{
                reqParams["device_token"] = "123"
            }
            reqParams["timezone"] = getCurrentTimeZone()

            print(reqParams)

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
                                GlobalConstants.appDelegate.isSocialLogin = false
                                GlobalConstants.appDelegate.setRootViewController()

//                                self.LoginWithQuickBlox(username: self.txtEmail.text!, password: self.txtPassword.text!)
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
    
    //MARK:- Social login methods
    func LoginWithFB()
    {
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                if let fbloginresult = result {
                    //                let fbloginresult :LoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions != nil {
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
                
                if (error == nil)
                {
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
    
    func openClosePopup(open: Bool, reqEmail: Bool, reqUserType: Bool)
    {
        if open {
            if reqEmail == false || reqUserType == false {
                self.vwUserTypeTop.constant = 0
                if reqEmail == false {
                    self.vwEmailHeight.constant = 0
                    self.lblPopupSubTitle.text = "Select user type to continue."
                }
                if reqUserType == false {
                    self.vwUserTypeTop.constant = 0
                    self.lblPopupSubTitle.text = "Enter email to continue."
                }
            }
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.vwPopup.alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: {(finished) in
                if finished {
                    
                }
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.vwPopup.alpha = 0.0
                self.view.layoutIfNeeded()
            }, completion: {(finished) in
                if finished {
                    
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
                            if data.user_type! != -1 {
                                if data.user_type! == 0 {//New user
                                    let email = userInfo["email"] as? String ?? ""
                                    if email != "" {
                                        self.openClosePopup(open: true, reqEmail: false, reqUserType: true)
                                    } else {
                                        self.openClosePopup(open: true, reqEmail: true, reqUserType: true)
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
            reqParams["email"] = (isFromPopup == true && self.vwEmailHeight.constant != 0) ? self.txtSocialUserEmail.text! : userInfo["email"] as? String ?? ""
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
        
        if textField == self.txtEmail
        {
//            // Block multiple dot
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
}

extension LoginVC
{
    //MARK:- Validation check
    func isValidate() -> Bool {
        if (txtEmail.text?.isEmpty)! {
            AlertView.showMessageAlert(AlertMessage.emptyEmail, viewcontroller: self)
            return false
        }
        if !Validator.isEmail().apply(self.txtEmail.text!) {
            AlertView.showMessageAlert(AlertMessage.invalidEmail, viewcontroller: self)
            return false
        }
        if (txtPassword.text?.isEmpty)! {
            AlertView.showMessageAlert(AlertMessage.emptyPassword, viewcontroller: self)
            return false
        }
//        if !Validator.minLength(8).apply(self.txtPassword.text!) {
//            AlertView.showMessageAlert(AlertMessage.passwordLength, viewcontroller: self)
//            return false
//        }
        return true
    }
}
