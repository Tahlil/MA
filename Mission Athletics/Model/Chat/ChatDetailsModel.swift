//
//  ChatDetailsModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 17/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class ChatDetailsModel:Mappable{
    var created_at              :  String? = ""
    var date                    : String? = ""
    var id                      :  Int? = 0
    var last_message            :  String? = ""
    var last_message_at         :  String? = ""
    var last_message_by         :  Int? = 0
    var message_per_page        :  Int? = 0
    var messages                :  [MessageModel]?
    var next_page               :  Int? = 0

    init?() {
        
    }
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        created_at              <- map["created_at"]
        date                    <- map["date"]
        id                      <- map["id"]
        last_message            <- map["last_message"]
        last_message_at         <- map["last_message_at"]
        last_message_by         <- map["last_message_by"]
        message_per_page        <- map["message_per_page"]
        messages                <- map["messages"]
        next_page               <- map["next_page"]

    }
}

class MessageModel:Mappable{
    var chat_id                 :  String? = ""
    var created_at              : String? = ""
    var id                      :  String? = ""
    var is_read                 :  String? = ""
    var message                 :  String? = ""
    var receiver_id             :  String? = ""
    var sender_id               :  Any?
    var attachment_path         :  String? = ""
    var attachment_type         :  messageType?
    var thumbnail               :  String? = ""

    init?() {
        
    }
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        attachment_path         <- map["attachment_path"]
        attachment_type         <- map["attachment_type"]
        thumbnail               <- map["thumbnail"]
        chat_id                 <- map["chat_id"]
        created_at              <- map["created_at"]
        id                      <- map["id"]
        is_read                 <- map["is_read"]
        message                 <- map["message"]
        receiver_id             <- map["receiver_id"]
        sender_id               <- map["sender_id"]

    }
}

enum messageType:String{
    case Video
    case Image
    case File
    case Message
}

class SendMessageReqModel: Mappable {
    
    var message                  : String? = ""
    var sender_id                : Int? = 0
    var receiver_id              : Int? = 0
    var chat_id                  : Int? = 0
    var attachment_type          : String? = ""
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message                   <- map["message"]
        sender_id                 <- map["sender_id"]
        receiver_id               <- map["receiver_id"]
        chat_id                   <- map["chat_id"]
        attachment_type           <- map["attachment_type"]

    }
}

class ReceiveMessageModel: Mappable {
   
    var receiver_id               : Int = 0
    var lastMessage               : String? = ""
    var message                   : String = ""
    var code                      : Int = 0

    var ReceiverLastMessage       : ReceiverLastMessageModel?
    var ReceiverMessageSender     : ReceiverMessageSenderModel?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        receiver_id                 <- map["receiver_id"]
        lastMessage                 <- map["lastMessage"]
        message                     <- map["message"]
        code                        <- map["code"]
        ReceiverLastMessage         <- map["lmessage"]
        ReceiverMessageSender       <- map["sender"]

    }
}

class ReceiverLastMessageModel: Mappable {
   
    var chat_id                     : Int = 0
    var receiver_id                 : Int = 0
    var sender_id                   :Int = 0
    var message                     :String = ""
    var is_read                     :Int = 0
    var created_at                  :String = ""
    var msg_at                      :String = ""
    var attachment_path             :String = ""
    var attachment_type             :String = ""
    var thumbnail                   :String = ""

    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        attachment_type             <- map["attachment_type"]
        attachment_path             <- map["attachment_path"]
        thumbnail                   <- map["thumbnail"]
        chat_id                     <- map["chat_id"]
        receiver_id                 <- map["receiver_id"]
        sender_id                   <- map["sender_id"]
        message                     <- map["message"]
        is_read                     <- map["is_read"]
        created_at                  <- map["created_at"]
        msg_at                      <- map["msg_at"]
    }
}
class ReceiverMessageSenderModel: Mappable {

    var id                          : String = ""
    var name                        : String = ""
    var email                       : String = ""
    var user_type                   : Int = 0
    var is_online                   : Int = 0
    var profile_pic                 : String = ""

    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id                          <- map["id"]
        name                        <- map["name"]
        email                       <- map["email"]
        user_type                   <- map["user_type"]
        is_online                   <- map["is_online"]
        profile_pic                 <- map["profile_pic"]
    }
}
