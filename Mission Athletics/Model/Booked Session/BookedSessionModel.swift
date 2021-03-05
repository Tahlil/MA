//
//  BookedSessionModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 20, 2019

import Foundation
import ObjectMapper

class BookedSessionModel : Mappable{

    var code                    : String?
    var data                    : BookedSessionDataModel?
    var message                 : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map){
        code                    <- map["code"]
        data                    <- map["data"]
        message                 <- map["message"]
    }

}
class BookedSessionDataModel : Mappable{

    var bookedsession           : [Bookedsession]?
    var totalRecords            : Int?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map){
        bookedsession           <- map["bookedSessionData"]
        totalRecords            <- map["total_records"]
    }
}

class Bookedsession : Mappable{

    var amount                  : String?
    var athlete                 : Athlete?
    var athleteId               : Int?
    var athleteImage            : String?
    var athleteName             : String?
    var bankDetailId            : Int?
    var bookingDate             : String?
    var bookingStatus           : Int?
    var bookingTime             : String?
    var coachId                 : Int?
    var coachPaymentStatus      : String?
    var coachPendingAmount      : String?
    var coachTotalPayAmount     : String?
    var createdAt               : String?
    var dueDate                 : String?
    var id                      : Int?
    var isOnline                : Int?
    var paymentStatus           : String?
    var sessionStatus           : Int?
    var sportId                 : Int?
    var sportName               : String?
    var stripeId                : Int?
    var subscriptionId          : Int?
    var subscriptionType        : String?
    var tax                     : String?
    var total                   : String?
    var updatedAt               : String?
    var coach_name              : String?
    var coach_image             : String?

    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map){
        amount                  <- map["amount"]
        athlete                 <- map["athlete"]
        athleteId               <- map["athlete_id"]
        athleteImage            <- map["athlete_image"]
        athleteName             <- map["athlete_name"]
        bankDetailId            <- map["bank_detail_id"]
        bookingDate             <- map["booking_date"]
        bookingStatus           <- map["booking_status"]
        bookingTime             <- map["booking_time"]
        coachId                 <- map["coach_id"]
        coachPaymentStatus      <- map["coach_payment_status"]
        coachPendingAmount      <- map["coach_pending_amount"]
        coachTotalPayAmount     <- map["coach_total_pay_amount"]
        createdAt               <- map["created_at"]
        dueDate                 <- map["due_date"]
        id                      <- map["id"]
        isOnline                <- map["is_online"]
        paymentStatus           <- map["payment_status"]
        sessionStatus           <- map["session_status"]
        sportId                 <- map["sport_id"]
        sportName               <- map["sport_name"]
        stripeId                <- map["stripe_id"]
        subscriptionId          <- map["subscription_id"]
        subscriptionType        <- map["subscription_type"]
        tax                     <- map["tax"]
        total                   <- map["total"]
        updatedAt               <- map["updated_at"]
        coach_name              <- map["coach_name"]
        coach_image             <- map["coach_image"]

    }
}

class Athlete : Mappable{

    var birthDate               : String?
    var createdAt               : String?
    var deletedAt               : String?
    var descriptionField        : String?
    var deviceToken             : String?
    var email                   : String?
    var emailVerifiedAt         : String?
    var experience              : String?
    var facebookId              : Int?
    var id                      : Int?
    var image                   : String?
    var isOnline                : Int?
    var mobileNo                : String?
    var name                    : String?
    var position                : String?
    var updatedAt               : String?
    var userStatus              : Int?
    var userType                : Int?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map){
        birthDate               <- map["birth_date"]
        createdAt               <- map["created_at"]
        deletedAt               <- map["deleted_at"]
        descriptionField        <- map["description"]
        deviceToken             <- map["device_token"]
        email                   <- map["email"]
        emailVerifiedAt         <- map["email_verified_at"]
        experience              <- map["experience"]
        facebookId              <- map["facebook_id"]
        id                      <- map["id"]
        image                   <- map["image"]
        isOnline                <- map["is_online"]
        mobileNo                <- map["mobile_no"]
        name                    <- map["name"]
        position                <- map["position"]
        updatedAt               <- map["updated_at"]
        userStatus              <- map["user_status"]
        userType                <- map["user_type"]
    }
}
