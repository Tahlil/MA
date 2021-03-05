//
//  UserModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 17/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class NewChatUsersResModel: Mappable {
    
    lazy var user_id                            : Int? = 0
    lazy var name                               : String? = ""
    lazy var profile_pic                        : String? = ""
    lazy var user_type                          : String? = ""
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        user_id                                 <- map["user_id"]
        name                                    <- map["name"]
        profile_pic                             <- map["profile_pic"]
        user_type                               <- map["user_type"]
    }
}

class MyChatListReqModel: Mappable {
    
    lazy var limit                              : Int? = 0
    lazy var userid                             : Int? = 0
    lazy var page                               : Int? = 0
    lazy var device_id                          : String? = ""
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        limit                                   <- map["limit"]
        userid                                  <- map["userid"]
        page                                    <- map["page"]
        device_id                               <- map["device_id"]
    }
}
class MyChatUsersListResModel: Mappable {
    
    lazy var id                                 : Int? = 0
    lazy var last_message                       : String? = ""
    lazy var last_message_by                    : String? = ""
    lazy var last_message_at                    : String? = ""
    lazy var created_at                         : String? = ""
    lazy var receiver_id                        : Int? = 0
    lazy var receiver_name                      : String? = ""
    lazy var receiver_email                     : String? = ""
    lazy var profile_pic                        : String? = ""
    lazy var is_online                          : Int? = 0
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                                      <- map["id"]
        last_message                            <- map["last_message"]
        last_message_by                         <- map["last_message_by"]
        last_message_at                         <- map["last_message_at"]
        created_at                              <- map["created_at"]
        receiver_id                             <- map["receiver"]
        receiver_name                           <- map["receiver_name"]
        receiver_email                          <- map["receiver_email"]
        profile_pic                             <- map["profile_pic"]
        is_online                               <- map["is_online"]
    }
}
class ChatDetailReqModel: Mappable {
    
    lazy var limit                              : Int? = 0
    lazy var chat_id                            : Int? = 0
    lazy var page                               : Int? = 0
    lazy var userid                             : Int? = 0
    lazy var device_id                          : String? = ""
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        limit                                   <- map["limit"]
        chat_id                                 <- map["chat_id"]
        userid                                  <- map["userid"]
        page                                    <- map["page"]
        device_id                               <- map["device_id"]
    }
}
class ChatImageVideoDetailReqModel: Mappable {
    
    var chat_id                                 : Int? = 0
    var sender_id                               : Int? = 0
    var receiver_id                             : Int? = 0
    var type                                    : String? = ""
    var format                                  : String? = ""
    var reader                                  : String? = ""
    var filename                                : String? = ""
    var thumbnail                               : String? = ""

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        chat_id                                 <- map["chat_id"]
        sender_id                               <- map["sender_id"]
        receiver_id                             <- map["receiver_id"]
        type                                    <- map["type"]
        format                                  <- map["format"]
        reader                                  <- map["reader"]
        filename                                <- map["filename"]
        thumbnail                               <- map["thumbnail"]
    }
}
