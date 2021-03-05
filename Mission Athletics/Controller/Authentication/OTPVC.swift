//
//  OTPVC.swift
//  Mission Athletics
//
//  Created by MAC  on 20/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class OTPVC: UIViewController
{
    @IBOutlet weak var txtOtp1: UITextField!
    @IBOutlet weak var txtOtp2: UITextField!
    @IBOutlet weak var txtOtp3: UITextField!
    @IBOutlet weak var txtOtp4: UITextField!
    @IBOutlet weak var btnSubmitOtp: UIButton!
    @IBOutlet weak var lblResendOTPInfo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        txtOtp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        // Do any additional setup after loading the view.
    }

    @objc func textFieldDidChange(textField: UITextField)
    {
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txtOtp1:
                txtOtp2.becomeFirstResponder()
            case txtOtp2:
                txtOtp3.becomeFirstResponder()
            case txtOtp3:
                txtOtp4.becomeFirstResponder()
            case txtOtp4:
                txtOtp4.resignFirstResponder()
            default:
                break
            }
        }
        if text?.count == 0 {
            switch textField{
            case txtOtp1:
                txtOtp1.becomeFirstResponder()
            case txtOtp2:
                txtOtp1.becomeFirstResponder()
            case txtOtp3:
                txtOtp2.becomeFirstResponder()
            case txtOtp4:
                txtOtp3.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.text!.count == 1
        {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    return true
                }
            }
            return false
        }
        return true
    }
}
