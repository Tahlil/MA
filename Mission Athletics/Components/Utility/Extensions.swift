//
//  Utlility.swift
//  OSA
//
//  Created by Harsh on 1/15/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit
import MobileCoreServices
import UIKit
import AVKit

//MARK:- UI Components
extension UIView
{
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var leftBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = UIColor(cgColor: layer.borderColor!)
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    @IBInspectable var topBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    
    @IBInspectable var rightBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    @IBInspectable var bottomBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    func removeborder() {
        for view in self.subviews {
            if view.tag == 110  {
                view.removeFromSuperview()
            }
            
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = false
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addDashBorder(color: CGColor)
    {
//        let color = UIColor.white.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let boundSize = self.bounds.size
        let shapeRect = CGRect(x: 0, y: 0, width: boundSize.width, height: boundSize.height)
        
        shapeLayer.frame = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [5,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.masksToBounds = false
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func removeDashBorder()
    {
        let _ = self.layer.sublayers?.filter({$0.name == "DashBorder"}).map({$0.removeFromSuperlayer()})
    }
    
    // Code to set shadow at bottom of view
    var setNavigationShadow: Void {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.5
    }
}

private var AssociatedObjectHandle: UInt8 = 0
extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    var isEmpty : Bool {
        get {
            if self.text == nil {
                return true
            }
            return self.text!.isEmpty
        }
    }
    
    var isPasteEnable:Bool{
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return isPasteEnable
        }
        
        if action == #selector(copy(_:)) || action == #selector(cut(_:)) || action == #selector(paste(_:)) || action == #selector(select(_:)) || action == #selector(selectAll(_:)) {
            return true
        } else {
            return false
        }
    }
}

extension UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space
        
        return true
    }
}

extension UITableView {
    
    var tableViewHeight: CGFloat
    {
        self.layoutIfNeeded()
        return self.contentSize.height
    }
    
    var tableViewWidth: CGFloat
    {
        get {
            self.layoutIfNeeded()
            return self.contentSize.width
        }
        set {
            self.layoutIfNeeded()
            self.contentSize.width = newValue
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "BrandonGrotesque-Medium", size: 16)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restoreEmptyMessage() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
    func scrollToBottom() {
        let rows = self.numberOfRows(inSection: 0)
        
        if rows > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: rows - 1, section: 0)
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
}

extension UICollectionView
{
    var collectionViewHeight: CGFloat
    {
        self.layoutIfNeeded()
        return self.contentSize.height
    }
    
    var collectionViewWidth: CGFloat
    {
        get {
            self.layoutIfNeeded()
            return self.contentSize.width
        }
        set {
            self.layoutIfNeeded()
            self.contentSize.width = newValue
        }
    }
    func setEmptyMessage(_ message: String) {
           let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
           messageLabel.text = message
           messageLabel.textColor = .black
           messageLabel.numberOfLines = 0;
           messageLabel.lineBreakMode = .byWordWrapping
           messageLabel.textAlignment = .center;
           messageLabel.font = UIFont(name: "BrandonGrotesque-Medium", size: 16)
           messageLabel.sizeToFit()
           
           self.backgroundView = messageLabel;
       }
       
       func restoreEmptyMessage() {
           self.backgroundView = nil
       }
}

//MARK:- iOS Class
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    
    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
//    open override var childForStatusBarStyle: UIViewController? {
//        return self.topViewController
//    }
//
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if let rootViewController = self.viewControllers.first {
            return rootViewController.preferredStatusBarStyle
        }
        return super.preferredStatusBarStyle
        
        //Without tabbar controller you just need this code//
//        if let lastVC = self.viewControllers.last
//        {
//            return lastVC.preferredStatusBarStyle
//        }

//        return .default
        //Without tabbar controller you just need this code//
        
//
//        else if let topVC = self.topViewController {
//            return topVC.preferredStatusBarStyle
//        }
//        for vc in self.viewControllers
//        {
//            if vc.isKind(of: UINavigationController.self) {
//                if vc == topViewController
//                {
//                    return vc.preferredStatusBarStyle
//                }
//            }
//        }

    }
    
    func initRootViewController(vc: UIViewController, transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.viewControllers.removeAll()
        self.pushViewController(vc, animated: false)
        self.popToRootViewController(animated: false)
    }
    
    /**
     It adds the animation of navigation flow.
     
     - parameter type: kCATransitionType, it means style of animation
     - parameter duration: CFTimeInterval, duration of animation
     */
    private func addTransition(transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType(rawValue: type)
        self.view.layer.add(transition, forKey: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false//viewControllers.count > 1
    }
}

extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
//    open override var childForStatusBarStyle: UIViewController? {
//        return self.children.last
//    }
//
//    open override var childForStatusBarHidden: UIViewController? {
//        return self.children.last
//    }
}

extension UIViewController {
    
    @IBAction func btnGoBackAction(_ sender: UIButton)
    {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension NSRange {
    
    /// Convert to Range for given string
    ///
    /// - Parameter string: the string
    /// - Returns: range
    func toRange(string: String) -> Range<String.Index> {
        let range = string.index(string.startIndex, offsetBy: self.lowerBound)..<string.index(string.startIndex, offsetBy: self.upperBound)
        return range
    }
}

extension NSMutableAttributedString
{
    func bold(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Montserrat-Bold", size: size)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    func normal(_ text: String, size: CGFloat) -> NSMutableAttributedString
    {
        let attrs = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: size)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
}

extension NSDate {
    
}

extension Data
{
    var toString : String? {
        get {
            let str = String(data: self, encoding: .utf8)
            return str
        }
    }
    
    func storeToRandomFile(_ fileExtension : String)
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let fileName = "Random_\(arc4random() % 10000).\(fileExtension)"
        let filePath = "\(documentsPath)/\(fileName)"
        
        FileManager.default.createFile(atPath: filePath, contents: self, attributes: nil)
        
        print("filePath  \(filePath)")
    }
    
    func parseObject() -> Any?
    {
        do {
            let parse = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
            return parse
        }
        catch {
            print("Error in parsing in Data Extension \(error)")
        }
        return nil
    }
}

extension String
{
    var length: Int {
        return self.count
    }
    
    func nsstring () -> NSString {
        return (self as NSString)
    }
    
    public var isValid: Bool {
        if isBlank == false && self.length > 0 {
            return true
        }
        return false
    }
    
    /// EZSE: Checks if string is empty or consists only of whitespace and newline characters
    public var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    func validateEmailString(_ emailString:String)->Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: emailString)
    }
    
