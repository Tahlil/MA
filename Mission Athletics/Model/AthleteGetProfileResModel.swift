//
//  AthleteGetProfileResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 19/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class AthleteGetProfileResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : AthleteGetProfileDataModel?
    
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

class AthleteGetProfileDataModel: Mappable {
    var id                            : Int?
    var name                          : String? = ""
    var email                         : String? = ""
    var email_verified_at             : String? = ""
    var user_type                     : Int? = 0
    var mobile_no                     : String? = ""
    var birth_date                    : String? = ""
    var image                         : String? = ""
    var device_token                  : String? = ""
    var facebook_id                   : String? = ""
    var experience                    : String? = ""
    var position                      : String? = ""
    var descrip                       : String? = ""
    var user_status                   : Bool? = false
    var stripe_id                     : String? = ""
    var card_brand                    : String? = ""
    var card_last_four                : String? = ""
    var trial_ends_at                 : String? = ""
    var token                         : String? = ""
    var bookmarkVideo                 : [ViewVideosArrModel]?
    var myVideos                      : [AthleteMyVideosArrModel]?
    var deleted_at                    : String? = ""
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    var totalFriends                  : Int? = 0
    var totalPost                     : Int? = 0
    var totalTrainer                  : Int? = 0
    var free_session                  : Int? = 0
    var free_videos                   : Int? = 0
    var subscribe_session             : Int? = 0
    var subscribe_video               : Int? = 0


    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }

    func mapping(map: Map)
    {
        id                             <- map["id"]
        name                           <- map["name"]
        email                          <- map["email"]
        email_verified_at              <- map["email_verified_at"]
        user_type                      <- map["user_type"]
        mobile_no                      <- map["mobile_no"]
        birth_date                     <- map["birth_date"]
        image                          <- map["image"]
        device_token                   <- map["device_token"]
        facebook_id                    <- map["facebook_id"]
        experience                     <- map["experience"]
        position                       <- map["position"]
        descrip                        <- map["description"]
        user_status                    <- map["user_status"]
        stripe_id                      <- map["stripe_id"]
        card_brand                     <- map["card_brand"]
        card_last_four                 <- map["card_last_four"]
        trial_ends_at                  <- map["trial_ends_at"]
        token                          <- map["token"]
        bookmarkVideo                  <- map["videodata"]
        myVideos                       <- map["myVideos"]
        deleted_at                     <- map["deleted_at"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
        totalFriends                   <- map["totalFriends"]
        totalPost                      <- map["totalPost"]
        totalTrainer                   <- map["totalTrainer"]
        free_session                   <- map["free_session"]
        free_videos                    <- map["free_videos"]
        subscribe_session              <- map["subscribe_session"]
        subscribe_video                <- map["subscribe_video"]

    }
}

class AthleteBookmarkVideosArrModel: Mappable {
    var sport_id                      : Int?
    var video_id                      : Int?
    var coach_id                      : Int?
    var title                         : String? = ""
    var descrip                       : String? = ""
    var videourl                      : String? = ""
    var thumbnail_image               : String? = ""
    var coach_name                    : String? = ""
    var date                          : String? = ""


    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }

    func mapping(map: Map)
    {
        sport_id                       <- map["sport_id"]
        video_id                       <- map["video_id"]
        coach_id                       <- map["coach_id"]
        title                          <- map["title"]
        descrip                        <- map["description"]
        videourl                       <- map["videourl"]
        thumbnail_image                <- map["thumbnail_image"]
        coach_name                     <- map["coach_name"]
        date                           <- map["date"]

    }
}

class AthleteMyVideosArrModel: Mappable {
    var id                            : Int?
    var athlete_id                    : Int?
    var coach_id                      : Int?
    var status                        : Int?
    var coach_video_id                : Int?
    var title                         : String? = ""
    var athlete_video                 : String? = ""
    var date                          : String? = ""
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    var thumbnail_image               : String? = ""
    var deleted_at                    : String? = ""
    var description                   : String? = ""
    var sport_id                      : Int?
    var user_id                       : String? = ""
    var videourl                      : String? = ""

    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }

    func mapping(map: Map)
    {
        id                             <- map["id"]
        athlete_id                     <- map["athlete_id"]
        coach_id                       <- map["coach_id"]
        status                         <- map["status"]
        coach_video_id                 <- map["coach_video_id"]
        title                          <- map["title"]
        athlete_video                  <- map["athlete_video"]
        date                           <- map["date"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
        thumbnail_image                <- map["thumbnail_image"]
        deleted_at                     <- map["deleted_at"]
        description                    <- map["description"]
        sport_id                       <- map["sport_id"]
        user_id                        <- map["user_id"]
        videourl                       <- map["videourl"]

    }
}
