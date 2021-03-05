//
//  GetProfileResModel.swift
//  Mission Athletics
//
//  Created by MAC  on 24/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class GetProfileResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : GetProfileDataModel?
    
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

class GetProfileDataModel:Mappable { //NSObject, Mappable, NSCoding {
    var id                            : Int?
    var name                          : String? = ""
    var email                         : String? = ""
    var email_verified_at             : String? = ""
    var user_type                     : Int? = 0
    var mobile_no                     : String? = ""
    var birth_date                    : String? = ""
    var image                         : String? = ""
    var profile_pic                   : String? = ""
    var device_token                  : String? = ""
    var facebook_id                   : String? = ""
    var experience                    : String? = ""
    var position                      : String? = ""
    var description                       : String? = ""
    var deleted_at                    : String? = ""
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    var videoData                     : [ViewVideosArrModel]?
    var totalFriends                  : Int? = 0
    var total_videos                  : Int? = 0
    var total_subscribers             : Int? = 0
    var review                        : Int? = 0
    var rate                          : Double? = 0.0
    var subscribe_session             : Int? = 0
    var subscribe_video               : Int? = 0
    var free_session                  : Int? = 0
    var free_videos                   : Int? = 0
    var booked_subscribe_session      : Int? = 0

    required init?(map: Map)
    {
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        self.id = aDecoder.decodeObject(forKey: "id") as? Int
//        self.name = aDecoder.decodeObject(forKey: "name") as? String
//        self.email = aDecoder.decodeObject(forKey: "email") as? String
//        self.email_verified_at = aDecoder.decodeObject(forKey: "email_verified_at") as? String
//        self.user_type = aDecoder.decodeObject(forKey: "user_type") as? Int
//        self.mobile_no = aDecoder.decodeObject(forKey: "mobile_no") as? String
//        self.birth_date = aDecoder.decodeObject(forKey: "birth_date") as? String
//        self.image = aDecoder.decodeObject(forKey: "image") as? String
//        self.device_token = aDecoder.decodeObject(forKey: "device_token") as? String
//        self.facebook_id = aDecoder.decodeObject(forKey: "facebook_id") as? String
//        self.experience = aDecoder.decodeObject(forKey: "experience") as? String
//        self.position = aDecoder.decodeObject(forKey: "position") as? String
//        self.descrip = aDecoder.decodeObject(forKey: "description") as? String
//        self.deleted_at = aDecoder.decodeObject(forKey: "deleted_at") as? String
//        self.created_at = aDecoder.decodeObject(forKey: "created_at") as? String
//        self.updated_at = aDecoder.decodeObject(forKey: "updated_at") as? String
//        self.videoData = aDecoder.decodeObject(forKey: "videoData") as? [GetProfileVideoDataModel]
//
//    }
//
//    func encode(with aCoder: NSCoder)
//    {
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(email, forKey: "email")
//        aCoder.encode(email_verified_at, forKey: "email_verified_at")
//        aCoder.encode(user_type, forKey: "user_type")
//        aCoder.encode(mobile_no, forKey: "mobile_no")
//        aCoder.encode(birth_date, forKey: "birth_date")
//        aCoder.encode(image, forKey: "image")
//        aCoder.encode(device_token, forKey: "device_token")
//        aCoder.encode(facebook_id, forKey: "facebook_id")
//        aCoder.encode(experience, forKey: "experience")
//        aCoder.encode(position, forKey: "position")
//        aCoder.encode(descrip, forKey: "description")
//        aCoder.encode(deleted_at, forKey: "deleted_at")
//        aCoder.encode(created_at, forKey: "created_at")
//        aCoder.encode(updated_at, forKey: "updated_at")
//        aCoder.encode(videoData, forKey: "videoData")
//
//    }
    
    func mapping(map: Map)
    {
        id                              <- map["id"]
        name                            <- map["name"]
        email                           <- map["email"]
        email_verified_at               <- map["email_verified_at"]
        user_type                       <- map["user_type"]
        mobile_no                       <- map["mobile_no"]
        birth_date                      <- map["birth_date"]
        image                           <- map["image"]
        profile_pic                           <- map["profile_pic"]
        device_token                    <- map["device_token"]
        facebook_id                     <- map["facebook_id"]
        experience                      <- map["experience"]
        position                        <- map["position"]
        description                         <- map["description"]
        deleted_at                      <- map["deleted_at"]
        created_at                      <- map["created_at"]
        updated_at                      <- map["updated_at"]
        videoData                       <- map["videodata"]
        totalFriends                    <- map["totalFriends"]
        total_videos                    <- map["total_videos"]
        total_subscribers               <- map["total_subscribers"]
        rate                            <- map["rate"]
        review                          <- map["review"]
        subscribe_session               <- map["subscribe_session"]
        subscribe_video                 <- map["subscribe_video"]
        free_session                    <- map["free_session"]
        free_videos                     <- map["free_videos"]
        booked_subscribe_session        <- map["booked_subscribe_session"]

    }
}
class GetProfileVideoDataModel: Mappable {
    var created_at                  : String?
    var date                        : String?
    var deleted_at                  : String?
    var description                 : String?
    var id                          : Int?
    var sport_id                    : Int?
    var thumbnail_image             : String?
    var title                       : String?
    var updated_at                  : String?
    var user_id                     : Int?
    var videourl                    : String?

    required init(){
    }

    required init?(map: Map) {
    }
//    required init?(coder aDecoder: NSCoder) {
//        self.created_at = aDecoder.decodeObject(forKey: "created_at") as? String
//        self.date = aDecoder.decodeObject(forKey: "date") as? String
//        self.deleted_at = aDecoder.decodeObject(forKey: "deleted_at") as? String
//        self.description = aDecoder.decodeObject(forKey: "description") as? String
//        self.id = aDecoder.decodeObject(forKey: "id") as? Int
//        self.sport_id = aDecoder.decodeObject(forKey: "sport_id") as? Int
//        self.thumbnail_image = aDecoder.decodeObject(forKey: "thumbnail_image") as? String
//        self.title = aDecoder.decodeObject(forKey: "title") as? String
//        self.updated_at = aDecoder.decodeObject(forKey: "updated_at") as? String
//        self.user_id = aDecoder.decodeObject(forKey: "user_id") as? Int
//        self.videourl = aDecoder.decodeObject(forKey: "videourl") as? String
//
//    }
//    func encode(with aCoder: NSCoder)
//    {
//        aCoder.encode(created_at, forKey: "created_at")
//        aCoder.encode(date, forKey: "date")
//        aCoder.encode(deleted_at, forKey: "deleted_at")
//        aCoder.encode(description, forKey: "description")
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(sport_id, forKey: "sport_id")
//        aCoder.encode(thumbnail_image, forKey: "thumbnail_image")
//        aCoder.encode(title, forKey: "title")
//        aCoder.encode(updated_at, forKey: "updated_at")
//        aCoder.encode(user_id, forKey: "user_id")
//        aCoder.encode(videourl, forKey: "videourl")
//
//    }
    
    
    func mapping(map: Map) {
        created_at                          <- map["created_at"]
        date                                <- map["date"]
        deleted_at                          <- map["deleted_at"]
        description                         <- map["description"]
        id                                  <- map["id"]
        sport_id                            <- map["sport_id"]
        thumbnail_image                     <- map["thumbnail_image"]
        title                               <- map["title"]
        updated_at                          <- map["updated_at"]
        user_id                             <- map["user_id"]
        videourl                            <- map["videourl"]

    }
}
