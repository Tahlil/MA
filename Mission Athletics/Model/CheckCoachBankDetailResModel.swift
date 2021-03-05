//
//  CheckCoachBankDetailResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 06/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class CheckCoachBankDetailResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : CheckCoachBankDetailDataModel?
    
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

class CheckCoachBankDetailDataModel: Mappable {
    var flag                          : Int? = -1
    var bankDetail                    : CoachBankDetailsModel?
    
    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func encode(with aCoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
        flag                           <- map["flag"]
        bankDetail                     <- map["bankDetail"]
    }
}

class AddCoachBankDetailResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : CoachBankDetailsModel?
    var flag                          : Int? = -1

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message                       <- map["message"]
        code                          <- map["code"]
        data                          <- map["data"]
        flag                           <- map["flag"]

    }
}

class CoachBankDetailsModel: Mappable {
    var id                            : Int? = -1
    var user_id                       : Int? = -1
//    var bank_name                     : String? = ""
    var account_name                  : String? = ""
//    var account_no                    : String? = ""
    var card_number                   : String? = ""
//    var routing_number                : String? = ""
    var cvv                           : String? = ""
    var expiry_date                   : String? = ""
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
//        bank_name                      <- map["bank_name"]
        account_name                   <- map["account_name"]
//        account_no                     <- map["account_no"]
        card_number                    <- map["card_number"]
//        routing_number                 <- map["routing_number"]
        cvv                            <- map["cvv"]
        expiry_date                    <- map["expiry_date"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
    }
}
