//
//  CoachAllSubscribeAthleteModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 28/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class CoachAllSubscribeAthleteModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : CoachAllSubscribeAthleteDataModel?
    
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

class CoachAllSubscribeAthleteDataModel: Mappable {
    var total_records                 : Int?
    var players                       : [CoachMyPlayersArrModel]?
    var trainers                      : [CoachMyPlayersArrModel]?

    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        players                        <- map["players"]
        total_records                  <- map["total_records"]
        trainers                       <- map["trainers"]

    }
}

