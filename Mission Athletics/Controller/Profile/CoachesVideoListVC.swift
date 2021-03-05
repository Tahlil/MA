//
//  CoachesVideoListVC.swift
//  Mission Athletics
//
//  Created by MAC  on 17/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol CoachesVideoListVC_Delegate: class {
    func scrollViewDidScroll(scrollView: UIScrollView, tableView: UIScrollView)
}

class CoachesVideoListVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var cvTrainingVideos: UICollectionView!
    @IBOutlet weak var scrollView : UIScrollView!
    weak var delegate: CoachesVideoListVC_Delegate?

    var arrCoachvideos = [ViewVideosArrModel]()

    var userId = -1
    var isFromViewController = ""
    var freeVideosRemaining = 0
    var Total_Videos = 0
    var PageOffset = 1
    var limit  = 10

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvTrainingVideos.dataSource = self
        self.cvTrainingVideos.delegate = self
        self.cvTrainingVideos.reloadData()
        
        self.vwSearch.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        if let flowLayout = self.cvTrainingVideos.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 25
            flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 65) / 2, height: 270)
            self.cvTrainingVideos.reloadData()
        }
        self.cvTrainingVideos.reloadData()
        PageOffset = 1
        getAllVideoCoatchAPICall(strSearch: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- IBActions
    @IBAction func btnSearchAction(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.transitionCurlUp], animations: {
            self.vwSearch.alpha = 1.0
            self.txtSearch.text = ""
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            self.txtSearch.becomeFirstResponder()
        })
    }
    
    @IBAction func btnCloseSearchAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.transitionCurlDown], animations: {
            self.vwSearch.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            self.txtSearch.resignFirstResponder()
        })
        getAllVideoCoatchAPICall(strSearch: "")

    }
    
    //MARK:- UITextfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space
        
        getAllVideoCoatchAPICall(strSearch: newString as String)

        return true
    }
    
    //MARK:- API Call -
    func getAllVideoCoatchAPICall(strSearch:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            if self.PageOffset == 1{
                ShowProgress()
            }
            let url = WebService.createURLForWebService(WebService.viewAllCoachVideo)
            print(url)
            var reqParam:[String:Any] = [:]
            reqParam["page"] = PageOffset
            reqParam["limit"] = limit
            reqParam["user_id"] = userId
            reqParam["keyword"] = strSearch

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    let mapData  = Mapper<ViewVideosResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            self.freeVideosRemaining = data.free_videos ?? 0
                            if let videos = data.videodata {
                                if self.PageOffset == 1{
                                    self.arrCoachvideos = []
                                    self.arrCoachvideos = videos
                                }else{
                                    self.arrCoachvideos += videos
                                }
                            }
                            self.cvTrainingVideos.reloadData()
                            self.cvTrainingVideos.restoreEmptyMessage()
                            if self.arrCoachvideos.count == 0{
                                self.cvTrainingVideos.setEmptyMessage("Training video not found.")
                                self.cvTrainingVideos.reloadData()
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
}

//MARK:- UICollectionView datasource delegate methods
//MARK:-
extension CoachesVideoListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCoachvideos.count//self.arrSportsType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoachVideoListCell", for: indexPath) as! CoachVideoListCell
        let objDetails = arrCoachvideos[indexPath.row]
        cell.setCoachVideoData(objDetails)
        
        if let userData = getUserInfo() {
            if userData.user_type != 2 {//not coach
                if (objDetails.subscriptionInfo?.subscribecoach!.status)!{
                    cell.ivVideoThumb.removeBlurEffect()
                    cell.isUserInteractionEnabled = true
                }else{
                    if freeVideosRemaining >= indexPath.row {
                        cell.ivVideoThumb.removeBlurEffect()
                        cell.isUserInteractionEnabled = true
                    }else{
                        cell.ivVideoThumb.setBlurImgeView()
                        cell.isUserInteractionEnabled = false
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped")
        
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if isFromViewController == "notification"{
                    if let videoUrl = arrCoachvideos[indexPath.row].videourl{
                        if let url = URL.init(string: videoUrl){
                            playVideoAvPlayerViewController(videoUrl: url)
                        }
                    }
                }else{
                    let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
                    nextVC.objCoachvideos = arrCoachvideos[indexPath.row]
                    nextVC.isFromViewController = "coach_video"
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }else{
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
                nextVC.objAthleteVideo = arrCoachvideos[indexPath.row]
                nextVC.isFromViewController = "athlete_profile"
                nextVC.freeVideosRemaining = self.freeVideosRemaining
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
//MARK:- Scrollview method
//MARK:-
extension CoachesVideoListVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: self.scrollView, tableView: self.scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if ((self.cvTrainingVideos.contentOffset.y + self.cvTrainingVideos.frame.size.height) >= cvTrainingVideos.contentSize.height)
        {
            if self.arrCoachvideos.count < self.Total_Videos{
                
                self.PageOffset += 1
                print("PAGination")
                self.getAllVideoCoatchAPICall(strSearch: "")
            }
        }
    }
}
