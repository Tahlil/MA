//
//  PaymentVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 23/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class PaymentVC: UIViewController {
    
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var tblHistory: UITableView!
    
    var arrWithdrawRequest = [WithdrawrequestList]()
    var totalAmount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwPopup.isHidden = true
        WithdrawRequestListAPICall()
    }
    
    //MARK:- Button Action
    //MARK:-
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnRequest(_ sender: UIButton) {
        
        let amount = txtAmount.text ?? ""
        PaymentWithdrawRequestAPICall(strAmount: amount)
        
    }
    @IBAction func btnHidePopop(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.vwPopup.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func btnWithdrawRequestPopup(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.vwPopup.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK:- Webservice Call
    //MARK:-

    func WithdrawRequestListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.listWithdrawRequest)
            print(url)
            
            let param:Parameters = ["page":"5","limit":"1"]
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<WithdrawRequestListModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        self.arrWithdrawRequest = mapData?.data?.withdrawrequest ?? []
                        self.totalAmount = mapData?.data?.totalBalance ?? 0.0
                        self.lblTotalAmount.text = self.totalAmount.dollarString
                        self.tblHistory.restoreEmptyMessage()
                        if self.arrWithdrawRequest.count == 0{
                            self.tblHistory.setEmptyMessage("Payment not found.")
                        }
                        self.tblHistory.reloadData()

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
    func PaymentWithdrawRequestAPICall(strAmount: String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.sendWithdrawRequest)
            print(url)
            
            let param:Parameters = ["withdraw_amount":strAmount]
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<FriendListModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        self.txtAmount.text = ""
                        AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                            self.WithdrawRequestListAPICall()
                            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                                self.vwPopup.isHidden = true
                                self.view.layoutIfNeeded()
                            })
                        })
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

//MARK:- Tableview Delegate Datasource Methods
//MARK:-

extension PaymentVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWithdrawRequest.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCell", for: indexPath) as! PaymentHistoryCell
        cell.setPaymentDetails(objDetail: arrWithdrawRequest[indexPath.row])
        return cell
    }
}
