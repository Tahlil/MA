//
//  ReviewVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 05/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class ReviewVC: UIViewController {
    @IBOutlet weak var tblReview: UITableView!
    
    var isViewFrom = ""
    var arrReviewList = [ReviewDataModel]()
    var userId = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        getAllReviewRatingAPICall()
        
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
    
    //MARK: Athlete video list
    func getAllReviewRatingAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.viewAllReviews)
            print(url)
            
            var reqParam:[String: Any] = [:]
            reqParam["user_id"] = userId
            print(reqParam)
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<ReviewModel>().map(JSONString: result!)
                    if mapData?.code == "200"{
                        if let reviewList = mapData?.data {
                            self.arrReviewList = reviewList
                            self.tblReview.reloadData()

                        } else {
                            self.arrReviewList = [ReviewDataModel]()
                            self.tblReview.setEmptyMessage("Ratings and reviews not found.")
                            self.tblReview.reloadData()
                        }
                        
                        print("success")
                    } else {
                        self.tblReview.setEmptyMessage("Ratings and reviews not found.")
                        self.tblReview.reloadData()
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
extension ReviewVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReviewList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        let objDetails = arrReviewList[indexPath.row]
        cell.setReviewDetatils(objDetails)
        return cell
    }
}
