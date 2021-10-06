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
    
    // User Module - APIs
    case appversion([String:String])
    case countrylist
    case loginsignup([String:String])
    case authotp([String:String])
    case login([String:String])
    case forgotpass([String:String])
    case addcouser([String:String])
    case forgotpin([String:String])
    case userlist([String:String])
    case verifypin([String:String])
    case getcouserdetails([String:String])
    case profilesaveans([String:String])
    case assesmentquestionlist
    case assesmentsaveans([String:String])
    case assesmentgetdetails([String:String])
    case planlist([String:String])
    case avgsleeptime
    case getrecommendedcategory([String:String])
    case saverecommendedcategory([String:Any])
    case setloginpin([String:Any])
    case inviteuser([String:Any])

    
    // Home Tab - APIs
    case proceed([String:String])
    case homescreen([String:String])
    case getnotificationlist([String:String])
    
    // Manage Plan Tab - APIs
    case managehomescreen([String:String])
    case managehomeviewallaudio([String:String])
    
    // Audio - APIs
    case audiodetail([String:String])
    case recentlyplayed([String:String])
    
    // Playlist - APIs
    case playlistdetails([String:String])
    case createplaylist([String:String])
    case getcreatedplaylist([String:String])
    case renameplaylist([String:String])
    case deleteplaylist([String:String])
    case addaptoplaylist([String:String])
    case removeaudiofromplaylist([String:String])
    case sortingplaylistaudio([String:String])
    case playlistlibrary([String:String])
    case playlistonviewall([String:String])
    
    // Add / Search Audio - APIs
    case suggestedaudio([String:String])
    case suggestedplaylist([String:String])
    case searchonsuggestedlist([String:String])
    
    //Account
    case removeuser([String:String])
    case deleteuser([String:String])
    case manageuserlist([String:String])
    case cancelinviteuser([String:String])
    case resourcelist([String:String])
    case resourcecatlist([String:String])
    case logout([String:String])
    case changepin([String:String])
    case changepassword([String:String])
    case faqlist
    case reminderlist([String:String])
    case reminderstatus([String:String])
    case setreminder([String:String])
    case deletereminder([String:String])
    case updateprofileimg([String:String])
    case removeprofileimg([String:String])
    case editprofile([String:String])
    
    // In App Purchase
    case verifyreceipt([String:Any])
    case planpurchase([String:Any])
    case plandetails([String:Any])
    case userplanlist([String:Any])
    case cancelplan([String:Any])
    
    // Audio Interruption
    case audiointerruption([String:Any])
    
    //ActivityTracking
    case useraudiotracking([String:Any])
    
    // Send Payment Link
    case sendpaymentlink([String:Any])
    
    var route: APIRoute {
        switch self {
        case .appversion(let data):
            return APIRoute(path: "appversion", method: .post, data: data)
        case .countrylist:
            return APIRoute(path: "countrylist", method: .get)
        case .loginsignup(let data):
            return APIRoute(path: "loginsignup", method: .post, data: data)
        case .authotp(let data):
            return APIRoute(path: "authotp", method: .post, data: data)
        case .login(let data):
            return APIRoute(path: "login", method: .post, data: data)
        case .forgotpass(let data):
            return APIRoute(path: "forgotpass", method: .post, data: data)
        case .addcouser(let data):
            return APIRoute(path: "addcouser", method: .post, data: data)
        case .forgotpin(let data):
            return APIRoute(path: "forgotpin", method: .post, data: data)
        case .userlist(let data):
            return APIRoute(path: "userlist", method: .post, data: data)
        case .verifypin(let data):
            return APIRoute(path: "verifypin", method: .post, data: data)
        case .getcouserdetails(let data):
            return APIRoute(path: "getcouserdetails", method: .post, data: data)
        case .profilesaveans(let data):
            return APIRoute(path: "profilesaveans", method: .post, data: data)
        case .assesmentquestionlist:
            return APIRoute(path: "assesmentquestionlist", method: .get)
        case .assesmentsaveans(let data):
            return APIRoute(path: "assesmentsaveans", method: .post, data: data)
        case .assesmentgetdetails(let data):
            return APIRoute(path: "assesmentgetdetails", method: .post, data: data)
        case .planlist(let data):
            return APIRoute(path: "planlist", method: .post, data: data)
        case .avgsleeptime:
            return APIRoute(path: "avgsleeptime", method: .get)
        case .getrecommendedcategory(let data):
            return APIRoute(path: "getrecommendedcategory", method: .post, data: data)
        case .saverecommendedcategory(let data):
            return APIRoute(path: "saverecommendedcategory", method: .post, data: data)
        case .setloginpin(let data):
            return APIRoute(path: "setloginpin", method: .post, data: data)
        case .inviteuser(let data):
            return APIRoute(path: "inviteuser", method: .post, data: data)
        
        case .proceed(let data):
            return APIRoute(path: "proceed", method: .post, data: data)
        case .homescreen(let data):
            return APIRoute(path: "homescreen", method: .post, data: data)
        case .getnotificationlist(let data):
            return APIRoute(path: "getnotificationlist", method: .post, data: data)
            
        case .managehomescreen(let data):
            return APIRoute(path: "managehomescreen", method: .post, data: data)
        case .managehomeviewallaudio(let data):
            return APIRoute(path: "managehomeviewallaudio", method: .post, data: data)
            
        case .audiodetail(let data):
            return APIRoute(path: "audiodetail", method: .post, data: data)
        case .recentlyplayed(let data):
            return APIRoute(path: "recentlyplayed", method: .post, data: data)
        
        case .playlistdetails(let data):
            return APIRoute(path: "playlistdetails", method: .post, data: data)
        case .createplaylist(let data):
            return APIRoute(path: "createplaylist", method: .post, data: data)
        case .getcreatedplaylist(let data):
            return APIRoute(path: "getcreatedplaylist", method: .post, data: data)
        case .renameplaylist(let data):
            return APIRoute(path: "renameplaylist", method: .post, data: data)
        case .deleteplaylist(let data):
            return APIRoute(path: "deleteplaylist", method: .post, data: data)
        case .addaptoplaylist(let data):
            return APIRoute(path: "addaptoplaylist", method: .post, data: data)
        case .removeaudiofromplaylist(let data):
            return APIRoute(path: "removeaudiofromplaylist", method: .post, data: data)
        case .sortingplaylistaudio(let data):
            return APIRoute(path: "sortingplaylistaudio", method: .post, data: data)
        case .playlistlibrary(let data):
            return APIRoute(path: "playlistlibrary", method: .post, data: data)
        case .playlistonviewall(let data):
            return APIRoute(path: "playlistonviewall", method: .post, data: data)
            
        case .suggestedaudio(let data):
            return APIRoute(path: "suggestedaudio", method: .post, data: data)
        case .suggestedplaylist(let data):
            return APIRoute(path: "suggestedplaylist", method: .post, data: data)
        case .searchonsuggestedlist(let data):
            return APIRoute(path: "searchonsuggestedlist", method: .post, data: data)
            
        //Account
        case .removeuser(let data):
            return APIRoute(path: "removeuser", method: .post, data: data)
        case .deleteuser(let data):
            return APIRoute(path: "deleteuser", method: .post, data: data)
        case .manageuserlist(let data):
            return APIRoute(path: "manageuserlist", method: .post, data: data)
        case .cancelinviteuser(let data):
            return APIRoute(path: "cancelinviteuser", method: .post, data: data)
        case .resourcelist(let data):
            return APIRoute(path: "resourcelist", method: .post, data: data)
        case .resourcecatlist(let data):
            return APIRoute(path: "resourcecatlist", method: .post, data: data)
        case .logout(let data):
            return APIRoute(path: "logout", method: .post, data: data)
        case .changepin(let data):
            return APIRoute(path: "changepin", method: .post, data: data)
        case .changepassword(let data):
            return APIRoute(path: "changepassword", method: .post, data: data)
        case .faqlist:
            return APIRoute(path: "faqlist", method: .get)
        case .reminderlist(let data):
            return APIRoute(path: "reminderlist", method: .post, data: data)
        case .reminderstatus(let data):
            return APIRoute(path: "reminderstatus", method: .post, data: data)
        case .setreminder(let data):
            return APIRoute(path: "setreminder", method: .post, data: data)
        case .deletereminder(let data):
            return APIRoute(path: "deletereminder", method: .post, data: data)
        case .updateprofileimg(let data):
            return APIRoute(path: "updateprofileimg", method: .post, data: data)
        case .removeprofileimg(let data):
            return APIRoute(path: "removeprofileimg", method: .post, data: data)
        case .editprofile(let data):
            return APIRoute(path: "editprofile", method: .post, data: data)
            
        // In App Purchase
        case .verifyreceipt(let data):
            return APIRoute(path: "verifyreceipt", method: .post, data: data)
        case .planpurchase(let data):
            return APIRoute(path: "planpurchase", method: .post, data: data)
        case .plandetails(let data):
            return APIRoute(path: "plandetails", method: .post, data: data)
        case .userplanlist(let data):
            return APIRoute(path: "userplanlist", method: .post, data: data)
        case .cancelplan(let data):
            return APIRoute(path: "cancelplan", method: .post, data: data)
            
        // Audio Interruption
        case .audiointerruption(let data):
            return APIRoute(path: "audiointerruption", method: .post, data: data)
            
        // ActivityTracking
        case .useraudiotracking(let data):
            return APIRoute(path: "useraudiotracking", method: .post, data: data)
            
        // Send Payment Link
        case .sendpaymentlink(let data):
            return APIRoute(path: "sendpaymentlink", method: .post, data: data)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let route = self.route
        let url = URL(string: API_BASE_URL)!
        var mutableURLRequest = URLRequest(url: url.appendingPathComponent(route.path))
        mutableURLRequest.httpMethod = route.method.rawValue
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        // mutableURLRequest.setValue("1", forHTTPHeaderField: "Test")
        mutableURLRequest.setValue(APICallManager.sharedInstance.generateToken(), forHTTPHeaderField: "Oauth")
        mutableURLRequest.setValue(DEVICE_UUID, forHTTPHeaderField: "Yaccess")
        
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
    
    var apiRequest : DataRequest?
    
    func generateToken()-> String {
        let arrToken = ["AES:OsEUHhecSs4gRGcy2vMQs1s/XajBrLGADR71cKMRNtA=","RSA:KlWxBHfKPGkkeTjkT7IEo32bZW8GlVCPq/nvVFuYfIY=","TDES:1dpra0SZhVPpiUQvikMvkDxEp7qLLJL9pe9G6Apg01g=","SHA1:Ey8rBCHsqITEbh7KQKRmYObCGBXqFnvtL5GjMFQWHQo=","MD5:/qc2rO3RB8Z/XA+CmHY0tCaJch9a5BdlQW1xb7db+bg="]
        let randomElement = arrToken.randomElement()
        // print(randomElement as Any)
        
        let fullNameArr = randomElement!.split{$0 == ":"}.map(String.init)
        let key = fullNameArr[0]
        let valuue = fullNameArr[1]
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        let utcTimeZoneStr = formatter.string(from: date as Date)
        // print("dateformat:-",utcTimeZoneStr)
        
        let format = DEVICE_UUID + "." + utcTimeZoneStr + "."  + key + "." + valuue
        print("idname:-",format)
        // tokenRandom = CryptoHelper.encrypt(input:format)!
        // let base64encoded = format.toBase64()
        // print("Encoded:", base64encoded as Any)
        
        let skey = "5785abf057d4eea9e59151f75a6fadb724768053df2acdfabb68f2b946b972c6"
        
        let cryptLib = CryptLib()
        let cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: format, key: skey)
        print("cipherText \(cipherText! as String)")
        
        let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: cipherText, key: skey)
        print("decryptedString \(decryptedString! as String)")
        
        // let base64decoded = base64encoded.fromBase64()
        // print("deEncoded:", base64decoded as Any)
        
        // let data = NSData(base64EncodedString: format, options: NSData.Base64DecodingOptions.fromRaw(0)!)
        
        // Convert back to a string
        // let base64Decoded = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        // Base64 encode UTF 8 string
        // fromRaw(0) is equivalent to objc 'base64EncodedStringWithOptions:0'
        // Notice the unwrapping given the NSData! optional
        // NSString! returned (optional)
        // let base64Encoded = utf8str.base64EncodedStringWithOptions(NSData.Base64EncodingOptions.fromRaw(0)!)
        // tokenRandom = base64encoded
        let tokenRandom = cipherText
        
        // debugPrint("cipher:" + tokenRandom!)
        // let deceprt =  CryptoHelper.decrypt(input: tokenRandom!)
        // debugPrint("deceprt:" + deceprt!)
        return tokenRandom ?? ""
    }
    
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
        
        self.apiRequest = Alamofire.request(router).responseObject { (responseObj : DataResponse<M>) in
            
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
                            if (dict["ResponseCode"] as? String) == "403" {
                                AccountVC.handleLogout()
                            } else if let message = dict["ResponseMessage"] as? String, message.trim.count > 0 , message != "Reminder not Available for any playlist!" {
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
            headers = ["Accept":"application/json",
                       "Oauth":APICallManager.sharedInstance.generateToken(),
                       "Yaccess":DEVICE_UUID]
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
                                    if (dict["ResponseCode"] as? String) == "403" {
                                        AccountVC.handleLogout()
                                    } else if let message = dict["ResponseMessage"] as? String, message.trim.count > 0 {
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

