//
//  ReviewModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 6, 2019

import Foundation
import ObjectMapper

class ReviewModel : Mappable{

    var code                : String?
    var data                : [ReviewDataModel]?
    var message             : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        code                <- map["code"]
        data                <- map["data"]
        message             <- map["message"]
    }

}
    
class ReviewDataModel : Mappable{

    var athleteId           : Int?
    var athleteImage        : String?
    var athleteName         : String?
    var coachId             : Int?
    var datetime            : String?
    var id                  : Int?
    var rate                : String?
    var review              : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        athleteId           <- map["athlete_id"]
        athleteImage        <- map["athlete_image"]
        athleteName         <- map["athlete_name"]
        coachId             <- map["coach_id"]
        datetime            <- map["datetime"]
        id                  <- map["id"]
        rate                <- map["rate"]
        review              <- map["review"]
    }

}
