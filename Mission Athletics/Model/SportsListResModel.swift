//
//  SportsListResModel.swift
//  Mission Athletics
//
//  Created by MAC  on 23/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SportsListResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : [SportsListArrModel]?
    
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

class SportsListArrModel: Mappable {
    var id                            : Int?
    var title                         : String? = ""
    var descrip                       : String? = ""
    var deleted_at                    : String? = ""
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
        title                          <- map["title"]
        descrip                        <- map["description"]
        deleted_at                     <- map["deleted_at"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
    }
}
