//
//  CommonResModel.swift
//  Mission Athletics
//
//  Created by MAC  on 24/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class CommonResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : BlankModel?
    
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
