//
//  AthleteAllBookmarkVideosArrModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 21/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class AthleteAllBookmarkVideosArrModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : AthleteGetBookmarkDataModel?
    
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

class AthleteGetBookmarkDataModel: Mappable {
    var free_session                  : Int?
    var free_videos                   : Int?
    var total_videos                  : Int?
    var bookmarkVideo                 : [ViewVideosArrModel]?
    
    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }

    func mapping(map: Map)
    {
        free_session                    <- map["free_session"]
        free_videos                     <- map["free_videos"]
        total_videos                    <- map["total_videos"]
        bookmarkVideo                   <- map["videodata"]
    }
}
