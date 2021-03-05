//
//  TermsPrivacyResModel.swift
//  Mission Athletics
//
//  Created by Maulik Raiyani on 27/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class TermsPrivacyResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : TermsPrivacyDataModel?
    
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

class TermsPrivacyDataModel: Mappable {
    var Terms                         : TermsPrivacyDetailsDataModel?
    var Privacy                       : TermsPrivacyDetailsDataModel?
    
    required init?(map: Map)
    {
    }
    required init?(coder aDecoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
        Terms                          <- map["Terms"]
        Privacy                        <- map["Privacy"]
    }
}

class TermsPrivacyDetailsDataModel: Mappable {
    var id                            : Int?
    var title                         : String? = ""
    var body                          : String? = ""
    var meta_description              : String? = ""
    var meta_keyword                  : String? = ""
    var status                        : Int?
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    
    required init?(map: Map)
    {
    }
    required init?(coder aDecoder: NSCoder) {
    }
    
    func mapping(map: Map)
    {
        id                             <- map["id"]
        title                          <- map["title"]
        body                           <- map["body"]
        meta_description               <- map["meta_description"]
        meta_keyword                   <- map["meta_keyword"]
        status                         <- map["status"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
    }
}

