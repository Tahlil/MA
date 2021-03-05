//
//  SupportVC.swift
//  Mission Athletics
//
//  Created by Mac on 04/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import ObjectMapper

class SupportVC: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnSelectCategory: UIButton!
    @IBOutlet weak var txtvwMessage: UITextView!

    var dropDownCategory = DropDown()
    var arrInquiry = [InquiryListArrModel]()
    var selectedInquiryId = -1
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtvwMessage.text = "Add your message here"
        self.txtvwMessage.textColor = UIColor.lightGray
        self.txtvwMessage.textContainerInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        self.setupDropDowns()
        self.getInquiryListAPICall()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.layoutIfNeeded()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setupDropDowns()
    {
        let dataSourceCategory = ["Category 1", "Category 2", "Category 3"]
        self.dropDownCategory.anchorView = self.btnSelectCategory
        self.dropDownCategory.bottomOffset = CGPoint(x: 0, y:(self.dropDownCategory.anchorView?.plainView.bounds.height)!)
        self.dropDownCategory.dataSource = dataSourceCategory
//        self.dropDownCategory.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
//            // Setup your custom UI components
//            cell.optionLabel.intrinsicContentSize = intrinsicContentSize().size
//        }
        self.dropDownCategory.backgroundColor = UIColor.white
        self.dropDownCategory.shadowColor = UIColor.appBlueColor
        self.dropDownCategory.shadowRadius = 1.5
        self.dropDownCategory.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.dropDownCategory.shadowOpacity = 0.5
        self.dropDownCategory.textFont = UIFont(name: "BrandonGrotesque-Medium", size: 15.0)!
        
        self.dropDownCategory.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lblCategory.text = item
            
            for inq in self.arrInquiry
            {
                if item == inq.title! {
                    self.selectedInquiryId = inq.id!
                    break
                }
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func btnSelectCategoryAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.dropDownCategory.show()
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.validate() {
            self.submitQueryApiCall()
        }
    }
    
    func validate() -> Bool
    {
        if self.selectedInquiryId == -1
        {
            AlertView.showMessageAlert("Please select inquiry category", viewcontroller: self)
            return false
        }
        if self.txtvwMessage.text! == "Add your message here"
        {
            AlertView.showMessageAlert("Please describe your query", viewcontroller: self)
            return false
        }
        return true
    }
    
    //MARK:- UITexview delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add your message here"
            textView.textColor = UIColor.lightGray
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
    
    //MARK:- API Call
    func getInquiryListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getInquiryList)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .get, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<GetInquiryListResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            self.arrInquiry = data
                            var datasource = [String]()
                            for inq in self.arrInquiry
                            {
                                datasource.append(inq.title!)
                            }
                            self.dropDownCategory.dataSource = datasource
                            self.dropDownCategory.reloadAllComponents()
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
    
    func submitQueryApiCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            let url = WebService.createURLForWebService(WebService.support)
            print(url)
            
            var reqParams:[String:Any] = [:]
            reqParams["inquiry_id"] = self.selectedInquiryId
            reqParams["message"] = self.txtvwMessage.text!
            
            ServiceRequestResponse.servicecallWithHeader(VC: self, url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<CommonResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        self.txtvwMessage.text = "Add your message here"
                        self.txtvwMessage.textColor = UIColor.lightGray
                        
                        AlertView.showAlert("", strMessage: mapData?.message ?? "Something went wrong", button: ["OK"], viewcontroller: self, blockButtonClicked: { (button) in
                            self.btnGoBackAction(UIButton())
                        })
                    } else {
                        AlertView.showMessageAlert(mapData?.message ?? "Invalid Email ID or Password", viewcontroller: self)
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
