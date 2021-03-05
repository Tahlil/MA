//
//  AppDelegate.swift
//  Mission Athletics
//
//  Created by Mac on 02/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import CallKit
import FacebookCore
import Firebase
import Intents
import IQKeyboardManagerSwift
import ObjectMapper
import PushKit
import SVProgressHUD
import TwilioVideo
import UIKit

struct AppDelegateConstant {
    static let enableStatsReports: UInt = 1
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    lazy private var backgroundTask: UIBackgroundTaskIdentifier = {
        let backgroundTask = UIBackgroundTaskIdentifier.invalid
        return backgroundTask
    }()

    var isSocialLogin = false
    var isPasswordChange = false
    var isChatDetailScreenOpen = false
    
    var notifiObjChat:[String:Any] = [:]
    var notifiObjReqReceive:[String:Any] = [:]
    var notifiObjReqAccepted:[String:Any] = [:]
    var notifiObjReqSession:[String:Any] = [:]
    var notifiObjReqCalling:[String:Any] = [:]

    var notifiObjHome:String = ""

    //MARK:- Application state lifecycle methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.shared.enable = true
        UITextField.appearance().tintColor = UIColor.cursorTintColor
        UITextView.appearance().tintColor = UIColor.cursorTintColor

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        
        let registry = PKPushRegistry(queue: nil)
        registry.delegate = self
        registry.desiredPushTypes = [PKPushType.voIP]

        
        //FIREBASE Notification Register -
        self.setUpPushNotificationsForApplication(application)
//        let token = Messaging.messaging().fcmToken
//        print("Launch time token: \(String(describing: token))")
        self.registerForLocalNotifications()
        self.setRootViewController()
        return true
    }
    
    func registerForLocalNotifications() {
        // Define the custom actions.
        let inviteAction = UNNotificationAction(identifier: "INVITE_ACTION",
              title: "Simulate VoIP Push",
              options: UNNotificationActionOptions(rawValue: 0))
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Decline",
              options: .destructive)
        let notificationCenter = UNUserNotificationCenter.current()

        // Define the notification type
        let meetingInviteCategory = UNNotificationCategory(identifier: "ROOM_INVITATION",
                                                           actions: [inviteAction, declineAction],
                                                           intentIdentifiers: [],
                                                           options: .customDismissAction)
        notificationCenter.setNotificationCategories([meetingInviteCategory])

        // Register for notification callbacks.
        notificationCenter.delegate = self

        // Request permission to display alerts and play sounds.
        notificationCenter.requestAuthorization(options: [.alert])
           { (granted, error) in
              // Enable or disable features based on authorization.
           }
    }

//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        guard let viewController = window?.rootViewController as? SessionLoadingVC, let interaction = userActivity.interaction else {
//            return false
//        }
//
//        var personHandle: INPersonHandle?
//
//        if let startVideoCallIntent = interaction.intent as? INStartVideoCallIntent {
//            personHandle = startVideoCallIntent.contacts?[0].personHandle
//        } else if let startAudioCallIntent = interaction.intent as? INStartAudioCallIntent {
//            personHandle = startAudioCallIntent.contacts?[0].personHandle
//        }
//
//        return true
//    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Logging out from chat.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Logging out from chat.
    }

    //MARK:- Open URl
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return ApplicationDelegate.shared.application(
        application,
        open: url,
        sourceApplication: sourceApplication,
        annotation: annotation
      )
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return ApplicationDelegate.shared.application(application, open: url, options: options)
    }

    //MARK:- SetRootController
    func setRootViewController()
    {
        if getUserInfo() != nil {
            let nextVC = GlobalConstants.tabBarController
            let navVC = UINavigationController(rootViewController: nextVC)
            navVC.setNavigationBarHidden(true, animated: true)
            let mainStoryboard = GlobalConstants.MainStoryboard
            GlobalConstants.appDelegate.window?.rootViewController = mainStoryboard.instantiateInitialViewController()
            GlobalConstants.appDelegate.window?.makeKeyAndVisible()
            
            self.getUnreadNotifyCountAPICall()
        } else {
            let authenStoryboard = GlobalConstants.AuthenticationStoryboard
            GlobalConstants.appDelegate.window?.rootViewController = authenStoryboard.instantiateInitialViewController()
            GlobalConstants.appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    //MARK:- Unread Notification count API Call -
    func getUnreadNotifyCountAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.getCountNotification)
            print(url)
            
//            var reqParam:[String:Any] = [:]
//            reqParam["user_id"] = self.userId
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .get, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<GetUnreadNotifyCountResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data
                        {
                            if let tabVC = self.window?.rootViewController as? UITabBarController {
                                if tabVC.isKind(of: UITabBarController.self) {
                                    changeTabItemImage(tabBar: tabVC, index: 1, newNotifications: (data.unReadCount ?? 0) == 0 ? false : true)
                                }
                            }
                        }
                        print("success")
                    }else{
//                        AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
                    }
                }else{
                    HideProgress()
                }
            }
        }else{
//            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
}

