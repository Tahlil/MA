//
//  TokenGenerateModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 28/01/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class TokenGenerateModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : TokenModel?
    
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

class TokenModel: Mappable {
    var token                       : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token                       <- map["token"]
    }
}
