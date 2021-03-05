//
//  AthleteVideoListVC.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 02/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import ObjectMapper
import UIKit
import AVKit
import Alamofire


protocol AthleteVideoListVC_Delegate: class {
    func scrollViewDidScroll(scrollView: UIScrollView, tableView: UIScrollView)
}

class AthleteVideoListVC: UIViewController
{
    @IBOutlet weak var cvMyVideos: UICollectionView!
    var arrBookmarkVideos = [ViewVideosArrModel]()
    var arrMyVideos = [AthleteMyVideosArrModel]()
    @IBOutlet weak var scrollView : UIScrollView!
    weak var delegate: AthleteVideoListVC_Delegate?

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddVideo: UIButton!
    @IBOutlet weak var bottomTableview: NSLayoutConstraint!
    
    
    var strViewTitle = ""
    var isFromViewVideo = "athlet_profile"
    var strCompareVideoSelected = ""
    var coachVideoID = -1
    var freeVideosRemaining = 0
    var compareCoachID = 0
    
    var Total_Videos = 0
    var PageOffset = 1
    var limit  = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = strViewTitle
        self.cvMyVideos.dataSource = self
        self.cvMyVideos.delegate = self
        self.cvMyVideos.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        PageOffset = 1
        if isFromViewVideo == "athlet_profile" || isFromViewVideo == "athlet_compare_profile"{
            btnAddVideo.isHidden = false
            getAllMyVideosAPICall()
        }else if isFromViewVideo == "athlet_profile_videoPost"{
            btnAddVideo.isHidden = true
            getAllMyVideosAPICall()
        } else{
            getAllBookMarkVideosAPICall()
        }
        if let flowLayout = self.cvMyVideos.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 25
            flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 65) / 2, height: 270)
            self.cvMyVideos.reloadData()
        }
        self.cvMyVideos.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- IBActions
    @IBAction func btnAddVideoAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func btnCompareVideoRequest(_ sender: UIButton) {
        CompareVideoRequestAPICall()
    }
    
    //MARK:- UITextfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space
        
        return true
    }
    //MARK:- API Call - Get All athlete bookmark viode list
    func getAllBookMarkVideosAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            if self.PageOffset == 1{
                ShowProgress()
            }
            let url = WebService.createURLForWebService(WebService.viewAllBookmarkVideo)
            print(url)
            var reqParam:[String: Any] = [:]

            reqParam["limit"] = limit
            reqParam["page"] = PageOffset
            reqParam["user_id"] = coachVideoID

            print(reqParam)

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<AthleteAllBookmarkVideosArrModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            self.cvMyVideos.restoreEmptyMessage()
                            if self.PageOffset == 1{
                                self.arrBookmarkVideos = []
                                self.arrBookmarkVideos = data.bookmarkVideo ?? []
                            }else{
                                self.arrBookmarkVideos += data.bookmarkVideo ?? []
                            }
                            self.cvMyVideos.reloadData()
                            self.freeVideosRemaining = data.free_videos ?? 0
                        }
                        if self.arrBookmarkVideos.count == 0{
                            self.cvMyVideos.setEmptyMessage("Bookmarked Videos not found.")
                            self.cvMyVideos.reloadData()
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
    
    func getAllMyVideosAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            if self.PageOffset == 1{
                ShowProgress()
            }
            let url = WebService.createURLForWebService(WebService.viewAllAthleteVideo)
            print(url)
            var reqParam:[String: Any] = [:]
            reqParam["limit"] = limit
            reqParam["page"] = PageOffset
            reqParam["user_id"] = coachVideoID

            print(reqParam)

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<MyAthleteVideoModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            self.cvMyVideos.restoreEmptyMessage()

                            if self.PageOffset == 1{
                                self.arrMyVideos = []
                                self.arrMyVideos = data.myVideos ?? []
                            }else{
                                self.arrMyVideos += data.myVideos ?? []
                            }
                            self.cvMyVideos.reloadData()
                        }
                        if self.arrMyVideos.count == 0{
                            self.cvMyVideos.setEmptyMessage("Video post not found.")
                            self.cvMyVideos.reloadData()
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

    func CompareVideoRequestAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.videoComparisionRequest)
            print(url)
            
            var param:Parameters = ["athlete_video_id":strCompareVideoSelected]
            param["coach_video_id"] = compareCoachID
            param["title"] = "Compare Video request"

            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: param) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<FriendListModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self) { (action) in
                            self.navigationController?.popViewController(animated: true)
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
    //Increase video count
    func videoCountAPICall(strVideoID:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = WebService.createURLForWebService(WebService.videoviews)
            print(url)
            var reqParam:[String: Any] = [:]
            reqParam["video_id"] = strVideoID
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
            }
        }else{
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }

}

