//
//  Utility.swift
//  OSACustomer
//
//  Created by Mac on 27/06/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SystemConfiguration
import SVProgressHUD

//MARK:- Check internet connectivity
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

func ShowProgress(){
    SVProgressHUD.show()
}

func HideProgress(){
    SVProgressHUD.dismiss()
}

//MARK:- Save, Fetch, Get Model
//==========================================

func saveModel(_ model : AnyObject, forKey key : String) {
    let encodedObject = NSKeyedArchiver.archivedData(withRootObject: model)
    UserDefaults.standard.set(encodedObject, forKey: key)
    UserDefaults.standard.synchronize()
}

func getModelForKey(_ key : String) -> AnyObject? {
    let encodedObject = UserDefaults.standard.object(forKey: key) as? Data
    let savedModel = encodedObject != nil ? NSKeyedUnarchiver.unarchiveObject(with: encodedObject!) : nil
    return savedModel as AnyObject?
}

func removeModelForKey(_ key : String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func saveUserInfo(_ userInfo : UserDataModel) {
    print(userInfo)
    saveModel(userInfo, forKey: UserDefaultsKey.user)
}

func removeUserInfo(key: String)
{
    removeModelForKey(key)
    UserDefaults.standard.removeObject(forKey: "socialLoginUserInfo")
    UserDefaults.standard.synchronize()
}

func getUserInfo() -> UserDataModel? {
    return getModelForKey(UserDefaultsKey.user) as? UserDataModel
}
//==========================================
func RemoveRedDotAtTabBarItemIndex(index: Int, tabBarController: UITabBarController) {
    for subview in tabBarController.tabBar.subviews {

        if let subview = subview as? UIView {

            if subview.tag == 1234 {
                subview.removeFromSuperview()
                break
            }
        }
    }
}
func addRedDotAtTabBarItemIndex(index: Int, tabBarController: UITabBarController) {
    for subview in tabBarController.tabBar.subviews {

        if let subview = subview as? UIView {

            if subview.tag == 1234 {
                subview.removeFromSuperview()
                break
            }
        }
    }

    let RedDotRadius: CGFloat = 3
    let RedDotDiameter = RedDotRadius * 2

    let TopMargin:CGFloat = 7

    let TabBarItemCount = (tabBarController.tabBar.items?.count)

    let screenSize = UIScreen.main.bounds
    let HalfItemWidth = (screenSize.width) / CGFloat(TabBarItemCount! * 2)

    let  xOffset = HalfItemWidth * CGFloat(index * 2 + 1)

    let imageHalfWidth: CGFloat = (tabBarController.tabBar.items![index] ).selectedImage!.size.width / 2

    let redDot = UIView(frame: CGRect(x: xOffset + imageHalfWidth - 4, y: TopMargin, width: RedDotDiameter, height: RedDotDiameter))

    redDot.tag = 1234
    redDot.backgroundColor = UIColor.red
    redDot.layer.cornerRadius = RedDotRadius

    tabBarController.tabBar.addSubview(redDot)

}
//MARK:- TabBar
func changeTabItemImage(tabBar: UITabBarController, index: Int, newNotifications: Bool)
{
    
    if newNotifications {
        addRedDotAtTabBarItemIndex(index: 1, tabBarController: tabBar)
//        tabBar.tabBar.items?[index].badgeValue = " "//UIImage(named: "bell_selected")
//        tabBar.tabBar.items?[index].badgeValue = " "//UIImage(named: "bell_selected_blue")
    } else {
        RemoveRedDotAtTabBarItemIndex(index: 1, tabBarController: tabBar)
//        tabBar.tabBar.items?[index].badgeValue = nil//UIImage(named: "bell")
//        tabBar.tabBar.items?[index].selectedImage = UIImage(named: "bell_blue")
    }
}

//MARK:- Thumbnail generator from video url
func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}

//MARK:- UIButton
class MyButton: UIButton
{
    var row: Int = 0
    var section: Int = 0
}

//MARK:- UILabel
public class UIPaddedLabel: UILabel
{
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    public override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}

//MARK:- UITextfield
func addTextFieldpadding(txtFields: [UITextField], paddingLeft : CGFloat, paddingRight : CGFloat) {
    for textfield in txtFields
    {
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 0, width: paddingLeft, height: textfield.frame.size.height))
        textfield.leftView = paddingLeft
        textfield.leftViewMode = .always
        
        let paddingRight = UIView(frame: CGRect(x: 0, y: 0, width: paddingRight, height: textfield.frame.size.height))
        textfield.rightView = paddingRight
        textfield.rightViewMode = .always
    }
}

//MARK:- UITextview
func TextViewPadding(textView: UITextView){
    textView.contentInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
}

