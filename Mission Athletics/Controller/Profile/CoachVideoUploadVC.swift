//
//  CoachVideoUploadVC.swift
//  Mission Athletics
//
//  Created by MAC  on 16/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import AVFoundation
import AVKit
import IQKeyboardManagerSwift
import ObjectMapper
import Photos
import SDWebImage
import UIKit

class CoachVideoUploadVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var vwVideoMainHeight: NSLayoutConstraint!
    @IBOutlet weak var vwVideoUpload: UIView!
    @IBOutlet weak var vwVideoContent: UIView!
    @IBOutlet weak var ivVideoThumb: UIImageView!
    @IBOutlet weak var btnRemoveVideo: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtvwDesc: UITextView!
    @IBOutlet weak var cvSportType: UICollectionView!
    @IBOutlet weak var cvSportTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAddVideo: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var btnDeleteVideo: UIButton!
    
    var arrSportsType = ["Basketball", "Football", "Swimming"]
    var arrSportsTypeIcon = [UIImage(named: "basketball_upcoming"), UIImage(named: "rugby_ball_filter_popup"), UIImage(named: "swimming_filter_popup")]
    var selectedIndex = -1
    var arrSportsList = [SportsListArrModel]()
    
    var isFromCoatch = false
    var isFromHomeView = false
    var isFromViewController = ""
    
    //var objCoachvideos:AthleteMyVideosArrModel?
    var objCoachvideos:ViewVideosArrModel?
    var objCoachOwnvideos:CoachVideosArrModel?
    var objAthleteVideo:AthleteMyVideosArrModel?
    var videoPath: URL?
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userData = getUserInfo() {
            if userData.user_type == 2 {//coach
                if self.isFromViewController == "coach_new_add_video" {
                    lblVideoTitle.text = "Add Video"
                    btnDeleteVideo.isHidden = true
                }else{
                    lblVideoTitle.text = "Update Video"
                    btnDeleteVideo.isHidden = false
                }
            }else{
                if self.isFromViewController == "athlete_video" || isFromViewController == "coach_video"{
                    lblVideoTitle.text = "Update Video"
                    btnDeleteVideo.isHidden = false
                }else{
                    btnDeleteVideo.isHidden = true
                }
            }
        }
        
        self.getSportsListAPICall()
        self.txtvwDesc.text = "Add Desciption"
        self.txtvwDesc.textColor = UIColor(red: 170/255, green: 223/255, blue: 238/255, alpha: 1.0)
//        IQKeyboardManager.shared.overrideIteratingTextFields = [txtTitle, txtvwDesc]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        
        self.btnAddVideo.layer.removeAllGradiantLayers()
        DispatchQueue.main.async {
            self.vwVideoUpload.addDashBorder(color: UIColor.appBlueColor.cgColor)
            
            addGradientBackground(view: self.btnAddVideo, gradientColors: [UIColor.appBlueColor.cgColor, UIColor(red: 0/255, green: 100/255, blue: 246/255, alpha: 1.0).cgColor], direction: .leftRight)
        }
    }
    
    func setAthleteVideoDetails(){
        
        txtvwDesc.textColor = UIColor(red: 0/255, green: 147/255, blue: 198/255, alpha: 1.0)

        txtTitle.text = objAthleteVideo?.title
        txtvwDesc.text = objAthleteVideo?.description
        if let videoThumbUrl = URL(string: objAthleteVideo?.thumbnail_image ?? "") {
            ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
        }
        self.vwVideoContent.isHidden = false
        self.vwVideoUpload.isHidden = true
        self.vwVideoMainHeight.constant = 160
        
        videoPath = URL.init(string: objAthleteVideo?.videourl ?? "")
        
        btnAddVideo.setTitle("UPDATE VIDEO", for: .normal)
        
        var index = 0
        for item in arrSportsList{
            if item.id == objAthleteVideo?.sport_id{
                selectedIndex = index
            }
            index = index + 1
        }
        cvSportType.reloadData()
    }
    func setCoachVideoDetails(){
        
        txtvwDesc.textColor = UIColor(red: 0/255, green: 147/255, blue: 198/255, alpha: 1.0)

        txtTitle.text = objCoachvideos?.title
        txtvwDesc.text = objCoachvideos?.descrip
        if let videoThumbUrl = URL(string: objCoachvideos?.thumbnail_image ?? "") {
            ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
        }
        self.vwVideoContent.isHidden = false
        self.vwVideoUpload.isHidden = true
        self.vwVideoMainHeight.constant = 160
        
        videoPath = URL.init(string: objCoachvideos?.videourl ?? "")
        
        btnAddVideo.setTitle("UPDATE VIDEO", for: .normal)
        
        var index = 0
        for item in arrSportsList{
            if item.id == objCoachvideos?.sport_id{
                selectedIndex = index
            }
            index = index + 1
        }
        cvSportType.reloadData()
    }
    func setCoachOwnVideoDetails(){
        
        txtvwDesc.textColor = UIColor(red: 0/255, green: 147/255, blue: 198/255, alpha: 1.0)

        txtTitle.text = objCoachOwnvideos?.title
        txtvwDesc.text = objCoachOwnvideos?.descrip
        if let videoThumbUrl = URL(string: objCoachOwnvideos?.thumbnail_image ?? "") {
            ivVideoThumb.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
        }
        self.vwVideoContent.isHidden = false
        self.vwVideoUpload.isHidden = true
        self.vwVideoMainHeight.constant = 160
        
        videoPath = URL.init(string: objCoachOwnvideos?.videourl ?? "")
        
        btnAddVideo.setTitle("UPDATE VIDEO", for: .normal)
        
        var index = 0
        for item in arrSportsList{
            if item.id == objCoachOwnvideos?.sport_id{
                selectedIndex = index
            }
            index = index + 1
        }
        cvSportType.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setSportTypeCollHeight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
//        IQKeyboardManager.shared.overrideIteratingTextFields = nil
    }
    
    override open var prefersStatusBarHidden: Bool
    {
        return false
    }
    
    //MARK:- IBActions
    //MARK:-
    @IBAction func btnUploadVideoAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.selectSourceForVideo()
    }
    
    @IBAction func btnPlayVideoAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