//MARK:- Push notification Methods -
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate{
    
    func setUpPushNotificationsForApplication(_ application: UIApplication) {
        //Firebase Setup
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in } )
        
        let action = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: "myCategory", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        application.registerForRemoteNotifications()
    }
    
    
    // MARK: - Remote notification -
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
        print("DEVICE token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        print("Device UDID : \(token)")
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote InstanceID token: \(result.token)")
                UserDefaults.standard.set(result.token, forKey: UserDefaultsKey.FCM_TOKEN)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ application: UIApplication,_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo as! [String: Any]
        print(userInfo)
        if let data = userInfo["data"] {
            let dict = convertToDictionary(text: data as! String)

            if let type = dict?["type"] as? String {
                print(type)
                if type == "request-videocall"{
                    if let notification = dict?["data"] as? [String:Any] {
                        self.notifiObjReqCalling = notification
                    }
                    
//                    self.notifiObjHome = "videoCall"
//                    if let _ = getUserInfo() {//userData
//                        if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
//                            tabVC.selectedIndex = 0
//                        }
//                        NotificationCenter.default.post(name: Notification.Name("callingViewcontroller"), object: self.notifiObjReqCalling)
//                    }
                    
                    var strRoomName = ""
                    if let requestedName = dict?["data"] as? NSDictionary {
                        print(requestedName["room_name"] as Any)
                        strRoomName = requestedName["room_name"] as? String ?? ""
                    }

                    let config = CXProviderConfiguration(localizedName: "Mission Athletics")
                    config.ringtoneSound = "ringtone.caf"
                    config.includesCallsInRecents = false;
                    config.supportsVideo = true;
                    config.maximumCallGroups = 1
                    config.maximumCallsPerCallGroup = 1

                    let provider = CXProvider(configuration: config)
                    provider.setDelegate(self, queue: nil)
                    let update = CXCallUpdate()
                    update.supportsGrouping = false
                    update.supportsUngrouping = false
                    update.supportsHolding = false

//                    update.
                    update.remoteHandle = CXHandle(type: .generic, value: strRoomName)
                    update.hasVideo = true
                    provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })

                }else{
                    if !self.isChatDetailScreenOpen {
                        completionHandler([.alert, .sound, .badge])
                    }
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        let userInfo = notification.request.content.userInfo as! [String: Any]
        print(userInfo)
        print("Received in foreground")
        print("Received in active mode")
        print(userInfo)
        if let data = userInfo["data"] {
            let dict = convertToDictionary(text: data as! String)

            if let type = dict?["type"] as? String {
                print(type)
                if type == "request-videocall"{
                    if let notification = dict?["data"] as? [String:Any] {
                        self.notifiObjReqCalling = notification
                    }
                    var strRoomName = ""
                    if let requestedName = dict?["data"] as? NSDictionary {
                        print(requestedName["room_name"] as Any)
                        strRoomName = requestedName["room_name"] as? String ?? ""
                    }

//                    self.notifiObjHome = "videoCall"
//                    if let _ = getUserInfo() {//userData
//                        if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
//                            tabVC.selectedIndex = 0
//                        }
//                        NotificationCenter.default.post(name: Notification.Name("callingViewcontroller"), object: self.notifiObjReqCalling)
//                    }
                    
                    let config = CXProviderConfiguration(localizedName: "Mission Athletics")
                    config.ringtoneSound = "ringtone.caf"
                    config.includesCallsInRecents = false
                    config.supportsVideo = true
                    let provider = CXProvider(configuration: config)
                    provider.setDelegate(self, queue: nil)
                    let update = CXCallUpdate()
                    update.supportsGrouping = false
                    update.supportsUngrouping = false
                    update.supportsHolding = false

                    update.remoteHandle = CXHandle(type: .generic, value: strRoomName)
                    update.hasVideo = true
                    provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
                }else{
                    if !self.isChatDetailScreenOpen {
                        completionHandler([.alert, .sound, .badge])
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if #available(iOS 10.0, *)  {
            print("Received in foreground")
            print(userInfo)

            return
        } else {
            if(application.applicationState == .active){
                //handle foreground state
                print("Received in foreground")
                print(userInfo)
            }else{
                //handle background state on tap of notification
                print("Received in background")
                print(userInfo)
            }
        }
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any] {
            print(userInfo)
            if let data = userInfo["data"] {
                print(data)
                let dict = convertToDictionary(text: data as! String)
                
                if let type = dict?["type"] as? String {
                    
                    if type == "message" {
                        if let msg = dict?["message"] as? [String:Any] {
                            self.notifiObjChat = msg
                            if let _ = getUserInfo() {//userData
                                if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                                    tabVC.selectedIndex = 2
                                    
                                }
                                NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForChat"), object: nil)
                            }
                        }
                    }
                    else if type == "request-received" {
                        if let notification = dict?["data"] as? [String:Any] {
                            self.notifiObjReqReceive = notification
                            
                            if let _ = getUserInfo() {//userData
                                if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                                    tabVC.selectedIndex = 1
                                    
                                }
                                NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForRespondingRequest"), object: nil)
                            }
                        }
                    }
                    else if type == "request-accepted" {
                        if let notification = dict?["data"] as? [String:Any] {
                            self.notifiObjReqAccepted = notification
                            
                            if let _ = getUserInfo() {//userData
                                if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                                    tabVC.selectedIndex = 1
                                    
                                }
                                NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForRespondingRequest"), object: nil)
                            }
                        }
                    }
                    else if type == "request-freesession" {
                        if let notification = dict?["data"] as? [String:Any] {
                            self.notifiObjReqSession = notification
                            
                            if let _ = getUserInfo() {//userData
                                if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                                    tabVC.selectedIndex = 1
                                    
                                }
                                NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForRespondingRequest"), object: nil)
                            }
                        }
                    }
                    else if type == "request-subscriptions" {
                        if let notification = dict?["data"] as? [String:Any] {
                            self.notifiObjReqSession = notification
                            
                            if let _ = getUserInfo() {//userData
                                if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                                    tabVC.selectedIndex = 1
                                    
                                }
                                NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForRespondingRequest"), object: nil)
                            }
                        }
                    }else if type == "request-subscribesession" {
                        if let notification = dict?["data"] as? [String:Any] {
                            self.notifiObjReqSession = notification
                            
                            if let _ = getUserInfo() {//userData
                                if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                                    tabVC.selectedIndex = 1
                                }
                                NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForRespondingRequest"), object: nil)
                            }
                        }
                    } else if type == "request-videocall" {
                        if let notification = dict?["data"] as? [String:Any] {
                            self.notifiObjReqCalling = notification
                        }
//                        self.notifiObjHome = "videoCall"
                        
                        if let _ = getUserInfo() {//userData
                            if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                                tabVC.selectedIndex = 0
                            }
//                            NotificationCenter.default.post(name: Notification.Name("callingViewcontroller"), object: self.notifiObjReqCalling)

                            NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForHome"), object: self.notifiObjReqCalling)
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Push notification handling helpers
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
extension AppDelegate : PKPushRegistryDelegate{
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
        let deviceToken = (pushCredentials.token as NSData).description
        print(deviceToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        let config = CXProviderConfiguration(localizedName: "My App")
        config.ringtoneSound = "ringtone.caf"
        config.includesCallsInRecents = false
        config.supportsVideo = true
        let provider = CXProvider(configuration: config)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Pete Za")
        update.hasVideo = true
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
    }

}
extension AppDelegate : CXProviderDelegate {


    func providerDidReset(_ provider: CXProvider) {
        print("providerDidReset")
    }

    func providerDidBegin(_ provider: CXProvider) {
       print("providerDidBegin")
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
      print("provider:didActivateAudioSession:")

       // self.audioDevice.isEnabled = true
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
      print("provider:didDeactivateAudioSession:")
    }

    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
      print("provider:timedOutPerformingAction:")
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
      print("provider:performStartCallAction:")

        /*
         * Configure the audio session, but do not start call audio here, since it must be done once
         * the audio session has been activated by the system after having its priority elevated.
         */
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
       print("provider:performAnswerCallAction:")

        self.notifiObjHome = "videoCall"
        
        if let _ = getUserInfo() {//userData
            if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                tabVC.selectedIndex = 0
            }
            action.fulfill(withDateConnected: Date())
            NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForHome"), object: self.notifiObjReqCalling)
        }
        /*
         * Configure the audio session, but do not start call audio here, since it must be done once
         * the audio session has been activated by the system after having its priority elevated.
         */

    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        NSLog("provider:performEndCallAction:")

        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        NSLog("provier:performSetMutedCallAction:")
                
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        NSLog("provier:performSetHeldCallAction:")
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        NSLog("provier:performSetHeldCallAction:")

    }
    func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
        NSLog("provier:performSetHeldCallAction:")

    }
}
