//
//  WithdrawRequestListModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 23/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class WithdrawRequestListModel : Mappable{

    var code                    : String?
    var data                    : WithdrawRequestData?
    var message                 : String?
    
    required init(){
    }
    required init?(map: Map) {
    }
    func mapping(map: Map)
    {
        code                    <- map["code"]
        data                    <- map["data"]
        message                 <- map["message"]
    }

}
class WithdrawRequestData : Mappable{

    var totalBalance            : Double?
    var totalRecords            : Int?
    var withdrawrequest         : [WithdrawrequestList]?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map)
    {
        totalBalance            <- map["total_balance"]
        totalRecords            <- map["total_records"]
        withdrawrequest         <- map["withdrawrequest"]
    }

}

class WithdrawrequestList : Mappable{

    var amount                  : Int?
    var approvedDate            : String?
    var coachId                 : Int?
    var createdAt               : String?
    var id                      : Int?
    var requestDate             : String?
    var status                  : requestStatus?
    var stripeId                : Int?
    var totalAmount             : Float?
    var updatedAt               : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map)
    {
        amount                  <- map["amount"]
        approvedDate            <- map["approved_date"]
        coachId                 <- map["coach_id"]
        createdAt               <- map["created_at"]
        id                      <- map["id"]
        requestDate             <- map["request_date"]
        status                  <- map["status"]
        stripeId                <- map["stripe_id"]
        totalAmount             <- map["total_amount"]
        updatedAt               <- map["updated_at"]
    }

}
enum requestStatus:Int {
    case Pending = 1
    case Paid = 2
    case Reject = 3
}
