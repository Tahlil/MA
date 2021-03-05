//
//  ViewVideosResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 03/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class ViewVideosResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : ViewVideosDataModel?//[ViewVideosArrModel]?
    
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

class ViewVideosDataModel: Mappable {
    var free_videos                : Int?
    var free_session               : Int?
    var total_videos               : Int?
    var videodata                  : [ViewVideosArrModel]?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        free_videos                   <- map["free_videos"]
        free_session                  <- map["free_session"]
        total_videos                  <- map["total_videos"]
        videodata                     <- map["videodata"]
    }
}


class ViewVideosArrModel: Mappable {
    var id                              : Int?
    var title                           : String? = ""
    var descrip                         : String? = ""
    var sport_id                        : Int?
    var user_id                         : Int?
    var user_type                       : Int? = 0
    var totalviews                      : Int? = 0

    var videourl                        : String? = ""
    var thumbnail_image                 : String? = ""
    var date                            : String? = ""
    var sportname                       : String? = ""
    var deleted_at                      : String? = ""
    var created_at                      : String? = ""
    var updated_at                      : String? = ""
    var username                        : String? = ""
    var image                           : String? = ""
    var isViewVideo                     : Bool? = false
    var isBookmarkVideo                 : Bool? = false
    var subscriptionInfo                : AthleteSubscribeInfoModel?
    var duration                        : String? = ""
    var rate                            : Int? = 0
    var review                          : Int? = 0

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
        title                          <- map["title"]
        descrip                        <- map["description"]
        sport_id                       <- map["sport_id"]
        user_id                        <- map["user_id"]
        user_type                      <- map["user_type"]
        videourl                       <- map["videourl"]
        thumbnail_image                <- map["thumbnail_image"]
        date                           <- map["date"]
        sportname                      <- map["sportname "]
        deleted_at                     <- map["deleted_at"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
        username                       <- map["username"]
        image                          <- map["image"]
        isViewVideo                    <- map["isViewVideo"]
        isBookmarkVideo                <- map["isBookmarkVideo"]
        subscriptionInfo               <- map["subscriptionInfo"]
        duration                       <- map["duration"]
        rate                           <- map["rate"]
        review                         <- map["review"]
        totalviews                     <- map["totalviews"]

    }
}

class AthleteSubscribeInfoModel: Mappable {
//    var subscription_status           : Bool? = false
//    var amount                        : Int? = 0
    var subscribecoach                : AthleteSubscribeVideoModel?
    var subscribesession              : AthleteSubscribeSessionModel?
    
    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func encode(with aCoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
//        subscription_status            <- map["subscription_status"]
//        amount                         <- map["amount"]
        subscribecoach                 <- map["subscribecoach"]
        subscribesession               <- map["subscribesession"]
    }
}

class AthleteSubscribeVideoModel: Mappable {
    var id                            : Int? = 0
    var status                        : Bool? = false
    var subscription_type             : Int? = 0
    var duration                      : Int? = 0
    var validity                      : Int? = 0
    var amount                        : String? = ""
    var tax                           : String? = ""
    var no_of_available               : Int? = 0
    var bookedsubscribesession        : Int? = 0
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    
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
        status                         <- map["status"]
        subscription_type              <- map["subscription_type"]
        duration                       <- map["duration"]
        validity                       <- map["validity"]
        amount                         <- map["amount"]
        tax                            <- map["tax"]
        no_of_available                <- map["no_of_available"]
        bookedsubscribesession         <- map["bookedsubscribesession"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
    }
}

class AthleteSubscribeSessionModel: Mappable {
    var id                            : Int? = 0
    var status                        : Bool? = false
    var subscription_type             : Int? = 0
    var duration                      : Int? = 0
    var validity                      : Int? = 0
    var amount                        : String? = ""
    var no_of_available               : Int? = 0
    var bookedsubscribesession        : Int? = 0
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    var tax                           : String? = ""

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
        status                         <- map["status"]
        subscription_type              <- map["subscription_type"]
        duration                       <- map["duration"]
        validity                       <- map["validity"]
        amount                         <- map["amount"]
        no_of_available                <- map["no_of_available"]
        bookedsubscribesession         <- map["bookedsubscribesession"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
        tax                            <- map["tax"]

    }
}
