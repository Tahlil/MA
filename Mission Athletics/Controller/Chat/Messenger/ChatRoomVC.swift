//
//  ChatRoomVC.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 18/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import Alamofire
import AVFoundation
import AVKit
import ISEmojiView
import IQKeyboardManagerSwift
import MobileCoreServices
import ObjectMapper
import Optik
import SDWebImage
import SocketIO
import SVProgressHUD
import UIKit
import ReverseExtension

class ChatRoomVC: UIViewController
{
    var isFromCompose = false
    var composeMsg = ""
    var userDataFrnd = FriendListDataModel()
    
    @IBOutlet weak var scrollMsgList: UIScrollView!
    @IBOutlet weak var tblMessege: UITableView!
    @IBOutlet weak var txtvwMessage: GrowingTextView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblOnStatus: UILabel!
    @IBOutlet weak var vwTopBarView: UIView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var arrMessageList = [MessageModel]()
    var objChatUser:ChatUserDataModel?
    var pageLimit:Int = 20
    var pageNumber:Int = 1
    var pageNext:Int = 0

    let userDeatails = getUserInfo()
    
    var socket: SocketIOClient!
    var manager = SocketManager(socketURL: URL(string: "\(WebService.LivesocketUrl)")!)
    
    var isImageSelection = false
    var videoPath: URL?
    var isInitiallyLoaded = false
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMessege.re.dataSource = self
        tblMessege.re.delegate = self
        tblMessege.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
            if ((self.tblMessege.contentOffset.y + self.tblMessege.frame.size.height) >= self.tblMessege.contentSize.height)
            {
                if self.pageNumber < self.pageNext{
                    AppData.showLoaderInFooter(on: self.tblMessege)

                    self.pageNumber += 1
                    print("PAGination")
                    self.getSocketMessagesHistory(intPage: self.pageNumber)
                }else{
                    AppData.hideLoaderInFooter(on: self.tblMessege)
                }
            }
        }
        tblMessege.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }

        if self.isFromCompose {
            lblUserName.text = self.userDataFrnd.name!
            lblOnStatus.text = ""
            if self.userDataFrnd.userimage != nil {
                if let imgURL = URL(string: self.userDataFrnd.userimage!) {
                    self.imgProfile.sd_setImage(with: imgURL, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
                } else {
                    self.imgProfile.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                }
            } else {
                self.imgProfile.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
            }
        } else {
            lblUserName.text = objChatUser?.receiver_name
            lblOnStatus.text = objChatUser?.is_online == "1" ? "Online" : ""//"Offline"
            
            if objChatUser?.profile_pic != nil {
                if let imgURL = URL(string: (objChatUser?.profile_pic)!) {
                    self.imgProfile.sd_setImage(with: imgURL, placeholderImage: UIImage(named: DefaultValues.USER_PLACEHOLDER), options: .refreshCached, completed: nil)
                } else {
                    self.imgProfile.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
                }
            } else {
                self.imgProfile.image = UIImage(named: DefaultValues.USER_PLACEHOLDER)
            }
        }
        
        let userData = getUserInfo()
        let strUserID = "\(String(describing: userData?.id ?? 0))"
        
        manager = SocketManager(socketURL: URL(string: "\(WebService.LivesocketUrl)")!, config: [.path("\(WebService.LivesocketNode)"),.connectParams(["user_id":strUserID]), .reconnects(false)])
        socket = manager.defaultSocket
        
        pageNumber = 1
        SocketaddHandlers()
        
        txtvwMessage.delegate = self
        vwTopBarView.setNavigationShadow
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ChatRoomVC.changeInputMode(_:)),
                                               name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
        //UITextInputCurrentInputModeDidChange
        
        tblMessege.register(UINib.init(nibName: "MessegeSenderTextCell", bundle: nil), forCellReuseIdentifier: "MessegeSenderTextCell")
        tblMessege.register(UINib.init(nibName: "MessegeReciverTextCell", bundle: nil), forCellReuseIdentifier: "MessegeReciverTextCell")
        tblMessege.register(UINib.init(nibName: "MessegeSenderImageCell", bundle: nil), forCellReuseIdentifier: "MessegeSenderImageCell")
        tblMessege.register(UINib.init(nibName: "MessegeReciverImageCell", bundle: nil), forCellReuseIdentifier: "MessegeReciverImageCell")
        tblMessege.register(UINib.init(nibName: "MessegeSenderVideoCell", bundle: nil), forCellReuseIdentifier: "MessegeSenderVideoCell")
        tblMessege.register(UINib.init(nibName: "MessegeReciverVideoCell", bundle: nil), forCellReuseIdentifier: "MessegeReciverVideoCell")
        tblMessege.register(UINib.init(nibName: "MessegeSenderFileCell", bundle: nil), forCellReuseIdentifier: "MessegeSenderFileCell")
        tblMessege.register(UINib.init(nibName: "MessegeReciverFileCell", bundle: nil), forCellReuseIdentifier: "MessegeReciverFileCell")
        
        tblMessege.estimatedRowHeight = 40.0
        tblMessege.rowHeight = UITableView.automaticDimension
    }
    
    
    override open var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
    
    override open var prefersStatusBarHidden: Bool
    {
        return false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        GlobalConstants.appDelegate.isChatDetailScreenOpen = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        GlobalConstants.appDelegate.isChatDetailScreenOpen = false
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    //MARK:- IBActions
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MessengerVC.self) {
                self.tabBarController?.tabBar.isHidden = false
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func btnAddPhotoAndVideo(_ sender: UIButton) {
        self.view.endEditing(true)
        self.ChooseToAddVideoImageFile()
    }
    
    @IBAction func btnSendMessege(_ sender: UIButton) {
        
        if !txtvwMessage.text.isEmpty{
            sendMessage(strMessage: self.txtvwMessage.text!, strType: "Text")
        }
    }
    
    @IBAction func btnDotMenu(_ sender: UIButton) {
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        txtvwMessage.inputView = emojiView
        txtvwMessage.becomeFirstResponder()
    }
    
    @IBAction func btnEmojiPressed(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if sender.isSelected {
            sender.isSelected = false
            txtvwMessage.inputView = nil
            txtvwMessage.becomeFirstResponder()
        } else {
            sender.isSelected = true
            let keyboardSettings = KeyboardSettings(bottomType: .categories)
            let emojiView = EmojiView(keyboardSettings: keyboardSettings)
            emojiView.translatesAutoresizingMaskIntoConstraints = false
            emojiView.delegate = self
            txtvwMessage.inputView = emojiView
            txtvwMessage.becomeFirstResponder()
        }
    }
    
    @IBAction func btnViewUserProfile(_ sender: UIButton) {
        if let userData = getUserInfo() {
            if userData.user_type == 2 {//Coach
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "CoachProfileVC") as! CoachProfileVC
                nextVC.isFromAthlete = false
                nextVC.isFromOtherUser = true
                nextVC.userId = objChatUser?.receiver ?? 0
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                let nextVC = GlobalConstants.ProfileStoryboard.instantiateViewController(withIdentifier: "AthleteProfileVC") as! AthleteProfileVC
                nextVC.isFromOtherUser = true
                nextVC.isFromCoachHomeList = true
                nextVC.userId = objChatUser?.receiver ?? 0
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}

//MARK:- UITableView datasource delegate methods
extension ChatRoomVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessageList.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let objData = arrMessageList[indexPath.row]
        
        let strMessageType = objData.attachment_type
        let strSendID = "\(String(describing: objData.sender_id))"
        if strMessageType == .Image {
            if strSendID == "\(String(describing: userDeatails?.id))" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeSenderImageCell", for: indexPath) as! MessegeSenderImageCell
                
                cell.SetMessageData(objData)
                cell.btnImgPreview.tag = indexPath.row
                cell.btnImgPreview.addTarget(self, action: #selector(self.ImagePreview(sender:)), for: .touchUpInside)
                cell.selectionStyle = .none
             
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeReciverImageCell", for: indexPath) as! MessegeReciverImageCell
              
                cell.SetMessageData(objData)
                cell.btnImgPreview.tag = indexPath.row
                cell.btnImgPreview.addTarget(self, action: #selector(self.ImagePreview(sender:)), for: .touchUpInside)
                cell.selectionStyle = .none
              
                return cell
            }
        } else if strMessageType == .Video {
            
            if strSendID == "\(String(describing: userDeatails?.id))" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeSenderVideoCell", for: indexPath) as! MessegeSenderVideoCell
               
                cell.SetMessageData(objData)
                cell.btnPlay.tag = indexPath.row
                cell.btnPlay.addTarget(self, action: #selector(PlayVideo(sender:)), for: .touchUpInside)
                cell.selectionStyle = .none
      
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeReciverVideoCell", for: indexPath) as! MessegeReciverVideoCell
            
                cell.SetMessageData(objData)
                cell.btnPlay.tag = indexPath.row
                cell.btnPlay.addTarget(self, action: #selector(PlayVideo(sender:)), for: .touchUpInside)
                cell.selectionStyle = .none
           
                return cell
            }
        }else if strMessageType == .File {
            
            if strSendID == "\(String(describing: userDeatails?.id))" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeSenderFileCell", for: indexPath) as! MessegeSenderFileCell
              
                cell.SetMessageData(objData)
                cell.btnViewDocument.tag = indexPath.row
                cell.btnViewDocument.addTarget(self, action: #selector(self.btnPreviewDocAction(sender:)), for: .touchUpInside)
             
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeReciverFileCell", for: indexPath) as! MessegeReciverFileCell
             
                cell.SetMessageData(objData)
                cell.btnViewDocument.tag = indexPath.row
                cell.btnViewDocument.addTarget(self, action: #selector(self.btnPreviewDocAction(sender:)), for: .touchUpInside)
                cell.selectionStyle = .none
              
                return cell
            }
        }else{
            if strSendID == "\(String(describing: userDeatails?.id))" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeSenderTextCell", for: indexPath) as! MessegeSenderTextCell
              
                cell.SetMessageData(objData)

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeReciverTextCell", for: indexPath) as! MessegeReciverTextCell
             
                cell.SetMessageData(objData)
              
                return cell
            }
        }
    }
    
    //MARK:- Image preview
    func imagePreview(imgUrl:URL){
        let urls = [imgUrl]
        let imageDownloader = AlamofireImageDownloader()
        let viewController = Optik.imageViewer(withURLs: urls, imageDownloader: imageDownloader)
        present(viewController, animated: true, completion: nil)
    }
    
    //MARK:- objc methods
    @objc func PlayVideo(sender:UIButton){
        let objData = arrMessageList[sender.tag]
        if let videoUrl = URL.init(string: objData.attachment_path ?? ""){
            playVideoAvPlayerViewController(videoUrl:videoUrl)
        }
    }
    
    @objc func ImagePreview(sender:UIButton){
        let objData = arrMessageList[sender.tag]
        if let imgUrl = URL.init(string: objData.attachment_path ?? ""){
            imagePreview(imgUrl: imgUrl)
        }
    }
    
    @objc func changeInputMode(_ notification: Notification)
    {
        let inputMethod = UITextInputMode.activeInputModes.description
        print("keyboard changed to \(inputMethod.description)")
    }
    
    @objc func btnPreviewDocAction(sender: UIButton)
    {
        let objData = arrMessageList[sender.tag]
        if let fileUrlStr = objData.attachment_path {//URL.init(string: objData.attachment_path ?? ""){
            if let nextVC = GlobalConstants.ChatStoryboard.instantiateViewController(withIdentifier: "ViewDocumentVC") as? ViewDocumentVC {
                nextVC.fileUrlStr = fileUrlStr
                if let fileName = fileUrlStr.components(separatedBy: "/").last {
                    nextVC.fileName = fileName
                }
                self.present(nextVC, animated: true, completion: nil)
            }
        }
    }
    
    func appendLatestMessage(arrMessages : [[String: AnyObject]], isReceive: Bool){
        let messageData = arrMessages[0]
        let newMessage = messageData["text"] as! String
        print(newMessage)
        let serviceResponse = Mapper<ReceiveMessageModel>().map(JSONString: newMessage)
        
        let objJson = serviceResponse?.ReceiverLastMessage?.toJSON()
//        let msgModel = MessageModel(JSON: objJson!)!
        
      //  var isMsgAlreadyAppended = false
//        for msg in self.arrMessageList {
//            if msg.id == msgModel.id
//            {
//              //  isMsgAlreadyAppended = true
//                break
//            }
//        }
        //        if isMsgAlreadyAppended == false {
        self.arrMessageList.append(MessageModel(JSON: objJson!)!)
        //        }
        self.tblMessege.reloadData()
//        self.tblMessege.layoutIfNeeded()
//        self.tblMessege.scrollToBottom()
    }
    
    func addDummyObject(message:String){

        let obj = MessageModel()
        
        obj?.chat_id = "67"
        obj?.created_at = "2020-03-11T13:33:25.000Z"
        obj?.id = "1"
        obj?.is_read = "1"
        obj?.message = message
        obj?.receiver_id = ""
        obj?.sender_id = ""
        obj?.attachment_path = ""
        obj?.attachment_type = messageType.Video
        obj?.thumbnail = ""

        
        self.arrMessageList.append(obj!)
        self.tblMessege.reloadData()
        self.tblMessege.layoutIfNeeded()
        self.tblMessege.scrollToBottom()

    }
    
}

//MARK:- UITextView delegate methods
extension ChatRoomVC:GrowingTextViewDelegate, UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            let bottomOffset = CGPoint(x: 0, y: self.scrollMsgList.contentSize.height - self.scrollMsgList.bounds.size.height)
            self.scrollMsgList.setContentOffset(bottomOffset, animated: true)
            self.view.layoutIfNeeded()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Prevent first char as space
        let newString = (textView.text! as NSString).replacingCharacters(in: range, with: text) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && text == " "
        {
            return false
        }//Prevent first char as space
        
        var updatedTxt = ""
        if let txt = textView.text, let textRange = Range(range, in: txt)
        {
            let updatedText = txt.replacingCharacters(in: textRange, with: text)
            updatedTxt = updatedText
        }
        
        if updatedTxt.count > 0 {
            sendTypingStatus()
        } else {
            //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            //                lblOnStatus.text = objChatUser?.is_online == true ? "Online" : ""//"Offline"
            //            }
        }
        
        self.view.setNeedsLayout()
        
        return true
    }
}

