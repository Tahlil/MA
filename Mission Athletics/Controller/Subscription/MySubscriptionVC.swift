//
//  MySubscriptionVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 18/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper

class MySubscriptionVC: UIViewController {
    
    
    @IBOutlet weak var tblSubscriptions: UITableView!
    var arrSubscriptions = [Mysubscription]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSubscriptionListAPICall()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    //MARK:- API Call
    //MARK:-
    func getSubscriptionListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.viewAllSubscription)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<mySubscriptionModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.arrSubscriptions = data.mysubscriptions ?? []
                            
                            if self.arrSubscriptions.count > 0 {
                                self.tblSubscriptions.dataSource = self
                                self.tblSubscriptions.delegate = self
                                self.tblSubscriptions.reloadData()
                            }else{
                                self.tblSubscriptions.setEmptyMessage("Subscriptions not found.")
                                self.tblSubscriptions.reloadData()
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
    
    func cancelSubscriptionAPICall(strSubscriptionID:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.cancelSubscription)
            print(url)
            var reqParams:[String:Any] = [:]
            reqParams["subscription_id"] = strSubscriptionID

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<mySubscriptionModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        self.getSubscriptionListAPICall()
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

}
//MARK:- TableviewDelegate Datasource Methods
//MARK:-
extension MySubscriptionVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubscriptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MySubscriptionCell", for: indexPath) as! MySubscriptionCell
        let objDetails = arrSubscriptions[indexPath.row]
        
        cell.setSubscriptionDetails(objDetails)
        
        cell.btnCancelSubscription.tag = indexPath.row
        cell.btnCancelSubscription.addTarget(self, action: #selector(CancelSubscriptions(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func CancelSubscriptions(sender:UIButton){
        AlertView.showAlert("Confirmation", strMessage:"By clicking \("Confirm") you will unsubscribe the customer from this subscription. This will stop the scheduled automatic billing. but they will keep their acces rights until end of the subscriptions.", button: ["Confirm","Cancel"], viewcontroller: self, blockButtonClicked: { (button) in
            if button == 0{
                self.cancelSubscriptionAPICall(strSubscriptionID: "\(self.arrSubscriptions[sender.tag].id ?? 0)")
            }
        })
    }
}
