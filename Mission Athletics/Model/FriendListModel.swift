//
//  FriendListModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 09/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class FriendListModel:Mappable{
    var code                       : String?
    var message                    : String?
    var data                       : [FriendListDataModel] = []
    
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
class FriendListDataModel:Mappable{
    var id                          : Int?
    var name                        : String?
    var email                       : String?
    var chat_id                     : Int?
    var notification_id             : Int?
    var email_verified_at           : String?
    var user_type                   : Int?
    var mobile_no                   : String?
    var birth_date                  : String?
    var image                       : String?
    var userimage                   : String?
    var profile_pic                 : String?
    var device_token                : String?
    var facebook_id                 : String?
    var experience                  : String?
    var position                    : String?
    var description                 : String?
    var deleted_at                  : String?
    var created_at                  : String?
    var updated_at                  : String?
    var user_status                 : Int?
    var request_status              : Int?
    var isChatCreated               : Int?
    var is_online                   : Int?

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                      <- map["id"]
        name                    <- map["name"]
        email                   <- map["email"]
        chat_id                 <- map["chat_id"]
        notification_id         <- map["notification_id"]
        email_verified_at       <- map["email_verified_at"]
        user_type               <- map["user_type"]
        mobile_no               <- map["mobile_no"]
        birth_date              <- map["birth_date"]
        image                   <- map["image"]
        userimage               <- map["userimage"]
        profile_pic             <- map["profile_pic"]
        device_token            <- map["device_token"]
        facebook_id             <- map["facebook_id"]
        experience              <- map["experience"]
        position                <- map["position"]
        description             <- map["description"]
        deleted_at              <- map["deleted_at"]
        created_at              <- map["created_at"]
        updated_at              <- map["updated_at"]
        user_status             <- map["user_status"]
        request_status          <- map["request_status"]
        isChatCreated           <- map["isChatCreated"]
        is_online               <- map["is_online"]
    }
}
