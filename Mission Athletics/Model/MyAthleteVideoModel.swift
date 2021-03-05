//
//  MyAthleteVideoModel.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 27/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class MyAthleteVideoModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : MyAthleteDataVideoModel?
    
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

class MyAthleteDataVideoModel: Mappable {
    var myVideos                       : [AthleteMyVideosArrModel]?
    
    required init(){
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        myVideos                        <- map["myVideos"]
    }
}