//        self.playVideoAvPlayer(videoUrl: self.videoPath!)
        playVideoAvPlayerViewController(videoUrl: self.videoPath!)
    }
    
    @IBAction func btnRemoveVideoAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.vwVideoContent.isHidden = true
        self.vwVideoUpload.isHidden = false
        self.vwVideoMainHeight.constant = 115
    }
    
    @IBAction func btnAddVideoAction(_ sender: UIButton)
    {
        self.view.endEditing(true)

        if self.isFromViewController == "athlete_video" || isFromViewController == "coach_video" || isFromViewController == "coach_own_video"{
            if isValidateDetails(){
                ShowProgress()
                DispatchQueue.global(qos: .default).async {
                    
                    do {
                        let videoData = try NSData(contentsOf: self.videoPath!, options: .mappedIfSafe)
                        self.UpdateVideoApiCall(videoData: videoData as Data)
                    } catch {
                        print("Unable to load Video data: \(error)")
                        HideProgress()
                    }
                }
            }
        }else{
            if isValidateDetails(){
                do {
                    let videoData = try NSData(contentsOf: videoPath!, options: .mappedIfSafe)
                    addVideoApiCall(videoData: videoData as Data)
                } catch {
                    print("Unable to load Video data: \(error)")
                }
            }
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
    }
    @IBAction func btnDeleteVideo(_ sender: UIButton) {
        var videoID = 0

        if self.isFromViewController == "athlete_video"{
            videoID = objAthleteVideo?.id ?? -1
        }else if self.isFromViewController == "coach_video"{
           videoID = objCoachvideos?.id ?? -1
        }else if self.isFromViewController == "coach_own_video"{
           videoID = objCoachOwnvideos?.id ?? -1
        }


        AlertView.showAlert("", strMessage:"Are you sure want to delete?", button: ["YES","NO"], viewcontroller: self, blockButtonClicked: { (button) in
            if button == 0{
                self.DeleteVideoAPICall(strVideoID: "\(videoID)")
            }
        })
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
    
    //MARK:- UITexview delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 170/255, green: 223/255, blue: 238/255, alpha: 1.0) {
            textView.text = nil
            textView.textColor = UIColor(red: 0/255, green: 147/255, blue: 198/255, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Desciption"//It's not a sprint, it's a long marathon race, especially in basketball when it feels like the game never ends.
            textView.textColor = UIColor(red: 170/255, green: 223/255, blue: 238/255, alpha: 1.0)//UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Prevent first char as space
        let newString = (textView.text! as NSString).replacingCharacters(in: range, with: text) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && text == " "
        {
            return false
        }//Prevent first char as space
        
        return true
    }
    
    
    func playVideoAvPlayer(videoUrl: URL)
    {
        let player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    //MARK:- Video Selection
    func selectSourceForVideo()
    {
        self.view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.checkCameraAccess()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.checkLibraryUsagePermission()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openPhotoLibrary()
    {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = ["public.movie"]//UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
            imagePicker.delegate = self
            self.present(imagePicker, animated: true) {
            }
        }
    }
    
    func openCamera()
    {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = ["public.movie"]
                imagePicker.delegate = self
                self.present(imagePicker, animated: true) {
                }
            } else {
                print("No camera available")
            }
        }
    }
    
    //MARK:- API Call
    //Delete video
    func DeleteVideoAPICall(strVideoID:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.deleteVideo)
            print(url)
            
            var reqParam:[String:Any] = [:]
            reqParam["video_id"] = strVideoID
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CheckCoachBankDetailResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        self.navigationController?.popViewController(animated: true)
//                        AlertView.showMessageAlert(mapData?.message ?? "", viewcontroller: self)
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

    func getSportsListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getSports)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .get, InputParameter: [:]) { (result, IsSuccess) in
                //print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<SportsListResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.arrSportsList = data
                            if self.isFromViewController == "athlete_video"{
                                self.setAthleteVideoDetails()
                            }else if self.isFromViewController == "coach_video"{
                                self.setCoachVideoDetails()
                            }else if self.isFromViewController == "coach_own_video"{
                                self.setCoachOwnVideoDetails()
                            }
                            
                            if self.arrSportsList.count > 0 {
                                self.cvSportType.dataSource = self
                                self.cvSportType.delegate = self
                                self.cvSportType.reloadData()
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
    
    func addVideoApiCall(videoData: Data)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            var url = WebService.createURLForWebService(WebService.addVideo)
            print(url)
            var videoId = -1
            
            videoId = objCoachvideos?.id ?? -1
            url = WebService.createURLForWebService(WebService.addVideo)

            var reqParams:[String:String] = [:]
            reqParams["title"] = self.txtTitle.text!
            reqParams["description"] = self.txtvwDesc.text!
            reqParams["sport_id"] = "\(self.arrSportsList[self.selectedIndex].id!)"
            reqParams["video_id"] = videoId == -1 ? "" : "\(videoId)"

            ServiceRequestResponse.servicecallVideoUpload(isAlert: false, VC: self, videoDataFile: videoData , url: url, HttpMethod: .post, InputParameter: reqParams, isHeaderNeeded: true, ServiceCallBack: {
                (result, IsSuccess) in
                
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CommonResModel>().map(JSONString: result!)
                    if mapData?.code == "200" || Int(mapData!.code!) == 200
                    {
                        self.resetUI()
                        AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                            self.btnGoBackAction(UIButton())
                        })
                    } else {
                        AlertView.showMessageAlert(mapData?.message ?? "Invalid Email ID or Password", viewcontroller: self)
                    }
                } else {
                    HideProgress()
                }
            })
        } else {
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
    func UpdateVideoApiCall(videoData: Data)
    {
        if Reachability.isConnectedToNetwork()
        {
            
            let url = WebService.createURLForWebService(WebService.updateVideo)
            print(url)
            var videoId = -1
            var strVideoURL = ""

            
            if self.isFromViewController == "athlete_video"{
                videoId = objAthleteVideo?.id ?? -1
                strVideoURL = objAthleteVideo?.videourl ?? ""
            }else if self.isFromViewController == "coach_video"{
               videoId = objCoachvideos?.id ?? -1
                strVideoURL = objCoachvideos?.videourl ?? ""
            }else if self.isFromViewController == "coach_own_video"{
               videoId = objCoachOwnvideos?.id ?? -1
                strVideoURL = objCoachOwnvideos?.videourl ?? ""
            }
            
            
            var reqParams:[String:String] = [:]
            reqParams["title"] = self.txtTitle.text!
            reqParams["description"] = self.txtvwDesc.text!
            reqParams["sport_id"] = "\(self.arrSportsList[self.selectedIndex].id!)"
            reqParams["video_id"] = videoId == -1 ? "" : "\(videoId)"
            reqParams["videourl"] = strVideoURL

            ServiceRequestResponse.servicecallVideoUpload(isAlert: false, VC: self, videoDataFile: videoData , url: url, HttpMethod: .post, InputParameter: reqParams, isHeaderNeeded: true, ServiceCallBack: {
                (result, IsSuccess) in
                
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CommonResModel>().map(JSONString: result!)
                    if mapData?.code == "200" || Int(mapData!.code!) == 200
                    {
                        self.resetUI()
                        AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                            self.btnGoBackAction(UIButton())
                        })
                    } else {
                        AlertView.showMessageAlert(mapData?.message ?? "Invalid Email ID or Password", viewcontroller: self)
                    }
                } else {
                    HideProgress()
                }
            })
        } else {
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
    func resetUI()
    {
        self.txtvwDesc.text = "Add Desciption"
        self.txtvwDesc.textColor = UIColor(red: 170/255, green: 223/255, blue: 238/255, alpha: 1.0)
        self.btnRemoveVideoAction(UIButton())
    }
    
    //MARK:- Camera and photo library access check
    func checkLibraryUsagePermission()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized)
        {
            // Access has been granted.
            self.openPhotoLibrary()
        }
        else if (status == PHAuthorizationStatus.denied)
        {
            self.presentLibraryUsageSettings()
        }
        else if (status == PHAuthorizationStatus.notDetermined)
        {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.openPhotoLibrary()
                }
                else {
                }
            })
        }
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    func presentLibraryUsageSettings()
    {
        let alertController = UIAlertController(title: "Error", message: "Enable Photo Library permissions in settings", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings as URL)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
            self.openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    self.openCamera()
                } else {
                    print("Permission denied")
                }
            }
        }
    }
    
    func presentCameraSettings()
    {
        let alertController = UIAlertController(title: "Error",
                                                message: "Enable Camera permissions in settings",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        
        present(alertController, animated: true)
    }
    
    //MARK:- ImagePicker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if #available(iOS 11.0, *) {
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                
                getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
                    if thumbImage != nil {
                        self.ivVideoThumb.image = thumbImage
                        self.vwVideoContent.isHidden = false
                        self.vwVideoUpload.isHidden = true
                        self.vwVideoMainHeight.constant = 160
                    } else {
                        self.vwVideoContent.isHidden = true
                        self.vwVideoUpload.isHidden = false
                        self.vwVideoMainHeight.constant = 115
                    }
                }
                
                let avAsset = AVURLAsset(url: url, options: nil)
                avAsset.exportVideo(presetName: AVAssetExportPresetHighestQuality, outputFileType: AVFileType.mp4, fileExtension: "mp4") { (mp4Url) in
                    print("Mp4 converted url : \(String(describing: mp4Url))")
                    self.videoPath = mp4Url//videoURL//
                    
                }
            } else {
                self.vwVideoContent.isHidden = true
                self.vwVideoUpload.isHidden = false
                self.vwVideoMainHeight.constant = 115
            }
        } else {
            if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                
                getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
                    if thumbImage != nil {
                        self.ivVideoThumb.image = thumbImage
                        self.vwVideoContent.isHidden = false
                        self.vwVideoUpload.isHidden = true
                        self.vwVideoMainHeight.constant = 160
                    } else {
                        self.vwVideoContent.isHidden = true
                        self.vwVideoUpload.isHidden = false
                        self.vwVideoMainHeight.constant = 115
                    }
                }
                let avAsset = AVURLAsset(url: url, options: nil)
                avAsset.exportVideo(presetName: AVAssetExportPresetHighestQuality, outputFileType: AVFileType.mp4, fileExtension: "mp4") { (mp4Url) in
//                    print("Mp4 converted url : \(mp4Url)")
                    self.videoPath = mp4Url//videoURL//
                }
            } else {
                self.vwVideoContent.isHidden = true
                self.vwVideoUpload.isHidden = false
                self.vwVideoMainHeight.constant = 115
            }
        }
        self.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- UICollectionView datasource delegate methods
