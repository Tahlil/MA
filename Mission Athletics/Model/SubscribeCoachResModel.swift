//
//  SubscribeCoachResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 20/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SubscribeCoachResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : SubscribeCoachDataModel?
    
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

class SubscribeCoachDataModel: Mappable {
    var id                            : Int? = -1
    var coach_id                      : String? = ""
    var athlete_id                    : String? = ""
    var subscription_id               : String? = ""
    var amount                        : String? = ""
    var tax                           : String? = ""
    var total                         : String? = ""
    var booking_date                  : String? = ""
    var booking_time                  : String? = ""
    var validity                      : String? = ""
    var booking_status                : String? = ""
    var bank_detail_id                : String? = ""
    var stripe_id                     : String? = ""
    var due_date                      : String? = ""
    var coach_total_pay_amount        : Int? = -1
    var coach_pending_amount          : Int? = -1
    var coach_payment_status          : Int? = -1
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    
    required init?(map: Map) {
    }
    required init?(coder aDecoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
        id                             <- map["id"]
        coach_id                       <- map["coach_id"]
        athlete_id                     <- map["athlete_id"]
        subscription_id                <- map["subscription_id"]
        amount                         <- map["amount"]
        tax                            <- map["tax"]
        total                          <- map["total"]
        booking_date                   <- map["booking_date"]
        booking_time                   <- map["booking_time"]
        validity                       <- map["validity"]
        booking_status                 <- map["booking_status"]
        bank_detail_id                 <- map["bank_detail_id"]
        stripe_id                      <- map["stripe_id"]
        due_date                       <- map["due_date"]
        coach_total_pay_amount         <- map["coach_total_pay_amount"]
        coach_pending_amount           <- map["coach_pending_amount"]
        coach_payment_status           <- map["coach_payment_status"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
    }
}
