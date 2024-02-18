//
//  HTTPManager
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Alamofire
import Gloss
import SwiftKeychainWrapper

enum HTTPError: Error {
    case glossSerializationError
}

// for raw parameter-------- JSONEncoding.default
//  else  URLEncoding.default ...............*************
public func Request(
    _ method: HTTPMethod,
    _ urlString: String,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = JSONEncoding.default,
    headers: [String: String]? = nil)
    -> DataRequest? {
        
        guard let fullUrl = URL(string: urlString, relativeTo: API_ENDPOINT.BaseURL) else {
            return nil
        }
        
        var header: HTTPHeaders = [:]
        
//        if let currentToken = AppSessionManager.shared.authToken{
//            header["Authorization"] = "Bearer \(currentToken)"
//        }
        header = ["Content-Type": "application/json",
                   "Accept": "application/json"]
        
        
        print("fullUrl:\(fullUrl.absoluteString)")
        print("parameters  ",parameters!)
        
        return AF.request( fullUrl, method: method, parameters: parameters , encoding: encoding, headers: header)
}

public func RequestForGet(
    _ method: HTTPMethod,
    _ urlString: String,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> DataRequest? {
        
        guard let fullUrl = URL(string: urlString, relativeTo: API_ENDPOINT.BaseURL) else {
            return nil
        }
        
        var header: HTTPHeaders = [:]
        
        //        if let currentToken = AppSessionManager.shared.authToken{
        //            header["Authorization"] = "Bearer \(currentToken)"
        //        }
        header = ["Content-Type": "application/json",
                  "Accept": "application/json"]
        
        
        print("fullUrl:\(fullUrl.absoluteString)")
        print("parameters  ",parameters!)
        
        return AF.request( fullUrl, method: method, parameters: parameters , encoding: encoding, headers: header)
}


public func RequestWithAuthorization(
    
    _ method: HTTPMethod,
    _ urlString: String,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> DataRequest? {
        
        guard let fullUrl = URL(string: urlString, relativeTo: API_ENDPOINT.BaseURL) else {
            return nil
        }
        
        
        
        
        var header: HTTPHeaders = [:]
        
        if let authToken = KeychainWrapper.standard.string(forKey: "accessToken"){
            print("authToken",authToken)
            header["Authorization"] = "PULSE \(authToken)"
        }
  //      header = ["Content-Type": "application/json"]

        
        print("fullUrl:\(fullUrl.absoluteString)")
//        print(parameters!)
        
        return AF.request( fullUrl, method: method, parameters: parameters , encoding: encoding, headers: header)
}

public func RequestWithAuthorizationForRawParameter(
    
    _ method: HTTPMethod,
    _ urlString: String,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = JSONEncoding.default,
    headers: [String: String]? = nil)
    -> DataRequest? {
        
        guard let fullUrl = URL(string: urlString, relativeTo: API_ENDPOINT.BaseURL) else {
            return nil
        }
        
        
        
        
        var header: HTTPHeaders = [:]
        
        if let authToken = KeychainWrapper.standard.string(forKey: "accessToken"){
            print("authToken",authToken)
            header["Authorization"] = "PULSE \(authToken)"
        }
        //      header = ["Content-Type": "application/json"]
        
        
        print("fullUrl:\(fullUrl.absoluteString)")
        //        print(parameters!)
        
        return AF.request( fullUrl, method: method, parameters: parameters , encoding: encoding, headers: header)
}

//public func MSRequest(
//    _ method: HTTPMethod,
//    _ urlString: String,
//      parameters: Parameters? = nil,
//      encoding: ParameterEncoding = URLEncoding.default,
//      headers: [String: String]? = nil)
//    -> DataRequest? {
//        guard let fullUrl = URL(string: urlString, relativeTo: API_ENDPOINT.BaseURL as URL) else {
//            return nil
//        }
//        return Request(method, fullUrl.absoluteString, parameters: parameters, encoding: encoding, headers: headers)
//
//      //  return request(fullUrl, method: method, parameters: parameters, encoding: encoding, headers: headers)
//}

//public func UploadRequest(
//    _ method: HTTPMethod,
//    _ urlString: String,
//      headers: [String: String]? = nil,
//      multipartFormData: @escaping (MultipartFormData) -> Void,
//      encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
//      encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
//{
//    guard let fullUrl = URL(string: urlString, relativeTo:API_ENDPOINT.BaseURL as URL) else {
//        return
//    }
//    /*multipartFormData: @escaping (MultipartFormData) -> Void,
//     usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
//     to url: URLConvertible,
//     method: HTTPMethod = .post,
//     headers: HTTPHeaders? = nil,
//     encodingCompletion:*/
//
//    print("fullUrl", fullUrl)
//
//    var header:[String:String] = [
//        "appKey":API_ENDPOINT.API_ENDPOINTEY]
//
//    if let currentToken = AppSessionManager.shared.authToken{
//        header["authToken"] = currentToken
//    }
//    /*
//    if let currentUser = AppSessionManager.shared.authToken{
//        header["authToken"] = currentUser
//    }
//    */
//    return AF.upload(
//        multipartFormData: multipartFormData,
//        usingThreshold: encodingMemoryThreshold,
//        to: fullUrl,
//        method: method,
//        headers: header,
//        encodingCompletion: encodingCompletion
//    )
//}



