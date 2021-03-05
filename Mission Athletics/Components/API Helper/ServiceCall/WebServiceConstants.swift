//
//  WebServiceConstants.swift
//  HelpOnDemandServieApp
//
//  Created by Amul on 05/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

internal struct WebService {
    
    //MARK: - BaseURL
//    static let baseURL = "https://trootechproducts.com:8015/api/"
//    static let baseURLForLogin = "http://www.trootechproducts.com:5581"
    
    static let baseURL = "http://54.190.124.60/api/"
    static let baseURLForLogin = "http://54.190.124.60"

    
    //MARK: Authentication
    static let login : String                          = "login" //--
    static let socialLogin: String                     = "sociallogin" //--
    static let socialCheck: String                     = "socialCheck"//
    static let register: String                        = "register" //--
    static let forgotPassword: String                  = "password/email"//--
    
    static let logout : String                         = "logout"//--
    
    //MARK: Home
    static let getSports: String                       = "getsports" //--
    static let saveSports: String                      = "saveSportFilter"//--
    static let viewAllPlayers: String                  = "viewAllPlayers"//--
    static let viewAllTrainers: String                 = "viewAllTrainers"//--

    
    //MARK: Profile Settings
    static let getSettings: String                     = "getsetting"//--
    static let changeSettings: String                  = "changesetting"//--
    static let getTermsPrivacyData: String             = "termsList"//--
    
    //MARK: Profile
    static let getProfile: String                      = "getprofile" //--
    static let editProfile: String                     = "editprofile"//--
    
    //MARK: Video
    static let addVideo: String                        = "addvideo"//--
    static let updateVideo: String                     = "editvideo"//--
    static let searchVideo: String                     = "searchVideo"//--

    static let viewVideos: String                      = "viewVideo"//--
    static let viewCoachVideos: String                 = "getCoachVideo"//--
    static let bookmarkVideo: String                   = "bookmarkVideo"//
    static let removeBookmarkVideo: String             = "removeBookmarkVideo"//
    static let viewAllBookmarkVideo: String            = "viewAllBookmarkVideo"//
    static let videoComparisionRequest: String         = "videoComparisionRequest"//--
    static let viewAllAthleteVideo: String             = "viewAllAthleteVideo"//--
    static let viewAllCoachVideo: String               = "viewAllCoachVideo"//--
    static let viewAllReviews: String                  = "viewAllReviews"//--
    static let rating: String                          = "rating"//--

    
    //MARK: Friends
    static let sendFriendRequest: String               = "sendChatRequest"//--
    
    //MARK: Support
    static let support: String                         = "support"//--
    static let getInquiryList: String                  = "getInquiryList"//--
    
    //MARK: Chat
    static let acceptReject: String                    = "acceptRejectRequest"//--
    static let getFriends: String                      = "friendList"//--
    
    //MARK: Notification
    static let getAllNotification: String              = "getNotificationList"//--
    static let seenNotification: String                = "seenNotification"//--
    static let getCountNotification: String            = "getCountNotification"//--
    
    //MARK: Socket
    static let LivesocketUrl: String                   = "http://54.190.124.60"
    static let LivesocketNode: String                  = "/socket.io"//"/socket/socket.io"
    
    //MARK: Subscriptions
    static let checkBankDetail: String                 = "checkBankDetail"//--
    static let addBankDetails: String                  = "addBankDetails"//--
    static let subscribeCoach: String                  = "subscribeCoach"//--
    static let watchVideoCount:String                  = "watchVideoCount"
    static let manageTimeSlot:String                   = "manageTimeSlot"
    static let viewAllSubscription:String              = "viewAllSubscription"
    static let cancelSubscription:String               = "cancelSubscription"

    static let sessionCoach:String                     = "sessionCoach"
    static let viewAllCoachBookedSession:String        = "viewAllCoachBookedSession"
    static let acceptCancelSessionRequest:String       = "acceptCancelSessionRequest"
    static let viewAllComparisionRequest:String        = "viewAllComparisionRequest"
    static let sendWithdrawRequest:String              = "sendWithdrawRequest"
    static let viewAllBookedSession:String             = "viewAllBookedSession"
    static let listWithdrawRequest:String              = "listWithdrawRequest"
    static let addUnavailability:String                = "addUnavailability"
    static let videoviews:String                       = "videoviews"
    static let deleteVideo:String                      = "deleteVideo"

    static let twillioToken:String                     = "twillioToken"

    static let sendPushNotificationToReciever:String   = "getPush"
    static let cancelCall:String                       = "cancelVideoPush"
    
    //MARK:- Strip API
    static let generateCardToken: String               = "https://api.stripe.com/v1/tokens"//--

    
    //MARK: - To Create URL for Web Service
    internal static func createURLForWebService(_ webServiceName : String) -> String {
        let URL:String = String(format: "\(WebService.baseURL)\(webServiceName)")
        return URL
    }
    
    internal static func createURLForWebServiceOnlyLogin(_ webServiceName : String) -> String {
        let URL:String = String(format: "\(WebService.baseURLForLogin)\(webServiceName)")
        return URL
    }
    
}


