//
//  ComparisionRequestModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 23, 2019

import Foundation
import ObjectMapper

class ComparisionRequestModel : Mappable{

    var code                        : String?
    var data                        : ComparisionRequestDataModel?
    var message                     : String?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map)
    {
        code                        <- map["code"]
        data                        <- map["data"]
        message                     <- map["message"]
    }

}

class ComparisionRequestDataModel : Mappable{

    var free_session                : Int?
    var free_videos                 : Int?
    var total_videos                : Int?

    var videodata : [VideoDataComparisionModel]?
    
    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map)
    {
        free_session                <- map["free_session"]
        free_videos                 <- map["free_videos"]
        total_videos                <- map["total_videos"]
        videodata                   <- map["videodata"]
    }

}
class VideoDataComparisionModel : Mappable{

    var athleteId                   : Int?
    var athleteImage                : String?
    var athleteName                 : String?
    var athleteVideoDescription     : String?
    var athleteVideoDuration        : String?
    var athleteVideoThumbnailImage  : String?
    var athleteVideoTitle           : String?
    var athleteVideourl             : String?
    var coachId                     : Int?
    var coachImage                  : String?
    var coachName                   : String?
    var coachVideoDescription       : String?
    var coachVideoDuration          : String?
    var coachVideoThumbnailImage    : String?
    var coachVideoTitle             : String?
    var coachVideourl               : String?
    var date                        : String?
    var id                          : Int?
    var sportId                     : Int?
    var sportName                   : String?
    var status                      : Int?
    var title                       : String?
    var report                       : String?

    required init(){
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map)
    {
        athleteId                   <- map["athlete_id"]
        athleteImage                <- map["athlete_image"]
        athleteName                 <- map["athlete_name"]
        athleteVideoDescription     <- map["athlete_video_description"]
        athleteVideoDuration        <- map["athlete_video_duration"]
        athleteVideoThumbnailImage  <- map["athlete_video_thumbnail_image"]
        athleteVideoTitle           <- map["athlete_video_title"]
        athleteVideourl             <- map["athlete_videourl"]
        coachId                     <- map["coach_id"]
        coachImage                  <- map["coach_image"]
        coachName                   <- map["coach_name"]
        coachVideoDescription       <- map["coach_video_description"]
        coachVideoDuration          <- map["coach_video_duration"]
        coachVideoThumbnailImage    <- map["coach_video_thumbnail_image"]
        coachVideoTitle             <- map["coach_video_title"]
        coachVideourl               <- map["coach_videourl"]
        date                        <- map["date"]
        id                          <- map["id"]
        sportId                     <- map["sport_id"]
        sportName                   <- map["sport_name"]
        status                      <- map["status"]
        title                       <- map["title"]
        report                      <- map["report"]
    }

}
