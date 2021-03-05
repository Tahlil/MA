//
//  SettingsVC.swift
//  Mission Athletics
//
//  Created by apple on 05/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftValidators
import IQKeyboardManagerSwift

class SettingsVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var swtchPushNotification: UISwitch!
    @IBOutlet weak var pushOptionsHeight: NSLayoutConstraint!
    @IBOutlet var btnPushOptions: [UIButton]!
    @IBOutlet weak var vwchangePasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pushOptionsHeight.constant = 0
//        IQKeyboardManager.shared.overrideIteratingTextFields = [txtCurrentPassword, txtNewPassword, txtConfirmNewPassword]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalConstants.appDelegate.isSocialLogin {// FB Login
            self.vwchangePasswordHeight.constant = 0
        } else {
            self.vwchangePasswordHeight.constant = 207
        }
        
        self.getSettingsAPICall()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.shared.overrideIteratingTextFields = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    //MARK:- IBActions
    @IBAction func swtchPushNotificationAction(_ sender: UISwitch)
    {
        self.view.endEditing(true)
        if sender.isOn {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.pushOptionsHeight.constant = 150
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.pushOptionsHeight.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func btnPushOptionsAction(_ sender: UIButton)
    {
        self.changeBtnSelection(tag: sender.tag)
    }
    
    //MARK:- Handle button selection for notifications
    func changeBtnSelection(tag: Int)
    {
        for button in self.btnPushOptions
        {
            if button.tag == tag {
                if button.isSelected == false {
                    button.isSelected = true
                } else {
                    button.isSelected = false
                }
            }
        }
    }
    
    @IBAction func btnShowPasswordAction(_ sender: UIButton)
    {
        if sender.tag == 0 {
            if sender.isSelected == false {
                sender.isSelected = true
                self.txtNewPassword.isSecureTextEntry = false
            } else {
                sender.isSelected = false
                self.txtNewPassword.isSecureTextEntry = true
            }
        } else {
            if sender.isSelected == false {
                sender.isSelected = true
                self.txtConfirmNewPassword.isSecureTextEntry = false
            } else {
                sender.isSelected = false
                self.txtConfirmNewPassword.isSecureTextEntry = true
            }
        }
    }
    
    @IBAction func btnCardDetailsAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let nextVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "AddCardBankDetailsVC") as! AddCardBankDetailsVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        AlertView.showAlert("", strMessage: "Are you sure you want to delete your account?", button: ["Yes","No"], viewcontroller: self, blockButtonClicked: { (button) in
            if button == 0{
            }
        })
    }
    
    @IBAction func btnSaveChangesAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.txtNewPassword.text!.isEmpty && self.txtCurrentPassword.text!.isEmpty && self.txtConfirmNewPassword.text!.isEmpty {
            self.changeSettingsApiCall(isPasswordReset: false)
        } else {
            if self.isValidate() {
                AlertView.showAlert("", strMessage: "You will need to log in again to ensure password change", button: ["Cancel", "Continue"], viewcontroller: self, blockButtonClicked: { (button) in
                    if button == 1 {
                        self.changeSettingsApiCall(isPasswordReset: true)
                    }
                })
            }
        }
    }
    
    //MARK:- Check fields validation
    func isValidate() -> Bool {
        if !Validator.required().apply(self.txtCurrentPassword.text!) {
            AlertView.showMessageAlert(AlertMessage.emptyPassword, viewcontroller: self)
            return false
        }
        if !Validator.required().apply(self.txtNewPassword.text!) {
            AlertView.showMessageAlert(AlertMessage.emptyNewPassword, viewcontroller: self)
            return false
        }
        if !Validator.minLength(8).apply(self.txtNewPassword.text!) {
            AlertView.showMessageAlert(AlertMessage.passwordLength, viewcontroller: self)
            return false
        }
        if !Validator.required().apply(self.txtConfirmNewPassword.text!) {
            AlertView.showMessageAlert(AlertMessage.enterNewPasswordAgain, viewcontroller: self)
            return false
        }
        if self.txtNewPassword.text! != self.txtConfirmNewPassword.text! {
            AlertView.showMessageAlert(AlertMessage.NewPasswordMatch, viewcontroller: self)
            return false
        }
        return true
    }
    
    //MARK:- UITextfield delegate -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space
        
        return true
    }
    
    //MARK:- API Call -
    func getSettingsAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getSettings)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .get, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<GetSettingsResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            for btn in self.btnPushOptions
                            {
                                if btn.tag == 0 {
                                    btn.isSelected = data.new_followers ?? false
                                } else if btn.tag == 1 {
                                    btn.isSelected = data.followed_trainer_video ?? false
                                } else if btn.tag == 2 {
                                    btn.isSelected = data.new_messages ?? false
                                }
                            }
                            if data.new_messages! == true || data.new_followers! == true || data.followed_trainer_video! == true
                            {
                                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                                    self.swtchPushNotification.setOn(true, animated: false)
                                    self.pushOptionsHeight.constant = 150
                                    self.view.layoutIfNeeded()
                                })
                            } else {
                                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                                    self.swtchPushNotification.setOn(false, animated: false)
                                    self.pushOptionsHeight.constant = 0
                                    self.view.layoutIfNeeded()
                                })
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
    
    func changeSettingsApiCall(isPasswordReset: Bool)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.changeSettings)
            print(url)
            
            var reqParams:[String:Any] = [:]
            if isPasswordReset {
                reqParams["oldpassword"] = self.txtCurrentPassword.text!
                reqParams["newpassword"] = self.txtNewPassword.text!
                reqParams["confirmpassword"] = self.txtConfirmNewPassword.text!
            }
            reqParams["new_followers"] = self.btnPushOptions[0].isSelected
            reqParams["new_messages"] = self.btnPushOptions[2].isSelected
            reqParams["followed_trainer_video"] = self.btnPushOptions[1].isSelected
            
            ServiceRequestResponse.servicecallWithHeader(VC: self, url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CommonResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if isPasswordReset {
                            AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                                GlobalConstants.appDelegate.isPasswordChange = true
                                removeUserInfo(key: UserDefaultsKey.user)
                                GlobalConstants.appDelegate.setRootViewController()
                            })
                        } else {
                            AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                                self.btnGoBackAction(UIButton())
                            })
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
}
