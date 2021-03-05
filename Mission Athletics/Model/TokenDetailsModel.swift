//
//  TokenDetailsModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 21/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class TokenDetailsModel: Mappable {
    var id                       : String?
    var object                    : String?
    var card                       : TokenDetailsDataModel?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                       <- map["id"]
        object                          <- map["object"]
        card                          <- map["card"]
    }
}
class TokenDetailsDataModel: Mappable {
    var id                       : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                       <- map["id"]
    }
}
class TokenDetailsErorModel: Mappable {
    var error                       : TokenDetailsErorDataModel?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        error                       <- map["error"]
    }
}
class TokenDetailsErorDataModel: Mappable {
    var code                       : String?
    var message                       : String?

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code                       <- map["code"]
        message                    <- map["message"]

    }
}
