//
//  GetUnreadNotifyCountResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 11/04/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class GetUnreadNotifyCountResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : UnreadNotifyCountDataModel?
    
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

class UnreadNotifyCountDataModel: Mappable {
    var unReadCount                 : Int?

    required init(){
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        unReadCount                         <- map["unReadCount"]
    }
}
