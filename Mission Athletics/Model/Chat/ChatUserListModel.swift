//
//  ChatUserListModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 17/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class ChatUserListModel:Mappable{
    
    var Code                    :  Int? = 0
    var Data                    : [ChatUserDataModel]? = []
    var next_page               : Int? = 0
    var page                    :  Int? = 0
    var user_per_page           :  Int? = 0

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        Code                    <- map["code"]
        Data                    <- map["data"]
        next_page               <- map["next_page"]
        page                    <- map["page"]
        user_per_page           <- map["user_per_page"]
    }
}
class ChatUserDataModel:Mappable{
    
    var count                   :  String? = ""
    var created_at              :  String? = ""
    var id                      :  Int? = 0
    var is_online               : String? = ""//Int? = 0//Bool = false
    var last_message            :  String? = ""
    var last_message_at         :  String? = ""
    var last_message_by         : String? = ""
    var profile_pic             : String? = ""
    var receiver                :  Int? = 0
    var receiver_email          :  String? = ""
    var receiver_name           :  String? = ""

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        count                   <- map["count"]
        created_at              <- map["created_at"]
        id                      <- map["id"]
        is_online               <- map["is_online"]
        last_message            <- map["last_message"]
        last_message_at         <- map["last_message_at"]
        last_message_by         <- map["last_message_by"]
        profile_pic             <- map["profile_pic"]
        receiver                <- map["receiver"]
        receiver_email          <- map["receiver_email"]
        receiver_name           <- map["receiver_name"]

    }
}


class TypingModel:Mappable{
    
    var sender_id               :  Int? = 0
    
    init?() {
        
    }
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        sender_id               <- map["sender_id"]
    }
}