//MARK:- UICollectionView datasource delegate methods
//MARK:-
extension AthleteVideoListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFromViewVideo == "athlet_profile" || isFromViewVideo == "athlet_compare_profile" || isFromViewVideo == "athlet_profile_videoPost"{
            return arrMyVideos.count
        }else{
            return arrBookmarkVideos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoachVideoListCell", for: indexPath) as! CoachVideoListCell
        if isFromViewVideo == "athlet_compare_profile"{
            
            let objDetails = arrMyVideos[indexPath.row]
            
            cell.lblCoachName.text = getDayWithDate(stringDate: objDetails.date ?? "")
            cell.lblVideoTitle.text = objDetails.title ?? ""
            cell.btnSelect.isHidden = false
            if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
                cell.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
            }
            if strCompareVideoSelected == "\(objDetails.id ?? -1)"{
                cell.btnSelect.setImage(#imageLiteral(resourceName: "tic_round"), for: .normal)
            }else{
                cell.btnSelect.setImage(#imageLiteral(resourceName: "untic_round"), for: .normal)
            }

            cell.btnSelect.tag = indexPath.row
            cell.btnSelect.addTarget(self, action: #selector(selectCompareVideo(sender:)), for: .touchUpInside)
            
            //strCompareVideoSelected
            
        }else if isFromViewVideo == "athlet_profile" || isFromViewVideo == "athlet_profile_videoPost"{
            
            let objDetails = arrMyVideos[indexPath.row]
            
            cell.lblCoachName.text = getDayWithDate(stringDate: objDetails.date ?? "")
            cell.lblVideoTitle.text = objDetails.title ?? ""
            cell.btnSelect.isHidden = true
            if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
                cell.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
            }
        }else{
            let objDetails = arrBookmarkVideos[indexPath.row]
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

            cell.lblVideoTitle.text = objDetails.title ?? ""
            cell.lblCoachName.text = objDetails.username ?? ""
            cell.btnSelect.isHidden = true
            if let videoThumbUrl = URL(string: objDetails.thumbnail_image ?? "") {
                cell.ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
            }
        }

        return cell
    }
    
    @objc func selectCompareVideo(sender:UIButton){
        
        self.bottomTableview.constant = 70
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.view.layoutIfNeeded()
            }
        })
        let objDetails = arrMyVideos[sender.tag]
        strCompareVideoSelected = "\(objDetails.id ?? -1)"
        cvMyVideos.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped")
        if isFromViewVideo == "athlet_profile"{
            let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachVideoUploadVC") as! CoachVideoUploadVC
            nextVC.objAthleteVideo = arrMyVideos[indexPath.row]
            nextVC.isFromViewController = "athlete_video"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if isFromViewVideo == "athlet_compare_profile" || isFromViewVideo == "athlet_profile_videoPost"{
            if let videoUrl = arrMyVideos[indexPath.row].videourl{
                if let url = URL.init(string: videoUrl){
                    playVideoAvPlayerViewController(videoUrl: url)
                }
            }
        }else if isFromViewVideo == "athlet_profile_bookMarkvideo"{
            if let videoUrl = arrBookmarkVideos[indexPath.row].videourl{
                videoCountAPICall(strVideoID: "\(arrBookmarkVideos[indexPath.row].id ?? 0)")
                if let url = URL.init(string: videoUrl){
                    playVideoAvPlayerViewController(videoUrl: url)
                }
            }
        }else{
            let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
            nextVC.isFromViewController = "athlete_profile"
            nextVC.objAthleteVideo = arrBookmarkVideos[indexPath.row]
            nextVC.freeVideosRemaining = self.freeVideosRemaining
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
//MARK:- Scrollview method
//MARK:-
extension AthleteVideoListVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: self.scrollView, tableView: self.scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if ((self.cvMyVideos.contentOffset.y + self.cvMyVideos.frame.size.height) >= cvMyVideos.contentSize.height)
        {
            if isFromViewVideo == "athlet_profile" || isFromViewVideo == "athlet_compare_profile" || isFromViewVideo == "athlet_profile_videoPost"{
                if self.arrBookmarkVideos.count < self.Total_Videos{
                    
                    self.PageOffset += 1
                    print("PAGination")
                    self.getAllMyVideosAPICall()
                }
            }else{
                if self.arrBookmarkVideos.count < self.Total_Videos{
                    
                    self.PageOffset += 1
                    print("PAGination")
                    self.getAllBookMarkVideosAPICall()
                }
            }
        }
    }
}
