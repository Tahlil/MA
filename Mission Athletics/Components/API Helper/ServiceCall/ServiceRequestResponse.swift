//
//  ServiceRequestResponse.swift
//  iOSProject
//
//  Created by Kaira NewMac on 12/12/16.
//  Copyright © 2016 Kaira NewMac. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ServiceRequestResponse: NSObject
{
    class func servicecall(isAlert:Bool = false,VC:UIViewController, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest.serviceResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter)
            if result != nil {
                ServiceCallBack(result, true)
            } else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    class func servicecallContentType(IsLoader:Bool? = true, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest.serviceResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter)
            if result != nil {
                ServiceCallBack(result, true)
            } else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    class func servicecallEncode(IsLoader:Bool? = true, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest.serviceWithEncodingResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter)
            if result != nil {
                ServiceCallBack(result, true)
            } else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    class func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func servicecallWithHeaderWithoutLoader(isAlert:Bool = false,VC:UIViewController, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest.serviceWithHeaderNoLoaderResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter)
            
            
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    // NOTE: complete this
    class func servicecallWithHeader(isAlert:Bool = false, VC:UIViewController,url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?) -> Void) {
        
        HttpRequest.serviceWithHeaderResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter)
//            print(result as Any)
            
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    // NOTE: pass custom token
    class func servicecallWithHeaderToken(isAlert:Bool = false, VC:UIViewController,url: String,Token: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?) -> Void) {
        
        HttpRequest.serviceWithTokenHeaderResponse(url: url, Token: Token, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter)
            print(result as Any)
            
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    class func servicecallStripeWithHeader(isAlert:Bool = false, VC:UIViewController,url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?) -> Void) {
        
        HttpRequest.serviceWithStripeHeaderResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter)
            print(result as Any)
            
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    class func servicecallNoHeader(isAlert:Bool = false,VC:UIViewController, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest.serviceWithoutHeaderResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            print("URL: ",url)
            print("Request: ",InputParameter)
            
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    class func servicecallNoHeaderWithoutLoader(isAlert:Bool = false,VC:UIViewController, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        HttpRequest.serviceWithoutHeaderWithoutLoaderResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            print("URL: ",url)
            print("Request: ",InputParameter)
            print("result",result as Any)
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    // Single Image Upload//
    class func servicecallImageUpload(isAlert:Bool = false , VC:UIViewController, imageDataFile: Data? = nil, url: String, HttpMethod: HTTPMethod, InputParameter: [String:String]? = nil , isHeaderNeeded: Bool = true, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest().serviceCallImageUpload(imageData: imageDataFile,url: url, HttpMethod: HttpMethod, parameter: InputParameter, isHeaderNeeded : isHeaderNeeded) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter!)
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
//            if response.http_status_code == 200 {
//                ServiceCallBack(result, true)
//            }
//            else {
//                ServiceCallBack(nil, false)
//            }
        }
    }
    
    class func servicecallVideoUpload(isAlert:Bool = false , VC:UIViewController, videoDataFile: Data? = nil, url: String, HttpMethod: HTTPMethod, InputParameter: [String:String]? = nil , isHeaderNeeded: Bool = true, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest().serviceCallVideoUpload(videoData: videoDataFile,url: url, HttpMethod: HttpMethod, parameter: InputParameter, isHeaderNeeded : isHeaderNeeded) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter!)
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    class func servicecallAthleteVideoUpload(isAlert:Bool = false , VC:UIViewController, videoDataFile: Data? = nil, url: String, HttpMethod: HTTPMethod, InputParameter: [String:String]? = nil , isHeaderNeeded: Bool = true, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest().serviceCallAthleteVideoUpload(videoData: videoDataFile,url: url, HttpMethod: HttpMethod, parameter: InputParameter, isHeaderNeeded : isHeaderNeeded) { (result) -> Void in
            
            print("URL: ",url)
            print("Request: ",InputParameter!)
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }

    // multiple Image Upload
    class func servicecallMultyImageUpload(isAlert:Bool = false , VC:UIViewController, imageDataFile: [Data]? = nil, url: String, HttpMethod: HTTPMethod, InputParameter: [String:String]? = nil, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        HttpRequest().serviceCallMultipleImageUploadHTTP(imageData: imageDataFile!, url: url, HttpMethod: .post, parameter: InputParameter, viewController: VC, ServiceCallBack: { (result, response) -> Void in
            print("URL: ",url)
            print("Request: ",InputParameter!)
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            if response.http_status_code == 200 {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        })
    }
}