//MARK:- UIView
func roundSpecifiedCorners(_ corners:UIRectCorner, radius: CGFloat, views: [UIView]) {
    for view in views
    {
        if #available(iOS 11.0, *) {
//            view.clipsToBounds = true
            view.layer.cornerRadius = radius
            view.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
}

//MARK:- RandomNumber generator
class RandomNumber: NSObject {
    class func randomNumberWithLength (_ len : Int) -> NSString {
        let letters : NSString = "123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString
    }
}


//MARK:- UISwitch
func setSwitchSize(switches: [UISwitch], transformScale: CGFloat)
{
    for swtch in switches
    {
        swtch.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
    }
}

func setSwitchUserInteraction(switches: [UISwitch], onOff: Bool)
{
    for swtch in switches
    {
        swtch.isUserInteractionEnabled = onOff
    }
}

func setSwitchOnOff(switches: [UISwitch], onOff: Bool)
{
    for swtch in switches
    {
        swtch.setOn(onOff, animated: true)
        if onOff == false {
            swtch.isEnabled = false
        } else {
            swtch.isEnabled = true
        }
    }
}

func setSwitchOnOffWithoutEnable(switches: [UISwitch], onOff: Bool)
{
    for swtch in switches
    {
        swtch.setOn(onOff, animated: true)
    }
}

func SetText(bText: String, nText:String, boldSize: CGFloat, normalSize: CGFloat) -> NSAttributedString
{
    let formattedString = NSMutableAttributedString()
    formattedString.bold(bText, size: boldSize)
    formattedString.normal(" " + nText, size: normalSize)
    return formattedString
}

//MARK:- Gradient methods
func addGradientBorder(view: UIView, gradientColors: [CGColor])
{
    let gradient = CAGradientLayer()
    gradient.frame =  CGRect(origin: CGPoint.zero, size: view.bounds.size)
    gradient.colors = gradientColors
    
    let shape = CAShapeLayer()
    shape.lineWidth = 2
    shape.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath//UIBezierPath(rect: view.bounds).cgPath
    shape.strokeColor = UIColor.black.cgColor
    shape.fillColor = UIColor.clear.cgColor
    gradient.mask = shape
    
    view.layer.addSublayer(gradient)
}

func addGradientBackground(view: UIView, gradientColors: [CGColor], direction: gradientDirection) {
    
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.colors = gradientColors
    
    if direction == .bottomTop {
        gradient.locations = [0.2, 1.0]
    } else {
        gradient.locations = [0.0 , 1.0]
    }
    
    switch direction
    {
    case .topBottom:    //left to right
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
    case .bottomTop:
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
    case .leftRight:
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    case .rightLeft:
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
    case .TopLeftToBottomRight:
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    case .TopRightToBottomLeft:
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
    case .BottomLeftToTopRight:
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
    case .BottomRightToTopLeft:
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
    }
//    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    gradient.frame = view.layer.bounds
    view.layer.insertSublayer(gradient, at: 0)
    
}

enum gradientDirection {//darkTolight
    case topBottom
    case bottomTop
    case leftRight
    case rightLeft
    case TopLeftToBottomRight
    case TopRightToBottomLeft
    case BottomLeftToTopRight
    case BottomRightToTopLeft
}

extension CALayer {
    
    func removeAllGradiantLayers(){
        self.sublayers?.forEach
            { layer in
                if layer.isKind(of: CAGradientLayer.self)
                {
                    layer.removeFromSuperlayer()
                }
        }
    }
}

// MARK: - Toast Methods
func showToastMsg(message : String) {
    let toastLabel = UILabel(frame: CGRect(x: UIApplication.shared.keyWindow!.frame.size.width/2 - 150, y: (UIApplication.shared.keyWindow?.frame.size.height)!-120, width:300,  height : 50))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center;
    //appDelegate.window!.addSubview(toastLabel)
    UIApplication.shared.keyWindow?.addSubview(toastLabel)
    toastLabel.text = message
    toastLabel.numberOfLines = 0
    toastLabel.alpha = 1.0
    toastLabel.font = UIFont(name: "Montserrat-Light", size: 5.0)
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    UIView.animate(withDuration: 6, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    })
}

//MARK:- UIColor
func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//MARK:- Date functions
func getDayNameBy(stringDate: String) -> String
{
    let df = DateFormatter()
    df.dateFormat = "YYYY-MM-dd"
    let date = df.date(from: stringDate)!
    df.dateFormat = "EEEE"
    return df.string(from: date);
}
func getDayWithDate(stringDate: String) -> String
{
    let df = DateFormatter()
    df.dateFormat = "YYYY-MM-dd HH:mm:ss"
    let date = df.date(from: stringDate)!
    df.dateFormat = "MMMM, dd yyyy"
    return df.string(from: date);
}

func getDayTimeWithDate(stringDate: String) -> String
{
    let df = DateFormatter()
    df.dateFormat = "YYYY-MM-dd HH:mm:ss"
    df.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = df.date(from: stringDate)!
    df.timeZone = TimeZone.current
    df.dateFormat = "EEEE hh:mm"
//    df.timeZone = NSTimeZone.local
    return df.string(from: date);
}

