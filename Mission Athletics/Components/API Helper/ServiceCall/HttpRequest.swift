//
//  HttpRequest.swift
//  iOSProject
//
//  Created by Kaira NewMac on 12/9/16.
//  Copyright © 2016 Kaira NewMac. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import ObjectMapper

class HttpRequest: NSObject  {
    
    class func serviceResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void?) {
        
        //let tempheader = ["Content-Type":"application/json"]
        
        request(url, method:HttpMethod,parameters:InputParameter,headers:nil).responseJSON { response in
            
            if(response.result.isSuccess) {
                
                let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                
                let jsonDictionary =  JSONData().convertToDictionary(text: datastring!)! as NSDictionary
                
                print("Response : ", jsonDictionary as Any)
                ServiceCallBack(datastring!)
            } else {
                ServiceCallBack(nil)
            }
        }
    }
    
    class func serviceWithEncodingResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void?) {
        
        request(url, method:HttpMethod, parameters:InputParameter,
                encoding: JSONEncoding.default).responseJSON { response in
                    if(response.result.isSuccess){
                        let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                        let jsonDictionary =  JSONData().convertToDictionary(text: datastring!)! as NSDictionary
                        print("Response : ", jsonDictionary as Any)
                        ServiceCallBack(datastring)
                    }else{
                        ServiceCallBack(nil)
                    }
        }
    }
    
    func serviceCallMultipleImageUploadHTTP(imageData: [Data],url: String,HttpMethod: HTTPMethod , parameter: [String:String]? = nil ,viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ result: String?, _ response: ServiceResponseMessage)-> Void?) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for i in 0..<(imageData.count){
                multipartFormData.append(imageData[i] as Data, withName: "images[\(i)]", fileName: "uploaded_file\(RandomNumber.randomNumberWithLength(5)).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameter! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
            
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    
                })
                upload.responseJSON { response in
                    
                    if(response.result.isSuccess){
                        let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                        let serviceresponse = Mapper<ServiceResponseMessage>().map(JSONString: datastring!)
                        ServiceCallBack(datastring, serviceresponse!)
                    }else{
                        let serviceReponse = ServiceResponseMessage()
                        serviceReponse?.status = (response.result.error?.localizedDescription)! as String
                        ServiceCallBack(nil, serviceReponse!)
                    }
                }
            case .failure(let encodingError):
                
                print(encodingError)
            }
        }
    }
    
    func serviceCallImageUpload(imageData: Data? = nil ,url: String,HttpMethod: HTTPMethod , parameter: [String:String]? = nil, isHeaderNeeded: Bool = true , ServiceCallBack: @escaping (_ result: String?)-> Void?)
    {
        var header:[String:String] = [:]
        if getUserInfo() != nil {
            if let token = getUserInfo()?.token {
                header["Authorization"] = "Bearer \(token)"
            }
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var fileStr = ""
            fileStr = "image"
            
            if imageData != nil {
                multipartFormData.append(imageData! as Data, withName: fileStr, fileName: "uploaded_file\(RandomNumber.randomNumberWithLength(5)).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameter! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, to:url,  headers: isHeaderNeeded == false ? nil : header)//headers:["Authorization" : ""])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    
                    if(response.result.isSuccess){
                        let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                        //let serviceresponse = Mapper<ServiceResponseMessage>().map(JSONString: datastring!)
                        ServiceCallBack(datastring)//, serviceresponse!)
                    }else{
                        
                        let serviceReponse = ServiceResponseMessage()
                        //HttpParameter.CurrentHttpCode = HttpCode.Error_503
                        serviceReponse?.status = (response.result.error?.localizedDescription)! as String
                        ServiceCallBack(nil)//, serviceReponse!)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func serviceCallVideoUpload(videoData: Data? = nil ,url: String,HttpMethod: HTTPMethod , parameter: [String:String]? = nil, isHeaderNeeded: Bool = true , ServiceCallBack: @escaping (_ result: String?)-> Void?)
    {
        var header:[String:String] = [:]
        if getUserInfo() != nil {
            if let token = getUserInfo()?.token {
                header["Authorization"] = "Bearer \(token)"
            }
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var fileStr = ""
            fileStr = "videourl"
            
            if videoData != nil {
                multipartFormData.append(videoData! as Data, withName: fileStr, fileName: "uploaded_file\(RandomNumber.randomNumberWithLength(5)).mp4", mimeType: "video/mp4")
            }
            for (key, value) in parameter! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, to:url,  headers: isHeaderNeeded == false ? nil : header)//headers:["Authorization" : ""])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    
                    if(response.result.isSuccess){
                        let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                      //  let serviceresponse = Mapper<ServiceResponseMessage>().map(JSONString: datastring!)
                        ServiceCallBack(datastring)//, serviceresponse!)
                    }else{
                        
                        let serviceReponse = ServiceResponseMessage()
                        //HttpParameter.CurrentHttpCode = HttpCode.Error_503
                        serviceReponse?.status = (response.result.error?.localizedDescription)! as String
                        ServiceCallBack(nil)//, serviceReponse!)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    func serviceCallAthleteVideoUpload(videoData: Data? = nil ,url: String,HttpMethod: HTTPMethod , parameter: [String:String]? = nil, isHeaderNeeded: Bool = true , ServiceCallBack: @escaping (_ result: String?)-> Void?)
    {
        var header:[String:String] = [:]
        if getUserInfo() != nil {
            if let token = getUserInfo()?.token {
                header["Authorization"] = "Bearer \(token)"
            }
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var fileStr = ""
            fileStr = "athlete_video"
            
            if videoData != nil {
                multipartFormData.append(videoData! as Data, withName: fileStr, fileName: "uploaded_file\(RandomNumber.randomNumberWithLength(5)).mp4", mimeType: "video/mp4")
            }
            for (key, value) in parameter! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, to:url,  headers: isHeaderNeeded == false ? nil : header)//headers:["Authorization" : ""])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    
                    if(response.result.isSuccess){
                        let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                        //let serviceresponse = Mapper<ServiceResponseMessage>().map(JSONString: datastring!)
                        ServiceCallBack(datastring)//, serviceresponse!)
                    }else{
                        
                        let serviceReponse = ServiceResponseMessage()
                        //HttpParameter.CurrentHttpCode = HttpCode.Error_503
                        serviceReponse?.status = (response.result.error?.localizedDescription)! as String
                        ServiceCallBack(nil)//, serviceReponse!)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }

    class func serviceWithHeaderResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void?) {
        
        var header:[String:String] = [:]
        if getUserInfo() != nil {
            if let token = getUserInfo()?.token {
                header["Authorization"] = "Bearer \(token)"
            }
        }
        request(url, method:HttpMethod,parameters:InputParameter, headers:header).responseJSON { response in
            
//            print("Rersponse\(response)")
//            print("Rersponse\(String(describing: response.value))")
            
            if(response.result.isSuccess){
                let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                let jsonDictionary =  JSONData().convertToDictionary(text: datastring!)! as NSDictionary
//                print("Response : ", jsonDictionary as Any)
                ServiceCallBack(datastring)
            }else{
                ServiceCallBack(nil)
            }
        }
    }
    class func serviceWithTokenHeaderResponse(url: String,Token: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void?) {
        
        var header:[String:String] = [:]
                
        header["Authorization"] = "Bearer \(Token)"
        
        request(url, method:HttpMethod,parameters:InputParameter, headers:header).responseJSON { response in
            
            print("Rersponse\(response)")
            print("Rersponse\(String(describing: response.value))")
            
            if(response.result.isSuccess){
                let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                let jsonDictionary =  JSONData().convertToDictionary(text: datastring!)! as NSDictionary
                print("Response : ", jsonDictionary as Any)
                ServiceCallBack(datastring)
            }else{
                ServiceCallBack(nil)
            }
        }
    }
    class func serviceWithStripeHeaderResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void?) {
        
        var header:[String:String] = [:]
        header["Authorization"] = "Bearer pk_test_opxYOaGWgEb5zr154wy5o5iI00doBmyeL5"
            
        request(url, method:HttpMethod,parameters:InputParameter, headers:header).responseJSON { response in
            
            print("Rersponse\(response)")
            print("Rersponse\(String(describing: response.value))")
            
            if(response.result.isSuccess){
                let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                let jsonDictionary =  JSONData().convertToDictionary(text: datastring!)! as NSDictionary
                print("Response : ", jsonDictionary as Any)
                ServiceCallBack(datastring)
            }else{
                ServiceCallBack(nil)
            }
        }
    }
    
    class func serviceWithHeaderNoLoaderResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void? ) {
        
        request(url, method:HttpMethod,parameters:InputParameter, headers:["Content-Type" : "application/x-www-form-urlencoded"]).responseJSON { response in
            print("\(String(describing: response.data?.toString))")
            
            if(response.result.isSuccess){
                let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                let jsonDictionary =  JSONData().convertToDictionary(text: datastring!)! as NSDictionary
                print("Response : ", jsonDictionary as Any)
                ServiceCallBack(datastring)
            }else{
                ServiceCallBack(nil)
            }
        }
    }
    
    class func serviceWithoutHeaderResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void?) {
        
        request(url, method:HttpMethod,parameters:InputParameter,headers: nil).responseJSON { response in
            
            if(response.result.isSuccess){
                let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                let jsonDictionary =  JSONData().convertToDictionary(text: datastring!)! as NSDictionary
                print("Response : ", jsonDictionary as Any)
                ServiceCallBack(datastring)
            }else{
                ServiceCallBack(nil)
            }
        }
    }
    
    class func serviceWithoutHeaderWithoutLoaderResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void?) {
        
        request(url, method:HttpMethod,parameters:InputParameter,headers: nil).responseJSON { response in
            
            if(response.result.isSuccess){
                let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                let jsonDictionary =  JSONData().convertToDictionary(text: datastring!)! as NSDictionary
                print("Response : ", jsonDictionary as Any)
                ServiceCallBack(datastring)
            }else{
                
                ServiceCallBack(nil)
            }
        }
    }
    
}

class JSONData {
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

class ServiceResponseMessage: Mappable, CustomStringConvertible {
    
    lazy var http_status_code :  Int? = 0
    lazy var status: String? = ""
    
    init?() {
        
    }
    required init?(map: Map) {}
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    // Mappable
    func mapping(map: Map) {
        http_status_code          <- map["http_status_code"]
        status                    <- map["status"]
    }
}

class BlankModel: Mappable {
    
    required init(){
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}



