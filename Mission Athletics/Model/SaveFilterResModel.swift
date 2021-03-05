//
//  SaveFilterResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 24/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SaveFilterResModel:Mappable{
    var code                       : String?
    var message                    : String?
    var data                       : SaveFilterDataModel?
    
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
class SaveFilterDataModel:Mappable{
    var athlete_id              : Int?
    var id                      : Int?
    var sport_id                : String?
    var created_at              : String?
    var updated_at              : String?
        
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        athlete_id                 <- map["athlete_id"]
        id                         <- map["id"]
        sport_id                   <- map["sport_id"]
        created_at                 <- map["created_at"]
        updated_at                 <- map["updated_at"]
    }
}
