
import Foundation
import ObjectMapper

class mySubscriptionModel : Mappable{

    var code                    : String?
    var data                    : mySubscriptionDataModel?
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

class mySubscriptionDataModel : Mappable{

    var mysubscriptions         : [Mysubscription]?
    var totalrecords            : Int?

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        mysubscriptions         <- map["mysubscriptions"]
        totalrecords            <- map["totalrecords"]
    }

}
    
class Mysubscription : Mappable{

    var amount                  : String?
    var athleteId               : Int?
    var athleteImage            : String?
    var athleteName             : String?
    var bankDetailId            : Int?
    var bookingDate             : String?
    var bookingStatus           : Int?
    var bookingTime             : String?
    var coachId                 : Int?
    var coachImage              : String?
    var coachName               : String?
    var coachPaymentStatus      : String?
    var coachPendingAmount      : String?
    var coachTotalPayAmount     : String?
    var dueDate                 : String?
    var id                      : Int?
    var paymentStatus           : String?
    var sessionStatus           : String?
    var sportId                 : Int?
    var sportname               : String?
    var stripeId                : String?
    var subscriptionId          : Int?
    var subscriptionType        : String?
    var tax                     : String?
    var total                   : String?

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        amount                  <- map["amount"]
        athleteId               <- map["athlete_id"]
        athleteImage            <- map["athlete_image"]
        athleteName             <- map["athlete_name"]
        bankDetailId            <- map["bank_detail_id"]
        bookingDate             <- map["booking_date"]
        bookingStatus           <- map["booking_status"]
        bookingTime             <- map["booking_time"]
        coachId                 <- map["coach_id"]
        coachImage              <- map["coach_image"]
        coachName               <- map["coach_name"]
        coachPaymentStatus      <- map["coach_payment_status"]
        coachPendingAmount      <- map["coach_pending_amount"]
        coachTotalPayAmount     <- map["coach_total_pay_amount"]
        dueDate                 <- map["due_date"]
        id                      <- map["id"]
        paymentStatus           <- map["payment_status"]
        sessionStatus           <- map["session_status"]
        sportId                 <- map["sport_id"]
        sportname               <- map["sportname"]
        stripeId                <- map["stripe_id"]
        subscriptionId          <- map["subscription_id"]
        subscriptionType        <- map["subscription_type"]
        tax                     <- map["tax"]
        total                   <- map["total"]
    }

}