//MARK:- Camera and gallery funcationlity
extension ChatRoomVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func ChooseToAddVideoImageFile()
    {
        let alert = UIAlertController(title: "Select type of attachment", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { _ in
            self.isImageSelection = true
            self.ClickCameraAndGalary()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.isImageSelection = false
            self.ClickCameraAndGalaryVideo()
        }))
        
        alert.addAction(UIAlertAction(title: "File", style: .default, handler: { _ in
            self.openDocumentPicker()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func ClickCameraAndGalaryVideo()
    {
        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func ClickCameraAndGalary()
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Camera
    func openCamera()
    {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                if self.isImageSelection {
                    imagePicker.mediaTypes = ["public.image"]
                } else {
                    imagePicker.mediaTypes = ["public.movie"]
                }
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Gallary
    func openGallery()
    {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                if self.isImageSelection {
                    imagePicker.mediaTypes = ["public.image"]
                } else {
                    imagePicker.mediaTypes = ["public.movie"]
                }
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Open Document Picker
    func openDocumentPicker()
    {
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.composite-content"], in: .import)//"com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key", "public.item", "public.content", "public.text", "public.data",
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK:- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if self.isImageSelection {
            if let pickedImage = info[.editedImage] as? UIImage {
                // imageViewPic.contentMode = .scaleToFill
                let baseEncode = pickedImage.toBase64()
                SVProgressHUD.show()

                self.uploadImage(strImage: baseEncode!)
            }
        } else {
            
            if #available(iOS 11.0, *) {
                if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    // print(getVideoThumbFrom(url: url))
                    let imageEncode = getVideoThumbFrom(url: url)!.toBase64()
                    let avAsset = AVURLAsset(url: url, options: nil)
                    avAsset.exportVideo(presetName: AVAssetExportPresetHighestQuality, outputFileType: AVFileType.mp4, fileExtension: "mp4") { (mp4Url) in
                        print("Mp4 converted url : \(String(describing: mp4Url))")
                        self.videoPath = mp4Url//videoURL//
                        SVProgressHUD.show()
//                        self.addDummyObject(message: (mp4Url?.absoluteString.lastPathComponent)!)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                            do {
                                if self.videoPath != nil {
                                    
                                    let videoData = try NSData(contentsOf: self.videoPath!, options: .mappedIfSafe)
                                    let videoEncode = (videoData as Data).base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                                    self.uploadVideo(strImage: imageEncode!, strVideo: videoEncode)
                                    // as! @convention(block) () -> Void
                                }
                            } catch {
                                print("Unable to load video data: \(error)")
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
            } else {
                if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    // print(getVideoThumbFrom(url: url))
                    let imageEncode = getVideoThumbFrom(url: url)!.toBase64()
                    let avAsset = AVURLAsset(url: url, options: nil)
                    SVProgressHUD.show()

                    avAsset.exportVideo(presetName: AVAssetExportPresetHighestQuality, outputFileType: AVFileType.mp4, fileExtension: "mp4") { (mp4Url) in
                        //    print("Mp4 converted url : \(mp4Url)")
                        self.videoPath = mp4Url//videoURL//
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                            do {
                                if self.videoPath != nil {
                                    
                                    let videoData = try NSData(contentsOf: self.videoPath!, options: .mappedIfSafe)
                                    let videoEncode = (videoData as Data).base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                                    self.uploadVideo(strImage: imageEncode!, strVideo: videoEncode)
                                    // as! @convention(block) () -> Void
                                }
                            } catch {
                                print("Unable to load video data: \(error)")
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getVideoThumbFrom(url: URL) -> UIImage? {
        do {
            return try UIImage(cgImage: previewImageFromVideo(url: url))
        } catch {
            print(error)
            return nil
        }
    }
    
    func previewImageFromVideo(url: URL) throws -> CGImage {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: url))
        imageGenerator.appliesPreferredTrackTransform = true
        return try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 2), actualTime: nil)
    }
}

extension ChatRoomVC: UIDocumentPickerDelegate, UIDocumentMenuDelegate
{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        SVProgressHUD.show()
        print("import result : \(myURL)")
        if let urlCompoFileName = myURL.absoluteString.components(separatedBy: "/").last {
            if let fileCompoExtension = urlCompoFileName.components(separatedBy: ".").last {
                print("File extension :- \(fileCompoExtension)")
                
                let fileName = urlCompoFileName.components(separatedBy: ".").first
                do {
                    let fileData = try NSData(contentsOf: myURL, options: .mappedIfSafe)
                    let fileEncode = (fileData as Data).base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                    
                    self.uploadFile(strDoc: fileEncode, strFileName: fileName ?? "", strDocType: fileCompoExtension)
                } catch {
                    print("Unable to load file data: \(error)")
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("Document picker was cancelled")
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- EmojiView delegate methods
extension ChatRoomVC : EmojiViewDelegate
{
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        txtvwMessage.insertText(emoji)
    }
    
    // callback when tap change keyboard button on keyboard
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        txtvwMessage.inputView = nil
        txtvwMessage.keyboardType = .default
        txtvwMessage.reloadInputViews()
    }
    
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        txtvwMessage.deleteBackward()
    }
    
    // callback when tap dismiss button on keyboard
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        txtvwMessage.resignFirstResponder()
    }
}

//MARK:- SOCKET EVENT HANDLER -
extension ChatRoomVC
{
    func SocketaddHandlers()
    {
        SVProgressHUD.dismiss()
        let userData = getUserInfo()
        
        //Socket connection events
        socket.on(clientEvent: .connect) { (data, ack) in
            if !self.isFromCompose {
                self.getSocketMessagesHistory(intPage: self.pageNumber)
            } else {
                if self.composeMsg == ""{
                    self.getSocketMessagesHistory(intPage: self.pageNumber)
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        // your code here
                        self.sendMessage(strMessage: self.composeMsg, strType: "Text")
                        self.isFromCompose = false

                    }
                }
            }
        }
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            SVProgressHUD.dismiss()
            print("Socket disconnect response :- \(data)")
            SVProgressHUD.dismiss()
        }
        
        socket.on(clientEvent: .error) { (data, ack) in
            SVProgressHUD.dismiss()
            print("Socket response error :- \(data)")
            SVProgressHUD.dismiss()
            if self.composeMsg != ""{
                self.composeMsg = ""
                AlertView.showMessageAlert("Sorry, we could not upload this file. please try again later.", viewcontroller: self)
            }
            
        }
        
        socket.on("messageRecieve-\(userData?.id ?? 0)") { (dataArray, socketAck) -> Void in
            print("receiving.....")
            
            self.appendLatestMessage(arrMessages: dataArray as! [[String : AnyObject]], isReceive: true)
        }
        
        socket.on("messageSenderAck-\(userData?.id ?? 0)") { (dataArray, socketAck) -> Void in
            print("receiving.....")
            
            self.appendLatestMessage(arrMessages: dataArray as! [[String : AnyObject]], isReceive: true)
        }
        
        socket.on("typing-\(objChatUser?.receiver ?? 0)") { (dataArray, socketAck) -> Void in
            print("receiving..... \(dataArray)")
            self.lblOnStatus.text = "Typing..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                self.lblOnStatus.text = self.objChatUser?.is_online == "1" ? "Online" : ""//"Offline"
            }
        }
        
        socket.connect()
    }
    
    func getSocketMessagesHistory(intPage: Int){
        if self.isInitiallyLoaded == false{
            SVProgressHUD.show()
        }
        let userData = getUserInfo()
        let UDID = UIDevice.current.identifierForVendor!.uuidString
        
        let objReqModdel : ChatDetailReqModel = ChatDetailReqModel()
        objReqModdel.userid = userData?.id
        objReqModdel.chat_id = self.isFromCompose == true ? self.userDataFrnd.chat_id : objChatUser?.id
        objReqModdel.device_id = UDID
        objReqModdel.page = intPage
        objReqModdel.limit = self.pageLimit
        
        let jsonString = Mapper().toJSONString(objReqModdel)

        socket.emit("chatHistory", jsonString!)
            socket.on("chatHistory-\(UDID)"){ (dataArray, socketAck) -> Void in
                print(dataArray)
                self.socket.off("chatHistory-\(UDID)")

                SVProgressHUD.dismiss()
                
                
                let messageData = Mapper<ChatDetailsModel>().map(JSON: dataArray[0] as! [String : Any])
                self.pageNext = messageData?.next_page ?? 0
                
                
                if messageData?.messages?.count ?? 0 == 0{
                    self.pageNext = -1
                    AppData.hideLoaderInFooter(on: self.tblMessege)

                }else{
                    if self.arrMessageList.count > 0 {
                        let oldArrMessages = self.arrMessageList
                        self.arrMessageList.removeAll()// = []
                        
                        for itemMessages in messageData?.messages ?? [] {
                            self.arrMessageList.append(itemMessages)
                        }
                        
                        for itemMessages in oldArrMessages {
                            self.arrMessageList.append(itemMessages)
                        }
                    } else {
                        self.arrMessageList.removeAll()
                        self.arrMessageList = messageData?.messages ?? []
                    }
                }
                
                self.tblMessege.reloadData()
                
                AppData.hideLoaderInHeader(on: self.tblMessege)
                if self.isInitiallyLoaded == false{
                    self.isInitiallyLoaded = true
                }
            }
    }
    
    func sendTypingStatus(){
        
        let userData = getUserInfo()
        
        let objReqModdel: TypingModel = TypingModel()!
        objReqModdel.sender_id = userData?.id! ?? 0
        let jsonString = Mapper().toJSONString(objReqModdel)
        
        socket.emit("typing", jsonString!)
    }
    
    func uploadImage(strImage:String){
        let userData = getUserInfo()
        
        print("Upload image called")
        
        let objReqModdel : ChatImageVideoDetailReqModel = ChatImageVideoDetailReqModel()
        objReqModdel.sender_id = userData?.id
        objReqModdel.chat_id = self.isFromCompose == true ? self.userDataFrnd.chat_id : objChatUser?.id
        objReqModdel.receiver_id = self.isFromCompose == true ? self.userDataFrnd.id : objChatUser?.receiver
        objReqModdel.type = "Image"
        objReqModdel.format = "Image"
        objReqModdel.reader = "data:image/png;base64," + strImage
        objReqModdel.filename = "Image\(Int.random(in: 0...2000000)).jpg"
        
        let jsonString = Mapper().toJSONString(objReqModdel)
        let userid = userData?.id
        socket.emit("upload-image", jsonString!)
        self.socket.on("image-uploaded-\(userid ?? 0)"){ (dataArray, socketAck) -> Void in
            print(dataArray)
            SVProgressHUD.dismiss()

            self.socket.off("image-uploaded-\(userid ?? 0)")
            self.socket.emit("messageSend", dataArray)
        }
    }
    
    func uploadVideo(strImage:String, strVideo:String){
        let userData = getUserInfo()
        
        let objReqModdel : ChatImageVideoDetailReqModel = ChatImageVideoDetailReqModel()
        objReqModdel.sender_id = userData?.id
        objReqModdel.chat_id = self.isFromCompose == true ? self.userDataFrnd.chat_id : objChatUser?.id
        objReqModdel.receiver_id = self.isFromCompose == true ? self.userDataFrnd.id : objChatUser?.receiver
        objReqModdel.type = "Video"
        objReqModdel.format = "Video"
        objReqModdel.reader = "data:video/mp4;base64," + strVideo
        objReqModdel.thumbnail = "data:image/png;base64," + strImage
        objReqModdel.filename = "Video-\(Int.random(in: 0...2000000)).mp4"
        
        let jsonString = Mapper().toJSONString(objReqModdel)
        let userid = userData?.id
        
        socket.emit("upload-image", jsonString!)
        self.socket.on("image-uploaded-\(userid ?? 0)"){ (dataArray, socketAck) -> Void in
            print(dataArray)
            SVProgressHUD.dismiss()
//            self.arrMessageList.removeLast()
//            self.tblMessege.reloadData()
//            self.tblMessege.layoutIfNeeded()
//            self.tblMessege.scrollToBottom()

            self.socket.off("image-uploaded-\(userid ?? 0)")
            self.socket.emit("messageSend", dataArray)
        }
    }
    
    func uploadFile(strDoc:String, strFileName: String, strDocType: String){
        let userData = getUserInfo()
        
        let objReqModdel : ChatImageVideoDetailReqModel = ChatImageVideoDetailReqModel()
        objReqModdel.sender_id = userData?.id
        objReqModdel.chat_id = self.isFromCompose == true ? self.userDataFrnd.chat_id : objChatUser?.id
        objReqModdel.receiver_id = self.isFromCompose == true ? self.userDataFrnd.id : objChatUser?.receiver
        objReqModdel.type = "File"
        objReqModdel.format = "File"
        objReqModdel.reader = "data:file/\(strDocType);base64," + strDoc
        objReqModdel.filename = "\(strFileName).\(strDocType)"
        
        let jsonString = Mapper().toJSONString(objReqModdel)
        let userid = userData?.id
        
        socket.emit("upload-image", jsonString!)
        
        self.socket.on("image-uploaded-\(userid ?? 0)"){ (dataArray, socketAck) -> Void in
            print(dataArray)
            SVProgressHUD.dismiss()
            self.socket.off("image-uploaded-\(userid ?? 0)")
            self.socket.emit("messageSend", dataArray)
        }
    }
    
    func sendMessage(strMessage: String,strType:String)
    {
        let userDeatails = getUserInfo()
        
        let objReqModdel : SendMessageReqModel = SendMessageReqModel()
        objReqModdel.sender_id = userDeatails?.id
        objReqModdel.chat_id = self.isFromCompose == true ? self.userDataFrnd.chat_id : objChatUser?.id
        objReqModdel.receiver_id = self.isFromCompose == true ? self.userDataFrnd.id : objChatUser?.receiver
        objReqModdel.message = strMessage//self.txtvwMessage.text
        objReqModdel.attachment_type = strType
        
        let jsonString = Mapper().toJSONString(objReqModdel)
        socket.emit("messageSend", jsonString!)
        self.txtvwMessage.text = ""
        //self.view.endEditing(true)
    }
}
