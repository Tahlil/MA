//
//  ForgotPasswordVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 25/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SwiftValidators
import ObjectMapper

class ForgotPasswordVC: UIViewController
{
    @IBOutlet weak var txtEmail: UITextField!
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBActions
    @IBAction func btnSendMail(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.isValidate() {
            self.forgotPasswordApiCall()
        }
    }
    
    //MARK:- Check fields validation
    func isValidate() -> Bool {
        if (txtEmail.text?.isEmpty)! {
            AlertView.showMessageAlert(AlertMessage.emptyEmail, viewcontroller: self)
            return false
        }
        if !Validator.isEmail().apply(self.txtEmail.text!) {
            AlertView.showMessageAlert(AlertMessage.invalidEmail, viewcontroller: self)
            return false
        }
        return true
    }
    
    //MARK:- API Call
    func forgotPasswordApiCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.forgotPassword)
            print(url)
            
            var reqParams:[String:Any] = [:]
            reqParams["email"] = self.txtEmail.text!
            
            ServiceRequestResponse.servicecallNoHeader(VC: self, url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CommonResModel>().map(JSONString: result!)
                    if mapData?.code == "200" || mapData!.code! == 200
                    {
                        AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                            self.btnGoBackAction(UIButton())
                        })
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
}
