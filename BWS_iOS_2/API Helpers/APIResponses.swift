//
//  APIResponses.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import UIKit
import EVReflection


// MARK:- General API Models
class GeneralModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData : GeneralDataModel?
}

class GeneralDataModel : EVObject {
    var errormsg = ""
    var indexScore = ""
}

// MARK:- Upload Data Model
class UploadDataModel : EVObject {
    var name = ""
    var key = ""
    var data : Data?
    var extention = ""
    var mimeType = ""
    
    init(name:String, key:String, data:Data?, extention:String, mimeType:String) {
        self.name = name
        self.key = key
        self.data = data
        self.extention = extention
        self.mimeType = mimeType
    }
    
    required init() {
        super.init()
    }
    
}

// MARK:- AppVersion API Models
class AppVersionModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData = AppVersionDataModel()
}

class AppVersionDataModel : EVObject {
    var IsForce = ""
    var displayRegister = ""
    var segmentKey = ""
    var supportText = ""
    var supportEmail = ""
}

// MARK:- CountryList API Models
class CountrylistModel : EVObject {
    var ResponseData = [CountrylistDataModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class CountrylistDataModel : EVObject {
    var ID = ""
    var Name = ""
    var ShortName = ""
    var Code = ""
    
    init(id : String, name : String, shortName : String, code : String) {
        ID = id
        Name = name
        ShortName = shortName
        Code = code
    }
    
    required init() {
        ID = ""
        Name = ""
        ShortName = ""
        Code = ""
    }
    
}


// MARK:- SignUp API Models
class LoginModel : EVObject {
    var ResponseData : LoginDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class LoginDataModel : EVObject {
    var ID = ""
    var Name = ""
    var Email = ""
    var MobileNo = ""
    var errormsg = ""
    
    class var currentUser : LoginDataModel? {
        get {
            if let userData = UserDefaults.standard.data(forKey: "UserData") {
                return LoginDataModel(data: userData)
            }
            return nil
        }
        set {
            if let newData = newValue {
                UserDefaults.standard.setValue(newData.toJsonData(), forKey: "UserData")
            }
            else {
                UserDefaults.standard.setValue(nil, forKey: "UserData")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    class var lastLoginUserID : String? {
        get {
            return UserDefaults.standard.string(forKey: "LastLoginUserID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LastLoginUserID")
            UserDefaults.standard.synchronize()
        }
    }
    
}

// MARK:- Plan List API Models
class PlanListModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData = [PlanDataModel]()
}

class PlanDataModel : EVObject {
    var PlanName = ""
    var PlanDescription = ""
    var PlanPrice = ""
    var PlanPeriod = ""
    var Popular = ""
    var isSelected = false
}

// MARK:- General API Models
class AudioListModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData = [AudioDataModel]()
}

class AudioDataModel : EVObject {
    var ID = ""
    var Name = ""
    var Image = ""
}


// MARK:- FAQ API Models
class FAQListModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData = [FAQDataModel]()
}

class FAQDataModel : EVObject {
    var Question = ""
    var Answer = ""
    var isSelected = false
}


// MARK:- Sleep Time API Models
class SleepTimeListModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData = [SleepTimeDataModel]()
}

class SleepTimeDataModel : EVObject {
    var ID = ""
    var SleepTime = ""
    var isSelected = false
}


// MARK:- Sleep Time API Models
class CategoryModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData = [CategoryListModel]()
}

class CategoryListModel : EVObject {
    var ID = ""
    var CategoryName = ""
    var SubCategories = [CategoryDataModel]()
}

class CategoryDataModel : EVObject {
    var ID = ""
    var CategoryName = ""
    var isSelected = false
}


// MARK:- Add Co User API Models
class CoUserModel : EVObject {
    var ResponseData : CoUserDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class CoUserDataModel : EVObject {
    var UserID = ""
    var CoUserId = ""
    var Name = ""
    var Email = ""
    var Mobile = ""
    var isProfileCompleted = ""
    var isAssessmentCompleted = ""
    var indexScore = ""
    var planDetails : [Any]?
    var errormsg = ""
    var isSelected = false
    
    class var currentUser : CoUserDataModel? {
        get {
            if let userData = UserDefaults.standard.data(forKey: "CoUserData") {
                return CoUserDataModel(data: userData)
            }
            return nil
        }
        set {
            if let newData = newValue {
                UserDefaults.standard.setValue(newData.toJsonData(), forKey: "CoUserData")
            }
            else {
                UserDefaults.standard.setValue(nil, forKey: "CoUserData")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    class var lastCoUserID : String? {
        get {
            return UserDefaults.standard.string(forKey: "LastCoUserID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LastCoUserID")
            UserDefaults.standard.synchronize()
        }
    }
    
}


// MARK:- Add Co User API Models
class UserListModel : EVObject {
    var ResponseData = UserListDataModel()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class UserListDataModel : EVObject {
    var Maxuseradd = ""
    var CoUserList = [CoUserDataModel]()
    var errormsg = ""
}


// MARK:- Home Screen Audio API Models
class AudioHomeModel: EVObject {
    var ResponseData = [AudioHomeDataModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class AudioViewAllModel: EVObject {
    var ResponseData : AudioHomeDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class AudioHomeDataModel: EVObject {
    var HomeID = ""
    var View = ""
    var UserID = ""
    var Details = [AudioDetailsDataModel]()
    var IsLock = ""
    var expireDate = ""
}

public class AudioDetailsDataModel: EVObject {
    var ID = ""
    var PlaylistID = ""
    var Name = ""
    var AudioFile = ""
    var ImageFile = ""
    var AudioDuration = ""
    var AudioDirection = ""
    var AudioDescription = ""
    var Audiomastercat = ""
    var AudioSubCategory = ""
    var Like = ""
    var Download = ""
    var Iscategory = ""
    var Bitrate = ""
    
    // For Search Screen - Playlist Response
    var Created = ""
    var TotalAudio = ""
    var TotalDuration = ""
    var Totalhour = ""
    var Totalminute = ""
    
    // For Top Category
    var CategoryName = ""
    var CatImage = ""
    
    // Download Database
    var selfCreated = ""
    var downloadLocation = ""
    var isSingleAudio = ""
    var sortId = ""
    
    //lock functionality
    var IsLock = ""
    var IsPlay = ""
    
    var isDisclaimer = false
    
    // For Add to Playlist button
    var isSelected = false
}


// MARK:- Playlist Home API Models
class PlaylistHomeModel: EVObject {
    var ResponseData = [PlaylistHomeDataModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class PlaylistLibraryModel: EVObject {
    var ResponseData : PlaylistHomeDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class PlaylistHomeDataModel: EVObject {
    var GetLibraryID = ""
    var View = ""
    var UserID = ""
    var Details = [PlaylistDetailsModel]()
    var IsLock = ""
}

class PlaylistDetailsModel: EVObject {
    var PlaylistID = ""
    var PlaylistName = ""
    var PlaylistDesc = ""
    var PlaylistMastercat = ""
    var PlaylistSubcat = ""
    var PlaylistImage = ""
    var TotalAudio = ""
    var TotalDuration = ""
    var Totalhour = ""
    var Totalminute = ""
    var Created = ""
    var Download = ""
    var IsLock = ""
    var IsReminder = ""
    var ReminderTime = ""
    var ReminderDay = ""
    var PlaylistImageDetail = ""
    var Like  = ""
    var PlaylistSongs = [AudioDetailsDataModel]()
    
    var sectionName = ""
    var selfCreated = ""
    var isSelected = false
}


// MARK:- Create Playlist API Models
class CreatePlaylistModel: EVObject {
    var ResponseData : CreatePlaylistDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class CreatePlaylistDataModel: EVObject {
    var id = ""
    var name = ""
    var Iscreate = ""
}


// MARK:- Playlist Details API Models
class PlaylistDetailsAPIModel: EVObject {
    var ResponseData : PlaylistDetailsModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}


// MARK:- Assessment Questions API Model
class AssessmentQueAPIModel:EVObject {
    var ResponseData : AssessmentDetailModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class AssessmentDetailModel: EVObject {
    var Toptitle = ""
    var Subtitle = ""
    var Content = [AssessmentContentModel]()
    var Questions = [AssessmentQueModel]()
    
    class var current : AssessmentDetailModel? {
        get {
            if let data = UserDefaults.standard.data(forKey: "DassAssessmentData") {
                return AssessmentDetailModel(data: data)
            }
            return nil
        }
        set {
            if let data = newValue {
                UserDefaults.standard.setValue(data.toJsonData(), forKey: "DassAssessmentData")
            }
            else {
                UserDefaults.standard.setValue(nil, forKey: "DassAssessmentData")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
}

class AssessmentContentModel: EVObject {
    var condition = ""
}

class AssessmentQueModel: EVObject {
    var Question = ""
    var QueType = ""
    var Answer = ""
    var Loop = ""
    var answers = [Int]()
    var selectedAnswer = -1
}
