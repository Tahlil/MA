//
//  LoginResModel.swift
//  Mission Athletics
//
//  Created by MAC  on 23/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResModel: Mappable {
    var code                       : String?
    var message                    : String?
    var data                       : UserDataModel?
    
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

class UserDataModel: NSObject, Mappable, NSCoding {
    var id                            : Int?
    var name                          : String? = ""
    var email                         : String? = ""
    var email_verified_at             : String? = ""
    var user_type                     : Int? = 0
    var mobile_no                     : String? = ""
    var birth_date                    : String? = ""
    var image                         : String? = ""
    var device_token                  : String? = ""
    var facebook_id                   : String? = ""
    var experience                    : String? = ""
    var position                      : String? = ""
    var descrip                       : String? = ""
    var deleted_at                    : String? = ""
    var created_at                    : String? = ""
    var updated_at                    : String? = ""
    var token                         : String? = ""
    
    required init?(map: Map)
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.email_verified_at = aDecoder.decodeObject(forKey: "email_verified_at") as? String
        self.user_type = aDecoder.decodeObject(forKey: "user_type") as? Int
        self.mobile_no = aDecoder.decodeObject(forKey: "mobile_no") as? String
        self.birth_date = aDecoder.decodeObject(forKey: "birth_date") as? String
        self.image = aDecoder.decodeObject(forKey: "image") as? String
        self.device_token = aDecoder.decodeObject(forKey: "device_token") as? String
        self.facebook_id = aDecoder.decodeObject(forKey: "facebook_id") as? String
        self.experience = aDecoder.decodeObject(forKey: "experience") as? String
        self.position = aDecoder.decodeObject(forKey: "position") as? String
        self.descrip = aDecoder.decodeObject(forKey: "description") as? String
        self.deleted_at = aDecoder.decodeObject(forKey: "deleted_at") as? String
        self.created_at = aDecoder.decodeObject(forKey: "created_at") as? String
        self.updated_at = aDecoder.decodeObject(forKey: "updated_at") as? String
        self.token = aDecoder.decodeObject(forKey: "token") as? String
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(email_verified_at, forKey: "email_verified_at")
        aCoder.encode(user_type, forKey: "user_type")
        aCoder.encode(mobile_no, forKey: "mobile_no")
        aCoder.encode(birth_date, forKey: "birth_date")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(device_token, forKey: "device_token")
        aCoder.encode(facebook_id, forKey: "facebook_id")
        aCoder.encode(experience, forKey: "experience")
        aCoder.encode(position, forKey: "position")
        aCoder.encode(descrip, forKey: "description")
        aCoder.encode(deleted_at, forKey: "deleted_at")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(token, forKey: "token")
    }
    
    func mapping(map: Map)
    {
        id                             <- map["id"]
        name                           <- map["name"]
        email                          <- map["email"]
        email_verified_at              <- map["email_verified_at"]
        user_type                      <- map["user_type"]
        mobile_no                      <- map["mobile_no"]
        birth_date                     <- map["birth_date"]
        image                          <- map["image"]
        device_token                   <- map["device_token"]
        facebook_id                    <- map["facebook_id"]
        experience                     <- map["experience"]
        position                       <- map["position"]
        descrip                        <- map["description"]
        deleted_at                     <- map["deleted_at"]
        created_at                     <- map["created_at"]
        updated_at                     <- map["updated_at"]
        token                          <- map["token"]
    }
}
