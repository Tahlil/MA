//
//  ComposeNewMsgVC.swift
//  Mission Athletics
//
//  Created by MAC  on 19/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ComposeNewMsgVC: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var txtvwMessage: GrowingTextView!
    @IBOutlet weak var txtMessage: UITextField!
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtvwMessage.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnEmojiAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnAddAttachmentAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnSendMsgAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.isValidate() {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name("navigateToChatRoom"), object: self.txtvwMessage.text!)
            }
        }
    }
    
    func isValidate() -> Bool
    {
        if self.txtvwMessage.text!.isEmpty {
            AlertView.showMessageAlert("Message cannot be blank", viewcontroller: self)
            return false
        }
        return true
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Prevent first char as space
        let newString = (textView.text! as NSString).replacingCharacters(in: range, with: text) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && text == " "
        {
            return false
        }//Prevent first char as space
        
        if let char = text.cString(using: String.Encoding.utf8)
        {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92)
            {
                print("Backspace was pressed")
            }
            else
            {
            }
        }
        
        return true
    }
}
