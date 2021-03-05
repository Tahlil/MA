//
//  EditCoachProfileVC.swift
//  Mission Athletics
//
//  Created by apple on 09/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftValidators
import Photos
import IQKeyboardManagerSwift

class EditCoachProfileVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var btnProPic: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAccountName: UITextField!
    @IBOutlet weak var txtvwShortBio: UITextView!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtExperience: UITextField!
    @IBOutlet weak var txtvwPositionsPlayed: UITextView!
    
    var oldUserInfo: GetProfileDataModel!
    let datePicker = UIDatePicker()
    var experiencePickerData = ["1 Year", "2 Years", "3 Years", "4 Years", "5 Years", "5+ Years"]
    let experiencePicker = UIPickerView()
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDatePicker()
        self.setExperiencePicker()
        self.getProfileAPICall()
        self.makeFieldsEditable(bool: true)
        self.txtBirthday.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.btnDoneBirthday(sender:)))
        // Do any additional setup after loading the view.
    }
    
    //MARK:- objc methods
    @objc func birthdayDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.yyyy_MM_dd//"dd/MM/yyyy"
        self.txtBirthday.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func btnDoneBirthday(sender: Any)
    {
        if self.txtBirthday.text!.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat.yyyy_MM_dd//"dd/MM/yyyy"
            self.txtBirthday.text = dateFormatter.string(from: self.datePicker.date)
        }
    }

    //MARK:- IBActions -
    @IBAction func btnEditAction(_ sender: UIButton)
    {
//        self.makeFieldsEditable(bool: true)
    }
    
    @IBAction func btnChangePicAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        print("btn tapped")
        self.selectSourceForImage()
    }
    
    @IBAction func btnSaveChangesAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
