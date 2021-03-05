//
//  CoachVideosResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 09/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class CoachVideosResModel: Mappable
{
    var code                       : String?
    var message                    : String?
    var data                       : CoachVideosResDataModel?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message                       <- map["message"]
        code                          <- map["code"]
        data                          <- map["data"]
    }
}

class CoachVideosResDataModel: Mappable
{
    var video                         : [CoachVideosArrModel]?
    var players                       : [CoachMyPlayersArrModel]?
    var total_records                 : Int?

    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func encode(with aCoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
        video                          <- map["video"]
        players                        <- map["players"]
        total_records                        <- map["total_records"]

    }
}

class CoachVideosArrModel: Mappable
{
    var id                            : Int?
    var sport_id                      : Int?
    var user_id                       : Int?
    var isViewVideo                   : Int?
    var totalviews                   : Int?

    var title                         : String? = ""
    var descrip                       : String? = ""
    var videourl                      : String? = ""
    var thumbnail_image               : String? = ""
    var date                          : String? = ""
    var sportname                     : String? = ""
    var deleted_at                    : String? = ""
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    var username                      : String? = ""
    var image                         : String? = ""
    var userimage                     : String? = ""
    var isBookmarkVideo               : Bool? = false
    
    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func encode(with aCoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
        id                             <- map["id"]
        sport_id                       <- map["sport_id"]
        user_id                        <- map["user_id"]
        isViewVideo                    <- map["isViewVideo"]
        totalviews                     <- map["totalviews"]

        title                          <- map["title"]
        descrip                        <- map["description"]
        videourl                       <- map["videourl"]
        thumbnail_image                <- map["thumbnail_image"]
        date                           <- map["date"]
        sportname                      <- map["sportname "]
        deleted_at                     <- map["deleted_at"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
        username                       <- map["username"]
        image                          <- map["image"]
        userimage                      <- map["userimage"]
        isBookmarkVideo                <- map["isBookmarkVideo"]
    }
}

class CoachMyPlayersArrModel: Mappable
{
    var id                            : Int?
    var athlete_id                    : Int?
    var coach_id                      : Int?
    var subscription_id               : Int?
    var amount                        : String? = ""
    var tax                           : String? = ""
    var total                         : String? = ""
    var booking_date                  : String? = ""
    var due_date                      : String? = ""
    var booking_time                  : String? = ""
    var booking_status                : Bool? = false
    var bank_detail_id                : Int? = 0
    var stripe_id                     : Int? = 0
    var payment_status                : Bool? = false
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    var coach_pending_amount          : String? = ""
    var coach_payment_status          : String? = ""
    var coach_total_pay_amount        : String? = ""
    var session_status                : Bool? = false
    var sport_id                      : Int?
    var name                          : String? = ""
    var image                         : String? = ""
    var userimage                     : String? = ""
    
    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func encode(with aCoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
        id                             <- map["id"]
        athlete_id                     <- map["athlete_id"]
        coach_id                       <- map["coach_id"]
        subscription_id                <- map["subscription_id"]
        amount                         <- map["amount"]
        tax                            <- map["tax"]
        total                          <- map["total"]
        booking_date                   <- map["booking_date"]
        due_date                       <- map["due_date"]
        booking_time                   <- map["booking_time"]
        booking_status                 <- map["booking_status"]
        bank_detail_id                 <- map["bank_detail_id"]
        stripe_id                      <- map["stripe_id"]
        payment_status                 <- map["payment_status"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
        coach_pending_amount           <- map["coach_pending_amount"]
        coach_payment_status           <- map["coach_payment_status"]
        coach_total_pay_amount         <- map["coach_total_pay_amount"]
        session_status                 <- map["session_status"]
        sport_id                       <- map["sport_id"]
        name                           <- map["name"]
        image                          <- map["image"]
        userimage                      <- map["userimage"]
    }
}

