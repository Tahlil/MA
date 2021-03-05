//
//  GetInquiryListResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 30/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class GetInquiryListResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : [InquiryListArrModel]?
    
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

class InquiryListArrModel: Mappable {
    var id                            : Int?
    var title                         : String? = ""
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
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
    }
}
