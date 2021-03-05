//
//  NotificationModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 10/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class NotificationModel:Mappable{
    var code                       : String?
    var message                    : String?
    var data                       : [NotificationDataModel] = []
    
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
class NotificationDataModel:Mappable{
    var day_time                : String?
    var data                    : [NotificationTodayDataModel] = []
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        day_time                   <- map["day_time"]
        data                       <- map["data"]
    }
}
class NotificationTodayDataModel:Mappable{
    var id                          : Int?
    var chat_id                     : Int?
    var sender_id                   : Int?
    var receiver_id                 : Int?
    var message_id                  : Int?
    var is_seen                     : Int?
    var date                        : String?
    var message                     : String?
    var name                        : String?
    var image                       : String?
    var userimage                   : String?
    var created_at                  : String?
    var updated_at                  : String?
    var booking_date                : String?
    var booking_time                : String?

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        chat_id                     <- map["chat_id"]
        sender_id                   <- map["sender_id"]
        receiver_id                 <- map["receiver_id"]
        message_id                  <- map["message_id"]
        is_seen                     <- map["is_seen"]
        message                     <- map["message"]
        name                        <- map["name"]
        date                        <- map["date"]
        image                       <- map["image"]
        userimage                   <- map["userimage"]
        created_at                  <- map["created_at"]
        updated_at                  <- map["updated_at"]
        booking_date                <- map["booking_date"]
        booking_time                <- map["booking_time"]

    }
}
