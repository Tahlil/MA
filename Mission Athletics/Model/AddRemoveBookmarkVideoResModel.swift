//
//  AddRemoveBookmarkVideoResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 15/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class AddRemoveBookmarkVideoResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : AddRemoveBookmarkVideoDataModel?
    
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

class AddRemoveBookmarkVideoDataModel: Mappable {
    var id                              : Int?
    var video_id                        : String?
    var user_id                         : Int?
    var is_book                         : Bool?
    var created_at                      : String?
    var updated_at                      : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                              <- map["id"]
        video_id                        <- map["video_id"]
        user_id                         <- map["user_id"]
        is_book                         <- map["is_book"]
        created_at                      <- map["created_at"]
        updated_at                      <- map["updated_at"]
    }

}
