//
//  APIManager.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection
import SystemConfiguration

enum APIRouter: URLRequestConvertible {
    
    // User Module
    case appversion([String:String])
    case countrylist
    case signup([String:String])
    case login([String:String])
    case forgotpass([String:String])
    case addcouser([String:String])
    case userlist([String:String])
    case verifypin([String:String])
    
    var route: APIRoute {
        switch self {
        case .appversion(let data):
            return APIRoute(path: "appversion", method: .post, data: data)
        case .countrylist:
            return APIRoute(path: "countrylist", method: .get)
        case .signup(let data):
            return APIRoute(path: "signup", method: .post, data: data)
        case .login(let data):
            return APIRoute(path: "login", method: .post, data: data)
        case .forgotpass(let data):
            return APIRoute(path: "forgotpass", method: .post, data: data)
        case .addcouser(let data):
            return APIRoute(path: "addcouser", method: .post, data: data)
        case .userlist(let data):
            return APIRoute(path: "userlist", method: .post, data: data)
        case .verifypin(let data):
            return APIRoute(path: "verifypin", method: .post, data: data)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let route = self.route
        let url = URL(string: API_BASE_URL)!
        var mutableURLRequest = URLRequest(url: url.appendingPathComponent(route.path))
        mutableURLRequest.httpMethod = route.method.rawValue
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableURLRequest.setValue("1", forHTTPHeaderField: "Test")
        
        print("API Parameters :- ", route.data ?? "")
        print("API Path :- ", API_BASE_URL + route.path)
        
        if let data = route.data {
            if route.method == .get {
                return try Alamofire.URLEncoding.default.encode(mutableURLRequest, with: data)
            }
            return try Alamofire.JSONEncoding.default.encode(mutableURLRequest, with: data)
        }
        return mutableURLRequest
    }
    
}

class APICallManager {
    
    static let sharedInstance = APICallManager()
    
    func stopAllAPICalls() {
        Alamofire.SessionManager.default.session.invalidateAndCancel()
    }
    
    func callAPI<M : EVObject>(router : URLRequestConvertible, displayHud : Bool = true, showToast : Bool = true, response : @escaping (M) -> Void) {
        
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            response(M())
            return
        }
        
        if displayHud {
            showHud()
        }
        
        Alamofire.request(router).responseObject { (responseObj : DataResponse<M>) in
            
            hideHud()
            
            if let error = responseObj.result.error {
                if checkErrorTypeNetworkLost(error: error) {
                    self.callAPI(router: router, response: response)
                }
            }
            
            self.handleError(data: responseObj, showToast: showToast, response: { (success) in
                if success {
                    if let value = responseObj.result.value {
                        response(value)
                        let dict = value.toDictionary()
                        if (dict["ResponseCode"] as? String) != "200" {
                            if let message = dict["ResponseMessage"] as? String, message.trim.count > 0 , message != "Reminder not Available for any playlist!" {
                                if showToast { showAlertToast(message: message) }
                            }
                        }
                    }
                }
            })
        }
        .responseString { (resp) in
            print(resp)
        }
        //        .responseJSON { (resp) in
        //            print("responseJSON :- ", resp)
        //        }
    }
    
    func callUploadWebService<M : EVObject>(apiUrl : String, includeHeader : Bool, parameters : [String:Any]?, uploadParameters : [UploadDataModel], httpMethod : Alamofire.HTTPMethod, displayHud : Bool = true, showToast : Bool = true, responseModel : @escaping (M) -> Void) {
        
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            responseModel(M())
            return
        }
        
        if displayHud {
            showHud()
        }
        
        var headers : HTTPHeaders?
        if includeHeader {
            headers = ["Accept":"application/json","Test":"1"]
        }
        
        if parameters != nil {
            print("parameters :- ",parameters!)
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if parameters != nil {
                for (key, value) in parameters! {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
            if uploadParameters.count > 0 {
                for uploadDict in uploadParameters {
                    multipartFormData.append(uploadDict.data!, withName: uploadDict.key, fileName: uploadDict.name, mimeType: uploadDict.mimeType)
                }
            }
            
        }, usingThreshold: UInt64.init(), to: apiUrl, method: httpMethod, headers: headers) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseObject { (response : DataResponse<M>) in
                    
                    hideHud()
                    
                    if let error = response.result.error {
                        if checkErrorTypeNetworkLost(error: error) {
                            self.callUploadWebService(apiUrl: apiUrl, includeHeader: includeHeader, parameters: parameters, uploadParameters: uploadParameters, httpMethod: httpMethod, displayHud: displayHud, showToast: showToast, responseModel: responseModel)
                        }
                    }
                    
                    self.handleError(data: response, showToast: showToast, response: { (success) in
                        if success {
                            if let value = response.result.value {
                                responseModel(value)
                                let dict = value.toDictionary()
                                if (dict["ResponseCode"] as? String) != "200" {
                                    if let message = dict["ResponseMessage"] as? String, message.trim.count > 0 {
                                        if showToast { showAlertToast(message: message) }
                                    }
                                }
                            }
                        }
                    })
                }
                .responseString { (resp) in
                    print(resp)
                }
            case .failure(let error):
                hideHud()
                print("Error in upload: \(error.localizedDescription)")
                showAlertToast(message: error.localizedDescription)
            }
        }
        
    }
    
    func handleError<D : EVObject>(data : DataResponse<D>, showToast : Bool = true, response : @escaping (Bool) -> Void) {
        //        print(data)
        
        guard let dict = data.result.value?.toDictionary() else {
            // showAlertToast(message: Theme.strings.alert_something_went_wrong)
            return
        }
        
        guard let message = dict.value(forKey: "ResponseMessage") as? String else {
            // showAlertToast(message: Theme.strings.alert_something_went_wrong)
            return
        }
        
        switch data.response?.statusCode ?? 0 {
        case 200...299:
            response(true)
        case 401:
            // UnAuthenticated request
            response(false)
            if showToast && message.trim.count > 0 { showAlertToast(message: message) }
        default:
            response(false)
            if showToast && message.trim.count > 0 { showAlertToast(message: message) }
        }
    }
    
}

