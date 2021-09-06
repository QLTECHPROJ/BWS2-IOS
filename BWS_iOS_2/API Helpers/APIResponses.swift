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

struct APIParameters {
    static let UserId = "UserId"
    static let MainAccountID = "MainAccountID"
}

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
    var status = ""
    var InviteLink = ""
    var data : RecieptDataModel?
}

class RecieptDataModel : EVObject {
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
    var IsLoginFirstTime = ""
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

class SendOTPModel : EVObject {
    var ResponseData : SendOTPDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class SendOTPDataModel : EVObject {
    var MobileNo = ""
    var OTP = ""
    var errormsg = ""
    var SignupFlag = ""
    var IsRegistered = ""
}


// MARK:- Login API Models
class LoginModel : EVObject {
    var ResponseData : LoginDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class LoginDataModel : EVObject {
    var MainAccountID = ""
    var UserId = ""
    var directLogin = ""
    var isPinSet = ""
    var CountryCode = ""
    var Name = ""
    var Email = ""
    var ageSlabChange = ""
    var Mobile = ""
    var Image = ""
    var DOB = ""
    var isEmailVerified = ""
    var isProfileCompleted = ""
    var isAssessmentCompleted = ""
    var indexScore = ""
    var planDetails = [PlanDetailDataModel]()
    var AreaOfFocus = [AreaOfFocusModel]()
    var AvgSleepTime = ""
    var ScoreLevel = ""
    var errormsg = ""
    var error = ""
    var EmailSend = ""
    var isSelected = false
    var isMainAccount = ""
    var CoUserCount = ""
    var IsFirst = ""
    var Islock = ""
    var IsInCouser = ""
    
    static var profileImage : UIImage?
    
    class var currentMainAccountId : String {
        return LoginDataModel.currentUser?.MainAccountID ?? ""
    }
    
    class var currentUserId : String {
        return LoginDataModel.currentUser?.UserId ?? ""
    }
    
    class var mainAccountUser : LoginDataModel? {
        get {
            if let userData = UserDefaults.standard.data(forKey: "mainAccountUser") {
                return LoginDataModel(data: userData)
            }
            return nil
        }
        set {
            LoginDataModel.profileImage = nil
            if let newData = newValue {
                UserDefaults.standard.setValue(newData.toJsonData(), forKey: "mainAccountUser")
            } else {
                UserDefaults.standard.setValue(nil, forKey: "mainAccountUser")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    class var currentUser : LoginDataModel? {
        get {
            if let userData = UserDefaults.standard.data(forKey: "currentUser") {
                return LoginDataModel(data: userData)
            }
            return nil
        }
        set {
            LoginDataModel.profileImage = nil
            if let newData = newValue {
                UserDefaults.standard.setValue(newData.toJsonData(), forKey: "currentUser")
            } else {
                UserDefaults.standard.setValue(nil, forKey: "currentUser")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    class var lastUserID : String? {
        get {
            return UserDefaults.standard.string(forKey: "LastUserID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LastUserID")
            UserDefaults.standard.synchronize()
        }
    }
    
}

class PlanDetailDataModel:EVObject {
    var UserId = ""
    var UserGroupId = ""
    var PlanId = ""
    var DeviceType = ""
    var PlanPurchaseDate = ""
    var PlanExpireDate = ""
    var OriginalTransactionId = ""
    var TransactionId = ""
    var TrialPeriodStart = ""
    var TrialPeriodEnd = ""
    var PlanStatus = ""
    var PlanName = ""
    var PlanContent = ""
    var Price = ""
    var IntervalTime = ""
    var PlanDescription = ""
    var errormsg = ""
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

// MARK:- Plan Model
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
    var IOSplanId = ""
    var AndroidplanId = ""
    
    // IAP Parameters
    var iapProductIdentifier = ""
    var iapPrice = ""
    var iapTitle = ""
    var iapDescription = ""
    var iapTrialPeriod = ""
    var iapSubscriptionPeriod = ""
}

class IAPPlanDetailsModel:EVObject {
    var iapProductIdentifier = ""
    var iapPrice = ""
    var iapTitle = ""
    var iapDescription = ""
    var iapTrialPeriod = ""
    var iapSubscriptionPeriod = ""
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
    var errormsg = ""
    var UserId = ""
    var AvgSleepTime = ""
    var NoUpdation = ""
    var AreaOfFocus = [AreaOfFocusModel]()
    var popupContent = ""
    var showAlert = ""
    var SuggestedPlaylist : PlaylistDetailsModel?
}

class AreaOfFocusModel : EVObject {
    var MainCat = ""
    var RecommendedCat = ""
    var CatId = ""
    var shouldDelete = true
}

// MARK:- Add Co User API Models
class CoUserModel : EVObject {
    var ResponseData : CoUserDataModel?
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
}

class CoUserDataModel : EVObject {
    var MainAccountID = ""
    var UserId = ""
    var directLogin = ""
    var isPinSet = ""
    var CountryCode = ""
    var Name = ""
    var Email = ""
    var ageSlabChange = ""
    var Mobile = ""
    var Image = ""
    var DOB = ""
    var isEmailVerified = ""
    var isProfileCompleted = ""
    var isAssessmentCompleted = ""
    var indexScore = ""
    var planDetails = [PlanDetailDataModel]()
    var AreaOfFocus = [AreaOfFocusModel]()
    var AvgSleepTime = ""
    var ScoreLevel = ""
    var errormsg = ""
    var error = ""
    var EmailSend = ""
    var isSelected = false
    var isMainAccount = ""
    var CoUserCount = ""
    var InviteStatus = ""
    var IsFirst = ""
    var Islock = ""
    var IsInCouser = ""
    
    static var profileImage : UIImage?
    
    class var currentMainAccountId : String {
        return CoUserDataModel.currentUser?.MainAccountID ?? ""
    }
    
    class var currentUserId : String {
        return CoUserDataModel.currentUser?.UserId ?? ""
    }
    
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
    
    class var lastUserID : String? {
        get {
            return UserDefaults.standard.string(forKey: "LastUserID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LastUserID")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isAdminUser : Bool {
        if  self.isMainAccount == "1" {
            return true
        } else if self.UserId == self.MainAccountID {
            return true
        }
        
        return false
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
    var totalUserCount = ""
    var UserList = [CoUserDataModel]()
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
    var Islock = ""
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
    var UserId = ""
    var Details = [AudioDetailsDataModel]()
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
    var disableAudio = ""
    
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
    
    // Lock functionality
    var IsPlay = "1"
    
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
    var Desc = ""
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
    var UserId = ""
    var Details = [PlaylistDetailsModel]()
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
    var Totalsecond = ""
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
    var playlistDirection = ""
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
    var DayRegularity = ""
    var DayTotalTime = ""
    var DayFrequency = ""
    var MonthRegularity = ""
    var MonthTotalTime = ""
    var MonthFrequency = ""
    var YearRegularity = ""
    var YearTotalTime = ""
    var YearFrequency = ""
    var IndexScore = ""
    var IsFirst = ""
    var Islock = ""
    var shouldCheckIndexScore = ""
    var IndexScoreDiff = ""
    var ScoreIncDec = ""
    var shouldPlayDisclaimer = ""
    var disclaimerAudio : AudioDetailsDataModel?
    var SuggestedPlaylist : PlaylistDetailsModel?
    var PastIndexScore = [PastIndexScoreModel]()
    var SessionScore = [SessionScoreModel]()
    var SessionProgress = [SessionProgressModel]()
    var GraphAnalytics = [GraphAnalyticsModel]()
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

class GraphAnalyticsModel : EVObject {
    var Day = ""
    var Time = ""
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
    var UserId = ""
}

/**** Contact Model ****/

class ContactModel : EVObject {
    var contactName = ""
    var contactNumber = ""
    var contactImage : UIImage?
}


// MARK:- Assessment API Models
class AssessmentModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData : AssessmentDataModel?
}

class AssessmentDataModel : EVObject {
    var indexScore = ""
    var ScoreLevel = ""
    var TotalAssesment = ""
    var DaysfromLastAssesment = ""
    var IndexScoreDiff = ""
    var ScoreIncDec = ""
    var MainTitle = ""
    var SubTitle = ""
    var colorcode = ""
    var AssesmentTitle = ""
    var AssesmentContent = ""
    var errormsg = ""
}


// MARK:- Plan Details API Models
class PlanDataModel : EVObject {
    var ResponseCode = ""
    var ResponseMessage = ""
    var ResponseStatus = ""
    var ResponseData : PlanDetailDataModel?
}