//        self.makeFieldsEditable(bool: false)
        if self.isValidate() {
            if let data = self.ivUser.image?.jpegData(compressionQuality: 0.5) {
                self.editProfileApiCall(imageData: data)
            } else {
                self.editProfileApiCall(imageData: nil)
            }
        }
    }
    
    //MARK:- UITextfield delegate -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtExperience{
            if self.txtExperience.text!.isEmpty {
                self.txtExperience.text = self.experiencePickerData[0]
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space
        
        var updatedTxt = ""
        if let text = textField.text, let textRange = Range(range, in: text)
        {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            updatedTxt = updatedText
        }
        
        if textField == self.txtMobile {
            if let char = string.cString(using: String.Encoding.utf8)
            {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    if updatedTxt.count > 15 {
                        return false
                    } else {
                        return true
                    }
                } else {
                    if updatedTxt.count > 15 {
                        return false
                    } else {
                        return true
                    }
                }
            }
        }
        
        if textField == self.txtEmail
        {
            // Block multiple dot
//            if (textField.text?.contains("."))! && string == "." {
//                return false
//            }
//            // Block multiple @
//            if (textField.text?.contains("@"))! && string == "@" {
//                return false
//            }
        }
        
        return true
    }
    
    //MARK:- UITexview delegate methods -
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Prevent first char as space
        let newString = (textView.text! as NSString).replacingCharacters(in: range, with: text) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && text == " "
        {
            return false
        }//Prevent first char as space
        
        if textView.text.count + (text.count - range.length) == 250 {
            return false
        }
        
        return true
    }
    
    //MARK:- API Call -
    func getProfileAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getProfile)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<GetProfileResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            self.oldUserInfo = data
                            if let imgUrl = URL(string: data.image ?? "") {
                                self.ivUser.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "User_Placeholder_ChatList"), options: .refreshCached, completed: { (image, error, cacheType, url) in
                                    if error != nil {
                                        print(error!.localizedDescription)
                                    }
                                })
                            } else {
                                self.ivUser.image = UIImage(named: "User_Placeholder_ChatList")
                            }
                            
                            self.txtName.text = data.name ?? ""
                            self.txtvwShortBio.text = data.description ?? ""
                            self.txtBirthday.text = data.birth_date ?? ""
                            self.txtEmail.text = data.email ?? ""
                            self.txtMobile.text = data.mobile_no ?? ""
                            self.txtExperience.text = data.experience ?? ""
                            self.txtvwPositionsPlayed.text = data.position ?? ""
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
    
    //MARK: Edit Profile
    func editProfileApiCall(imageData: Data? = nil)
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.editProfile)
            print(url)
            
            var reqParams:[String:String] = [:]
            if self.oldUserInfo.name != nil {
                if self.oldUserInfo.name! != self.txtName.text! {
                    reqParams["name"] = self.txtName.text!
                }
            } else {
                reqParams["name"] = self.txtName.text!
            }
            
            if self.oldUserInfo.position != nil {
                if self.oldUserInfo.position! != self.txtvwPositionsPlayed.text ?? "" {
                    reqParams["position"] = self.txtvwPositionsPlayed.text!
                }
            } else {
                reqParams["position"] = self.txtvwPositionsPlayed.text!
            }
            
            if self.oldUserInfo.description != nil {
                if self.oldUserInfo.description! != self.txtvwShortBio.text ?? "" {
                    reqParams["description"] = self.txtvwShortBio.text!
                }
            } else {
                reqParams["description"] = self.txtvwShortBio.text!
            }
            
            if self.oldUserInfo.experience != nil {
                if self.oldUserInfo.experience! != self.txtExperience.text! {
                    reqParams["experience"] = self.txtExperience.text!
                }
            } else {
                reqParams["experience"] = self.txtExperience.text!
            }
            
            if self.oldUserInfo.mobile_no != nil {
                if self.oldUserInfo.mobile_no! != self.txtMobile.text! {
                    reqParams["mobile_no"] = self.txtMobile.text!
                }
            } else {
                reqParams["mobile_no"] = self.txtMobile.text!
            }
            
            if self.oldUserInfo.birth_date != nil {
                if self.oldUserInfo.birth_date! != self.txtBirthday.text! {
                    reqParams["birth_date"] = self.txtBirthday.text!
                }
            } else {
                reqParams["birth_date"] = self.txtBirthday.text!
            }
            
            if self.oldUserInfo.email != nil {
                if self.oldUserInfo.email! != self.txtEmail.text! {
                    reqParams["email"] = self.txtEmail.text!
                }
            } else {
                reqParams["email"] = self.txtEmail.text!
            }
            
            ServiceRequestResponse.servicecallImageUpload(isAlert: false, VC: self, imageDataFile: imageData ?? nil, url: url, HttpMethod: .post, InputParameter: reqParams, isHeaderNeeded: true, ServiceCallBack: {
                (result, IsSuccess) in
                
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CommonResModel>().map(JSONString: result!)
                    if mapData?.code == "200" || Int(mapData!.code!) == 200
                    {
//                        self.makeFieldsEditable(bool: false)
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
    
    //MARK:- Custom helper methods
    //Helpers
    func setDatePicker(){
        self.datePicker.datePickerMode = .date
        self.txtBirthday.inputView = self.datePicker
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.datePicker.setDate(Calendar.current.date(byAdding: .year, value: 0, to: Date())!, animated: false)
        self.datePicker.addTarget(self, action: #selector(birthdayDatePicker(sender:)), for: .valueChanged)
    }
    
    func setExperiencePicker() {
        self.txtExperience.inputView = self.experiencePicker
        self.experiencePicker.dataSource = self
        self.experiencePicker.delegate = self
        self.experiencePicker.reloadAllComponents()
    }
    
    func isValidate() -> Bool
    {
        if !Validator.required().apply(self.txtName.text!) {
            AlertView.showMessageAlert(AlertMessage.emptyFullName, viewcontroller: self)
            return false
        }
//        if !Validator.required().apply(self.txtAccountName.text!) {
//            AlertView.showMessageAlert(AlertMessage.emptyAccountName, viewcontroller: self)
//            return false
//        }
//        if !Validator.required().apply(self.txtvwShortBio.text!) {
//            AlertView.showMessageAlert(AlertMessage.emptyShortBioName, viewcontroller: self)
//            return false
//        }
//        if !Validator.required().apply(self.txtBirthday.text!) {
//            AlertView.showMessageAlert(AlertMessage.emptyBirthdate, viewcontroller: self)
//            return false
//        }
        if (txtEmail.text?.isEmpty)! {
            AlertView.showMessageAlert(AlertMessage.emptyEmail, viewcontroller: self)
            return false
        }
        if !Validator.isEmail().apply(self.txtEmail.text!) {
            AlertView.showMessageAlert(AlertMessage.invalidEmail, viewcontroller: self)
            return false
        }
//        if !Validator.required().apply(self.txtMobile.text!) {
//            AlertView.showMessageAlert(AlertMessage.emptyPhoneNo, viewcontroller: self)
//            return false
//        }
//        if !Validator.required().apply(self.txtExperience.text!) {
//            AlertView.showMessageAlert(AlertMessage.emptyExperience, viewcontroller: self)
//            return false
//        }
//        if !Validator.required().apply(self.txtvwPositionsPlayed.text!) {
//            AlertView.showMessageAlert(AlertMessage.emptyPositionsPlayed, viewcontroller: self)
//            return false
//        }
        return true
    }
    
    func makeFieldsEditable(bool: Bool)
    {
       // if bool {
//            self.btnEdit.isHidden = true
            self.btnProPic.isUserInteractionEnabled = true
            self.txtName.isUserInteractionEnabled = true
            self.txtAccountName.isUserInteractionEnabled = true
            self.txtvwShortBio.isUserInteractionEnabled = true
            self.txtBirthday.isUserInteractionEnabled = true
            if !GlobalConstants.appDelegate.isSocialLogin {// FB Login
                self.txtEmail.isUserInteractionEnabled = true
            }
            self.txtMobile.isUserInteractionEnabled = true
            self.txtExperience.isUserInteractionEnabled = true
            self.txtvwPositionsPlayed.isUserInteractionEnabled = true
       // } //else {
//            self.btnEdit.isHidden = false
//            self.btnProPic.isUserInteractionEnabled = false
//            self.txtName.isUserInteractionEnabled = false
//            self.txtAccountName.isUserInteractionEnabled = false
//            self.txtvwShortBio.isUserInteractionEnabled = false
//            self.txtBirthday.isUserInteractionEnabled = false
//            self.txtEmail.isUserInteractionEnabled = false
//            self.txtMobile.isUserInteractionEnabled = false
//            self.txtExperience.isUserInteractionEnabled = false
//            self.txtvwPositionsPlayed.isUserInteractionEnabled = false
//        }
    }
    
    //MARK:- Image Selection
    func selectSourceForImage()
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
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
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
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true) {
                }
            }
            else
            {
                print("No camera available")
            }
        }
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings as URL)
            }
        }
        
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
        let chosenImage = info[.originalImage] as! UIImage
        self.ivUser.image = chosenImage
        self.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UIPickerView methods
//MARK:-
extension EditCoachProfileVC: UIPickerViewDataSource, UIPickerViewDelegate
{
    //Datasource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.experiencePickerData.count
    }
    
    //Delegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.experiencePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtExperience.text = self.experiencePickerData[row]
    }
}
