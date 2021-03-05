//
//  Utility.swift

import UIKit

struct Constants {
    //MARK: - device type
    enum UIUserInterfaceIdiom : Int{
        case Unspecified
        case Phone
        case Pad
    }
}
//Quickblox account keys
struct quickbloxkeys {
    static let kQBApplicationID:UInt = 79875
    static let kQBAuthKey = "ZHFVwpgZsvw6HF7"
    static let kQBAuthSecret = "W-rNkfjdXj9ZW-a"
    static let kQBAccountKey = "RNvkX_hStc3VcDs2D5XS"
}

struct TimeIntervalConstant {
    static let answerTimeInterval: TimeInterval = 60.0
    static let dialingTimeInterval: TimeInterval = 5.0
}

// MARK: - Message's
struct AlertMessage {
    static let noInternetConnectionText = "No internet available"
    static let TermsConditions = "Please accept terms and conditions"
    
    //Authentication
    static let emptyEmail = "Please enter your email"
    static let invalidEmail = "Please enter valid email"
    static let passwordLength = "Password must be minimum 8 characters long."
    static let emptyPassword = "Please enter your password"
    static let enterPasswordAgain = "Please confirm password again"
    static let ConfirmPasswordMatch = "Password and confirm password do not match"
    static let emptyNewPassword = "Please enter new password"
    static let enterNewPasswordAgain = "Please enter new password again"
    static let NewPasswordMatch = "New password and confirm new password do not match"
    static let emptyFullName = "Please enter your full name"
    static let emptyAccountName = "Please enter your account name"
    static let emptyShortBioName = "Please tell us something about yourself in brief"
    static let emptyPhoneNo = "Please enter your phone number"
    static let emptyBirthdate = "Please select your date of birth"
    static let emptyExperience = "Please enter your experience"
    static let emptyPositionsPlayed = "Please enter the positions you have played so far"
    
    static let emptyNewVideo = "Please select video."
    static let emptyNewVideoTitle = "Please enter video title."
    static let emptyNewVideoDesc = "Please enter the description."
    static let emptyNewVideoSportCate = "Please select sport category."
}

enum FriendType: String {
    case AllUser = "1"
    case MyFriends = "2"
}

enum UserType: String {
    case Coach = "2"
    case Athlete = "3"
}

enum ChatRequest: String {
    case Accept = "1"
    case Reject = "2"//"0"//
}

enum SubscriptionType: String {
    case SubscribeVideo = "1"
    case FreeSession = "2"
    case SubscribeSession = "3"
}

enum CompareVideoRequestStatus:String {
    case Pending = "1"
    case Accepted = "2"
    case Rejected = "3"
    case Deleted = "4"
}

struct MenuItems
{
    static let arrMenu = ["Search", "Help & Info", "Sign up", "Sign in"]
    
    static let arrLoggedInMenu = ["Home", "Search", "Booking", "Profile", "Help & Info", "Signout"]
    
    static let arrSelectedMenuIcons = ["@home","@timeline","@shift_overview","@guest_book","@waiter_section","@food_order","@front_of_house", "@reports", "@settings", "@notifications", "@logout"]
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPhone_X          = UIScreen.main.nativeBounds.height == 2436
}

// MARK: - Global Utility
struct GlobalConstants {
    static let appName    =  Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let AuthenticationStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
    static let ChatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
    static let ProfileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    static let SessionStoryboard = UIStoryboard(name: "Session", bundle: nil)
    
    //Navigation controller identifier
    static let tabBarController = MainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
    static let profileNavigation = ProfileStoryboard.instantiateViewController(withIdentifier: "profileNavigation")
    static let homeNavigation = MainStoryboard.instantiateViewController(withIdentifier: "homeNavigation")
    static let authenticationNavigation = AuthenticationStoryboard.instantiateViewController(withIdentifier: "AuthenticationNavigation")
}

struct UserDefaultsKey {
    static let user                     = "UserInfo"
    
    //Request
    static let DEVICE_UDID              = "DEVICE_UDID"
    static let GCM_KEY                  = "GCM_KEY"
    static let FCM_TOKEN                = "FCM_TOKEN"
}


struct DefaultValues{
    static let USER_PLACEHOLDER         =   "User_Placeholder"
}


struct dateFormat {
    static let MMMM_dd_yyyy             = "MMMM dd yyyy"
    static let yyyy_MM_dd               = "yyyy-MM-dd"
    static let yyyy_MM_dd_HH_mm_ss      = "yyyy-MM-dd HH:mm:ss"
    static let MMM_dd_yyyy              = "MMM dd,yyyy"     // jan 13,2018
    static let MM_dd_yyyy               = "MM/dd/yyyy"   //06/14/2018
    static let dd_MMM_yyyy              = "dd MMM yyyy"
    static let EEEE_MMM_d_yyyy          = "EEEE, MMM d, yyyy" //Thursday, Jun 14, 2018
    static let MM_dd_yyyy_HH_mm         = "MM-dd-yyyy HH:mm"  //06-14-2018 06:57
    static let MM_dd_yyyy_HH_mma        = "MM-dd-yyyy hh:mma"
    static let MMM_d_h_mm_a             = "MMM d, h:mm a"  //Jun 14, 6:57 AM
    static let E_d_MMM_yyyy_HH_mm_ss_Z  = "E, d MMM yyyy HH:mm:ss Z" //Thu, 14 Jun 2018 06:57:26 +0000
    static let yyyy_MM_dd_T_HH_mm_ssZ   = "yyyy-MM-dd'T'HH:mm:ssZ" //2018-06-14T06:57:26+0000
    static let MMMM_yyyy                = "MMMM yyyy"
    static let MMM_yyyy                 = "MMM yyyy"
    static let YYYY_MM_DD               = "yyyy/MM/dd"
    static let hh_mma                   = "hh:mma"
    static let hh_mm                    = "hh:mm"
    static let HH_mm                    = "HH:mm"
    static let HH_mm_ss                 = "HH:mm:ss"
    static let HH_mm_ss_a               = "hh:mm:ss a"
    static let hh                       = "hh"
    static let mm                       = "mm"
    static let a                        = "a"
    static let yyyy_MM_dd_HH_mm         = "yyyy/MM/dd HH:mm"
    static let yyyy_MM                  = "yyyy-MM"
    static let yyyy                     = "yyyy"
}

class EmojiTextField: UITextField {
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