//MARK:-
extension CoachVideoUploadVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSportsList.count//self.arrSportsType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCategoriesCell", for: indexPath) as! FilterCategoriesCell
        
        let sport = self.arrSportsList[indexPath.item]
        
        cell.btnCategory.setTitle(sport.title!, for: .normal)//.setTitle(self.arrCategories[indexPath.item], for: .normal)
       
        if indexPath.item == self.selectedIndex {
            addGradientBackground(view: cell.btnCategory, gradientColors: [UIColor.blueGradientDark.cgColor, UIColor.blueGradientLight.cgColor], direction: .leftRight)
            cell.btnCategory.setTitleColor(UIColor.white, for: .normal)
        } else {
            cell.btnCategory.layer.removeAllGradiantLayers()
            cell.btnCategory.setTitleColor(UIColor.blueGradientDark, for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 20) / 3, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        self.cvSportType.reloadData()
    }
    
    func setSportTypeCollHeight()
    {
        if self.arrSportsList.count < 4 {
            self.cvSportTypeHeight.constant = 40
        } else if self.arrSportsList.count < 7 {
            self.cvSportTypeHeight.constant = 90
        } else {
            self.cvSportTypeHeight.constant = 140
        }
    }
}

//MARK:- Validations
extension CoachVideoUploadVC{
    //MARK:- Validation
    func isValidateDetails() -> Bool{
        if (videoPath == nil){
            AlertView.showMessageAlert(AlertMessage.emptyNewVideo, viewcontroller: self)
            return false
        }
        if txtTitle.text!.isEmpty{
            AlertView.showMessageAlert(AlertMessage.emptyNewVideoTitle, viewcontroller: self)
            return false
        }
        if txtvwDesc.text.isEmpty{
            AlertView.showMessageAlert(AlertMessage.emptyNewVideoDesc, viewcontroller: self)
            return false
        }
        if self.selectedIndex == -1{
            AlertView.showMessageAlert(AlertMessage.emptyNewVideoSportCate, viewcontroller: self)
            return false
        }
        
        return true
    }
}
