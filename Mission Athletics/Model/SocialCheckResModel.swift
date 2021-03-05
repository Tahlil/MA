//
//  SocialCheckResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 26/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SocialCheckResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : SocialCheckDataModel?
    
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

class SocialCheckDataModel: Mappable {
    var user_type                     : Int? = -1
    var email                         : String? = ""
    
    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func encode(with aCoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
        user_type                      <- map["user_type"]
        email                          <- map["email"]
    }
}