    func validateSpecialCharacter(_ input:String)->Bool
    {
        let regEx = "[A-Za-z0-9]*"
        let testResult = NSPredicate(format:"SELF MATCHES %@", regEx)
        return testResult.evaluate(with: input)
    }
    func isValidEmailAddress () -> Bool
    {
        
        var returnValue = true
        
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"//"[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"*/
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            
            let results = regex.matches(in: self.trimmingCharacters(in: .whitespacesAndNewlines), range: NSRange(location: 0, length: self.count))
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch let error as NSError
        {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    func isPasswordValid() -> Bool{
        // let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        // return passwordTest.evaluate(with: self)
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    //==========================================
    //MARK: - To get Float value from String
    //==========================================
    
    var floatValue: Float {
        let balance = self.replacingOccurrences(of: ",", with: "")
        return Float(balance)!
    }
    
    
    
    //==========================================
    //MARK: - To get Double value from String
    //==========================================
    
    func toDouble() -> Double? {
        
        // return NSNumberFormatter().numberFromString(self)?.doubleValue
        let balance = self.replacingOccurrences(of: ",", with: "")
        return Double(balance)
    }
    
    
    //==========================================
    //MARK: - To get Int value from String
    //==========================================
    
    func toInt() -> Int? {
        // return NSNumberFormatter().numberFromString(self)?.doubleValue
        let balance = self.replacingOccurrences(of: ",", with: "")
        return Int(balance)
    }
    
    
    //==========================================
    //MARK: - To get Bool value from String
    //==========================================
    
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    
    //==========================================
    //MARK: - To get Number value from String
    //==========================================
    
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
    
    //==========================================
    //MARK: - To get Localized String from String
    //==========================================
    
    func localizedString()->String{
        
        return  NSLocalizedString(self, tableName: "Messages", bundle: Bundle.main, value: "", comment: "") as String;
    }
    
    
    //==================================================
    //MARK: - To get Replaced String with another String
    //==================================================
    
    func replacementOfString(_ stringToReplace:String,stringByReplace:String) -> String{
        let newString = self.replacingOccurrences(of: stringToReplace, with: stringByReplace, options: NSString.CompareOptions.literal, range: nil)
        return newString
    }
    
    //==========================================
    //MARK: - To get UInt value from String
    //==========================================
    
    func toUInt() -> UInt? {
        if self.contains("-") {
            return nil
        }
        return self.withCString { cptr -> UInt? in
            var endPtr : UnsafeMutablePointer<Int8>? = nil
            errno = 0
            let result = strtoul(cptr, &endPtr, 10)
            if errno != 0 || endPtr?.pointee != 0 {
                return nil
            } else {
                return result
            }
        }
    }
    
    //==========================================
    //MARK: - To Get NSString from String
    //==========================================
    
    var ns: NSString {
        return self as NSString
    }
    
    
    //==========================================
    //MARK: - To Get Path Extension of String
    //==========================================
    
    var pathExtension: String? {
        return ns.pathExtension
    }
    
    //==========================================
    //MARK: - To Get mime type of file or filePath
    //==========================================
    
    var mimeTypeForPath : String? {
        
        let pathExtension = self.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return nil
    }
    
    //==============================================
    //MARK: - To Get last Path component from String
    //==============================================
    
    var lastPathComponent: String? {
        return ns.lastPathComponent
    }
    
    //==========================================
    //MARK: - To Get trim string
    //==========================================
    
    var trimSpace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    //==============================================
    //MARK: - To Get last 2 Digit from Number
    //==============================================
    
    func last2Digit()->String{
        let trimmedString: String = (self as NSString).substring(from: max(self.length-2,0))
        return trimmedString
    }
    
    
    //==============================================
    //MARK: - Subscript to Get Character at Index
    //==============================================
    
    subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        // let index = characters.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    
    //==========================================================
    //MARK: - Subscript to Get Range of String From given String
    //==========================================================
    
    subscript(integerRange: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: integerRange.lowerBound)//characters.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = self.index(startIndex, offsetBy: integerRange.upperBound)//characters.index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return String(self[range])
    }
    
    
    func isStringOnlyAlphabet() -> Bool{
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            return false
        }
        return true
    }
    
    
    func isStringOnlyAlphabetAndComma() -> Bool{
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z ,].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            return false
        }
        return true
    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end > 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start > 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
    
    ////==========================================
    //MARK: - Encoding and Decoding
    //============================================
    
    func decodeString(str : String) -> String{
        let wI = NSMutableString( string: str )
        CFStringTransform( wI, nil, "Any-Hex/Java" as NSString, true )
        return wI as String
        
    }
    
    func encodeString(str :  String) -> String{
        let eS = NSMutableString( string: str )
        CFStringTransform( eS, nil, "Any-Hex/Java" as NSString, false)
        return eS as String
    }
    
    
    
    
    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
    
    func HtmlStringLoad() -> NSAttributedString
    {
        let data = self.data(using: String.Encoding.unicode)! // mind "!"
        let attrStr = try? NSAttributedString( // do catch
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        return attrStr!
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
    func HTMLImageCorrector() -> String {
        var HTMLToBeReturned = self
        while HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) != nil{
            if let match = HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) {
                HTMLToBeReturned.removeSubrange(match)
                if let match2 = HTMLToBeReturned.range(of: "(?<=height=\")[^\"]+", options: .regularExpression) {
                    HTMLToBeReturned.removeSubrange(match2)
                    let string2del = "width=\"\" height=\"\""
                    HTMLToBeReturned = HTMLToBeReturned.replacingOccurrences(of: string2del, with: "style=\"width: 100%\"")
                }
            }
        }
        return HTMLToBeReturned
    }
}

extension UIImage {
//    var averageColor: UIColor? {
//        guard let inputImage = CIImage(image: self) else { return nil }
//        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
//
//        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
//        guard let outputImage = filter.outputImage else { return nil }
//
//        var bitmap = [UInt8](repeating: 0, count: 4)
//        let context = CIContext(options: [.workingColorSpace: kCFNull])
//        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
//
//        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
//    }
    