func checkForAMPM(time: String) -> String
{
    let df = DateFormatter()
    df.dateFormat = "YYYY-MM-dd HH:mm:ss"
    df.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = df.date(from: time)!
    df.dateFormat = "h:mm a"
    df.timeZone = NSTimeZone.local
    return df.string(from: date);
  
}
func checkTForAMPM(time: String) -> String
{
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    df.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = df.date(from: time)!
    df.dateFormat = "h:mm a"
    df.timeZone = NSTimeZone.local
    return df.string(from: date);
  
}
func check24hoursForAMPM(time: String) -> String{
    var returnStr = ""
    let timeStr = time.dropLast(3)
    if Int(timeStr.prefix(2))! > 12 {
        returnStr = "\(Int(timeStr.prefix(2))! - 12)\(timeStr.dropFirst(2)) PM"
    } else {
        if Int(timeStr.prefix(2))! == 12 {
            returnStr = "\(timeStr) PM"
        } else {
            returnStr = "\(timeStr) AM"
        }
    }
    return returnStr
}

// MARK: - Data Conversion funcs from array/dict to json or vice versa
func ModelToDic(Model:AnyObject) -> NSDictionary{
    
    let theDict = NSMutableDictionary()
    let mirrored_object = Mirror(reflecting: Model)
    for (_, attr) in mirrored_object.children.enumerated() {
        if let name = attr.label {
            theDict.setValue( Model.value(forKey:name) , forKey: name)
        }
    }
    
    return theDict
}

func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options:.prettyPrinted) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}


func DictToJson(Dict:[String:Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: Dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        if let jsonString =  NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as String? {
            return jsonString
        }
    }catch let error as NSError {
        print(error)
    }
    return nil
}

func JsonToDict(Json:String) -> [String:Any]? {
    if let data = Json.data(using: String.Encoding.utf8) {
        do{
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
        }catch let error as NSError {
            print(error)
        }
    }
    return nil
}

func JsonToArrOfDict(Json:String) -> [[String:Any]]? {
    if let data = Json.data(using: String.Encoding.utf8) {
        do{
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String:AnyObject]]
        }catch let error as NSError {
            print(error)
        }
    }
    return nil
}

func setupSideMenu()
{
    
}

extension UserDefaults{

    //MARK: Save User Data
    func setIntID(value: Int, key:String){
        set(value, forKey: key)
        //synchronize()
    }

    //MARK: Retrieve User Data
    func getIntID(key:String) -> Int{
        return integer(forKey: key)
    }
}

//MARK:- Socket helpers
func jsonToString(json: AnyObject) -> String{
    do {
        let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
      //  print(convertedString) // <-- here is ur string
        return convertedString ?? ""
    } catch let myJSONError {
        print(myJSONError)
        return ""
    }
}

func arrjsonToString(json: AnyObject) -> String{
    do {
        let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
        return convertedString ?? ""
    } catch let myJSONError {
        print(myJSONError)
        return ""
    }
}
func getCurrentTimeZone() -> String {
    return TimeZone.current.identifier
}

func getUploadTIme(timeStr: String) -> String
{
    var uploadedAt = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    dateFormatter.locale = Locale.current
    let formatedStartDate = dateFormatter.date(from: timeStr)
    

    let currentDate = Date()
    let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
    let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate ?? Date(), to: currentDate)
    
//    print (timeStr)
//    print (differenceOfDate)
//    print (formatedStartDate as Any)

    if differenceOfDate.day != nil {
        if differenceOfDate.day! <= 8 {
            uploadedAt = "\(String(describing: differenceOfDate.day!))d ago"
            if differenceOfDate.day! < 1 {
                uploadedAt = "\(String(describing: differenceOfDate.hour!))h ago"
                if differenceOfDate.hour! < 1 {
                    uploadedAt = "\(String(describing: differenceOfDate.minute!))m ago"
                }
            }
        }else if differenceOfDate.day! >= 8 {
            uploadedAt = "\(String(describing: differenceOfDate.day!))d ago"
        }else {
            uploadedAt = timeStr
        }
    }
    //print (uploadedAt)
    return uploadedAt
}

//MARK:- Helpers
func addGradiantLayer(gradientView: UIView){
    let gradientLayer:CAGradientLayer = CAGradientLayer()
    gradientLayer.frame.size = gradientView.frame.size
    let color1 = UIColor.white.withAlphaComponent(0.0).cgColor
    let color2 = UIColor.white.withAlphaComponent(0.2).cgColor
    let color3 = UIColor.white.withAlphaComponent(0.4).cgColor
    let color4 = UIColor.white.withAlphaComponent(0.8).cgColor
    let color5 = UIColor.white.cgColor
    gradientLayer.colors = [color1, color2, color3, color4, color5, color5]
    
    //Use diffrent colors
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // vertical gradient start
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradientView.layer.insertSublayer(gradientLayer, at: 0)
}

func randomString(length: Int = 8) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""
    
    for _ in 0..<length {
        let randomValue = arc4random_uniform(UInt32(base.count))
        randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
}
