//
//  PushNotiResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 31/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class NotiDataModel: Mappable {
    var data                       : NotiDataTypeModel?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data                          <- map["data"]
    }
}
class NotiDataTypeModel: Mappable {
    var type                       : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type                       <- map["type"]
    }

}