    func areaAverage() -> UIColor {
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        let context = CIContext(options: nil)
        let cgImg = context.createCGImage(CoreImage.CIImage(cgImage: self.cgImage!), from: CoreImage.CIImage(cgImage: self.cgImage!).extent)
        
        let inputImage = CIImage(cgImage: cgImg!)
        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
        let outputImage = filter.outputImage!
        let outputExtent = outputImage.extent
        assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
        
        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
    
    
}

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

extension UIColor
{
    static var appBlueColor: UIColor  { return UIColor(red: 0/255, green: 148/255, blue: 188/255, alpha: 1) }
    static var blueGradientDark: UIColor  { return UIColor(red: 0/255, green: 159/255, blue: 205/255, alpha: 1) }//{ return UIColor.red }//
    static var blueGradientLight: UIColor  { return UIColor(red: 0/255, green: 194/255, blue: 225/255, alpha: 1) }//{ return UIColor.green }//
    static var appOrangeColor: UIColor  { return UIColor(red: 248/255, green: 17/255, blue: 1/255, alpha: 1) }
    static var greenSubscribe: UIColor  { return UIColor(red: 0/255, green: 175/255, blue: 51/255, alpha: 1) }
    static var redCancelButton: UIColor  { return UIColor(red: 249/255, green: 0/255, blue: 21/255, alpha: 1) }
    
    //Chat
    static var chatBlack100: UIColor  { return UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1) }
    static var chatBlack151: UIColor  { return UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1) }
    static var chatBlack112: UIColor  { return UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1) }
    static var cursorTintColor: UIColor  { return UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1) }
    
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

public enum Model : String {
    
    //Simulator
    case simulator     = "simulator/sandbox",
    
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPadAir3           = "iPad Air 3",
    iPad5              = "iPad 5", //iPad 2017
    iPad6              = "iPad 6", //iPad 2018
    
    //iPad Mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    iPadMini5          = "iPad Mini 5",
    
    //iPad Pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro11          = "iPad Pro 11\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro3_12_9      = "iPad Pro 3 12.9\"",
    
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6Plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6SPlus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7Plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8Plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        let modelMap : [String: Model] = [
            
            //Simulator
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //iPad 2018
            "iPad7,6"   : .iPad6,
            
            //iPad Mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,
            
            //iPad Pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,
            
            //iPad Air
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,
            
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            
            //Apple TV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}

extension UIViewController{
    func playVideoAvPlayerViewController(videoUrl: URL)
    {
        let player = AVPlayer(url: videoUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
extension Double {
    var dollarString:String {
        return String(format: "$%.2f", self)
    }
}
extension UIImageView
{
    func setBlurImgeView(){
        self.removeBlurEffect()
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurredView.frame = self.bounds
        blurredView.alpha = 0.4
        blurredView.backgroundColor = UIColor.darkGray
        self.addSubview(blurredView)
    }
}
extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


/// Remove UIBlurEffect from UIView
extension UIView {
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
}

//MARK:- Convert iPhoneVideo(.mov) to mp4
extension AVURLAsset
{
    func exportVideo(presetName: String = AVAssetExportPresetHighestQuality, outputFileType: AVFileType = .mp4, fileExtension: String = "mp4", then completion: @escaping (URL?) -> Void)
    {
        let filename = url.deletingPathExtension().appendingPathExtension(fileExtension).lastPathComponent
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        if let session = AVAssetExportSession(asset: self, presetName: presetName) {
            session.outputURL = outputURL
            session.outputFileType = outputFileType
            let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
            let range = CMTimeRangeMake(start: start, duration: duration)
            session.timeRange = range
            session.shouldOptimizeForNetworkUse = true
            session.exportAsynchronously {
                switch session.status {
                case .completed:
                    completion(outputURL)
                case .cancelled:
                    debugPrint("Video export cancelled.")
                    completion(nil)
                case .failed:
                    let errorMessage = session.error?.localizedDescription ?? "n/a"
                    debugPrint("Video export failed with error: \(errorMessage)")
                    completion(nil)
                default:
                    break
                }
            }
        } else {
            completion(nil)
        }
    }
}
