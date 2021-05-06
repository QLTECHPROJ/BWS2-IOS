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
    var ScoreLevel = ""
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
    var EmailSend = ""
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
    var ResponseData = PlanListDataModel()
}

class PlanListDataModel : EVObject {
    var Image = ""
    var Title = ""
    var Desc = ""
    var TrialPeriod = ""
    var PlanFeatures = [PlanFeatureModel]()
    var Plan = [PlanDetailsModel]()
    var AudioFiles = [AudioDetailsDataModel]()
    var IntroductorySession = [SesssionDataModel]()
    var TestminialVideo = [TestminialVideoDataModel]()
    var FAQs = [FAQDataModel]()
}

class PlanDetailsModel:EVObject {
    var PlanPosition = ""
    var ProfileCount = ""
    var PlanID = ""
    var PlanAmount = ""
    var PlanCurrency = ""
    var PlanInterval = ""
    var PlanImage = ""
    var PlanTenure = ""
    var PlanNextRenewal = ""
    var FreeTrial = ""
    var SubName = ""
    var RecommendedFlag = ""
    var PlanFlag = ""
    var isSelected = false
}

class PlanFeatureModel:EVObject {
    var Feature = ""
}

class SesssionDataModel:EVObject {
    
}

class TestminialVideoDataModel : EVObject {
    var UserName = ""
    var VideoLink = ""
    var VideoDesc = ""
}

// MARK:- FAQ API Models
class FAQListModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData = [FAQDataModel]()
}

class FAQDataModel : EVObject {
    var ID = ""
    var Title = ""
    var Desc = ""
    var VideoURL = ""
    var Category = ""
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
    var View = ""
    var Details = [CategoryDataModel]()
}

class CategoryDataModel : EVObject {
    var ID = ""
    var ProblemName = ""
    var isSelected = false
}

// MARK:- Save Category API Models
class SaveCategoryModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData : SaveCategoryDataModel?
}

class SaveCategoryDataModel : EVObject {
    var CoUserId = ""
    var AvgSleepTime = ""
    var CategoryData = [AreaOfFocusModel]()
}

class AreaOfFocusModel : EVObject {
    var MainCat = ""
    var RecommendedCat = ""
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
    var DOB = ""
    var Image = ""
    var isProfileCompleted = ""
    var isAssessmentCompleted = ""
    var indexScore = ""
    var ScoreLevel = ""
    var planDetails : [Any]?
    var errormsg = ""
    var AreaOfFocus = [AreaOfFocusModel]()
    var AvgSleepTime = ""
    var isSelected = false
    
    static var profileImage : UIImage?
    
    class var currentUser : CoUserDataModel? {
        get {
            if let userData = UserDefaults.standard.data(forKey: "CoUserData") {
                return CoUserDataModel(data: userData)
            }
            return nil
        }
        set {
            CoUserDataModel.profileImage = nil
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
class ManageHomeModel : EVObject {
    var ResponseData : ManageHomedataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class ManageHomedataModel : EVObject {
    var SuggestedPlaylist : PlaylistDetailsModel?
    var Playlist = [PlaylistHomeDataModel]()
    var Audio = [AudioHomeDataModel]()
}

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
    var HomeAudioID = ""
    var View = ""
    var UserID = ""
    var CoUserId = ""
    var Details = [AudioDetailsDataModel]()
    var IsLock = ""
}

public class AudioDetailsDataModel: EVObject {
    var ID = ""
    var PSID = ""
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

class AudioDetailsModel: EVObject {
    var ResponseData = [AudioDetailsDataModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

// MARK:- Notification List API Models
class NotificationListModel: EVObject {
    var ResponseData = [NotificationListDataModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class NotificationListDataModel: EVObject {
    var ID = ""
    var Image = ""
    var Msg = ""
    var DurationTime = ""
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
    var CoUserId = ""
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
    var ReminderId = ""
    var ReminderTime = ""
    var ReminderDay = ""
    var PlaylistImageDetail = ""
    var Like  = ""
    var PlaylistSongs = [AudioDetailsDataModel]()
    
    var sectionName = ""
    var selfCreated = ""
    var isSelected = false
}

class PlaylistListingModel: EVObject {
    var ResponseData = [PlaylistDetailsModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

// MARK:- Create Playlist API Models
class CreatePlaylistModel: EVObject {
    var ResponseData : CreatePlaylistDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class CreatePlaylistDataModel: EVObject {
    var PlaylistID = ""
    var PlaylistName = ""
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

// MARK:- Average Sleep Time Model
class AverageSleepTimeModel: EVObject {
    var ResponseData = [AverageSleepTimeDataModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class AverageSleepTimeDataModel: EVObject {
    var Name = ""
    var isSelected = false
}

// MARK:- Average Sleep Time Model
class HomeModel: EVObject {
    var ResponseData = HomeDataModel()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class HomeDataModel: EVObject {
    var IndexScore = ""
    var shouldCheckIndexScore = ""
    var IndexScoreDiff = ""
    var ScoreIncDec = ""
    var SuggestedPlaylist : PlaylistDetailsModel?
    var PastIndexScore = [PastIndexScoreModel]()
    var SessionScore = [SessionScoreModel]()
    var SessionProgress = [SessionProgressModel]()
}

class PastIndexScoreModel : EVObject {
    var Month = ""
    var MonthName = ""
    var IndexScore = ""
}

class SessionScoreModel : EVObject {
    
}

class SessionProgressModel : EVObject {
    
}

// MARK:- Resource Category Model
class ResourceCategoryModel: EVObject {
    var ResponseData : [ResourceCategoryDataModel]?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class ResourceCategoryDataModel: EVObject {
    var CategoryName = ""
}

// MARK:- Resource List Model
class ResourceListModel: EVObject {
    var ResponseData : [ResourceListDataModel]?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class ResourceListDataModel: EVObject {
    var ID = ""
    var title = ""
    var type = ""
    var master_category = ""
    var sub_category = ""
    var ResourceDesc = ""
    var image = ""
    var author = ""
    var resource_link_1 = ""
    var resource_link_2 = ""
    var Detailimage = ""
}

// MARK:- Reminder API Model
class ReminderModel:EVObject {
    var ResponseData = [ReminderListDataModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class ReminderListDataModel:EVObject {
    var ReminderId = ""
    var PlaylistId = ""
    var PlaylistName = ""
    var ReminderDay = ""
    var ReminderTime = ""
    var IsCheck = ""
    var IsLock = ""
    var RDay = ""
    var Created = ""
}

class ReminderPlayListModel:EVObject {
    var ResponseData = [ReminderPlayListDataModel]()
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class ReminderPlayListDataModel:EVObject {
    var ID = ""
    var Name = ""
}

class AddProfileImageModel: EVObject {
    var ResponseData : AddProfileImageDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class AddProfileImageDataModel: EVObject {
    var ProfileImage = ""
    var UserID = ""
}
