//
//  RatingReviewPopupVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 06/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class RatingReviewPopupVC: UIViewController {
    
    @IBOutlet weak var txtReview: UITextView!
    @IBOutlet weak var vwRating: CosmosView!
    
    var coach_id = -1
    var isFromView = ""
    var video_id = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnSendReview(_ sender: UIButton) {
        ReviewRatingAPICall()
    }
    
    //MARK: Athlete video list
    func ReviewRatingAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.rating)
            print(url)
            var reqParam:[String: Any] = [:]
            if isFromView == "details"{
                reqParam["video_id"] = video_id
            }else{
                reqParam["coach_id"] = coach_id
            }
            reqParam["rate"] = vwRating.rating
            reqParam["review"] = txtReview.text ?? ""
            
            print(reqParam)
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<ReviewModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                            
                            self.dismiss(animated: false, completion: nil)
                        })

                        print("success")
                    } else {
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
