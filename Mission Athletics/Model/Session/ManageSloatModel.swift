//
//  ManageSloatModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 17/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class ManageSloatModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : ManageSlotDateModel?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message                     <- map["message"]
        code                        <- map["code"]
        data                        <- map["data"]
    }
}
class ManageSlotDateModel: Mappable {
    var timeSlot                    : [ManageSlotListModel]?
    var day                         : String?

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        timeSlot                     <- map["timeSlot"]
        day                          <- map["day"]

    }
}
class ManageSlotListModel: Mappable {
    var time                       : String?
    var is_available               : Int?
    var isSelected                 : Bool? = false

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        time                        <- map["time"]
        is_available                <- map["is_available"]
        isSelected                  <- map["isSelected"]

    }
}
