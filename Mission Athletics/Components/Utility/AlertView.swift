//
//  AlertView.swift
//  

import UIKit

typealias buttonClicked = (NSInteger) -> Void

class AlertAction : UIAlertAction{
    var  tag : NSInteger?
}

var CommanColor:UIColor = .blue

class AlertView: NSObject {
    
    static let sharedInstance = AlertView()
    fileprivate override init() {} //This prevents others from using the default '()' initializer for
    
    var alertController : UIAlertController?
    
    class func showOKTitleAlert(_ strTitle : String, viewcontroller : UIViewController)
    {
        AlertView.showAlert(strTitle.localizedString(), strMessage: "", button: NSMutableArray(object: "OK".localizedString()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showOKMessageAlert(_ strMessage : String, viewcontroller : UIViewController)
    {
        AlertView.showAlert("Help", strMessage: strMessage, button:  NSMutableArray(object: "OK".localizedString()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func   showMessageAlert(_ strMessage : String, viewcontroller : UIViewController)
    {
        AlertView.showAlert("", strMessage: strMessage, button:  NSMutableArray(object: "OK".localizedString()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showOKTitleMessageAlert(_ strTitle : String,strMessage : String, viewcontroller : UIViewController)
    {
        AlertView.showAlert(strTitle.localizedString(), strMessage: strMessage, button:  NSMutableArray(object: "OK".localizedString()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showAlert(_ strTitle : String,strMessage : String,button:NSMutableArray, viewcontroller : UIViewController, blockButtonClicked : buttonClicked?)
    {
        print(strTitle);
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert);
        alert.view.tintColor = UIColor.black//.init(hexString: "9b2e23")
        for i in 0  ..< button.count {
            
            let str = button.object(at: i) as? String;
            let action = AlertAction(title: str, style: UIAlertAction.Style.default) { (a) -> Void in
                
                blockButtonClicked?((a as! AlertAction).tag!)
            }
            
            action.tag = i
            alert.addAction(action);
        }
        
        viewcontroller.present(alert, animated: true) { () -> Void in
        }
    }
   
    class func showActionSheetWithCancelButton(_ isCancelButton : Bool, title : String?,buttons:[String],viewcontroller : UIViewController, blockButtonClicked : buttonClicked?)
    {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = UIColor.black//.init(hexString: "9b2e23")
        for i in 0  ..< buttons.count {
            let str = buttons[i];
            let action = AlertAction(title: str, style: UIAlertAction.Style.default) { (action) -> Void in
                
                blockButtonClicked?((action as! AlertAction).tag!)
            }
            
            action.tag = i
            alert.addAction(action);
        }
        
        if isCancelButton {
            
            let cancelAction = AlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                //blockButtonClicked?((action as! AlertAction).tag!)
            })
            cancelAction.tag = buttons.count
            alert.addAction(cancelAction)
        }
        
        viewcontroller.present(alert, animated: true) { () -> Void in
        }
    }
    
    class func showAlertGoBack(strMessage: String, viewController: UIViewController)
    {
        let alert = UIAlertController(title: "", message: strMessage, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            viewController.navigationController?.popViewController(animated: true)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}

