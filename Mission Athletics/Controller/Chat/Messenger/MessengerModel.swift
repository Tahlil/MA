//
//  MessengerModel.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 18/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import Foundation
import ObjectMapper

class MessagesModel: Mappable {
    var statusCode          : String?
    var chatHistory         : [MessagesListModel] = []
    var message             : String?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        statusCode          <- map["statusCode"]
        chatHistory         <- map["chatHistory"]
        message             <- map["message"]

    }
}
class MessagesListModel: Mappable {
    var firstName           : String?
    var lastName            : String?
    var phoneNumber         : String?
    var id                  : String?
    var senderID            : String?
    var receiverID          : String?
    var messageText         : String?
    var attachedDocument    : String?
    var messageStatus       : String?
    var postedTime          : String?
    var profilePicture      : String?
    var messegeType         : String?

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        firstName           <- map["firstName"]
        lastName            <- map["lastName"]
        phoneNumber         <- map["phoneNumber"]
        id                  <- map["id"]
        senderID            <- map["senderID"]
        receiverID          <- map["receiverID"]
        messageText         <- map["messageText"]
        attachedDocument    <- map["attachedDocument"]
        messageStatus       <- map["messageStatus"]
        postedTime          <- map["postedTime"]
        profilePicture      <- map["profilePicture"]
        messegeType         <- map["messegeType"]

    }
}
