//
//  GetSettingsResModel.swift
//  Mission Athletics
//
//  Created by MAC  on 24/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class GetSettingsResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : GetSettingsDataModel?
    
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

class GetSettingsDataModel: Mappable {
    var id                            : Int?
    var user_id                       : String? = ""
    var new_messages                  : Bool? = false
    var new_followers                 : Bool? = false
    var followed_trainer_video        : Bool? = false
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
        user_id                        <- map["user_id"]
        new_messages                   <- map["new_messages"]
        new_followers                  <- map["new_followers"]
        followed_trainer_video         <- map["followed_trainer_video"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
    }
}
