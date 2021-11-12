//
//  APICalls.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation

extension SplashVC {
    
    // App Version API Call
    func callAppVersionAPI() {
        var parameters = ["Version":APP_VERSION,
                          "AppType":APP_TYPE,
                          "DeviceID":DEVICE_UUID]
        
        if CoUserDataModel.currentUserId.trim.count > 0 {
            parameters["localTimezone"] = TimeZone.current.identifier
            parameters[APIParameters.UserId] = CoUserDataModel.currentUserId
        }
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.appversion(parameters), displayHud: false) { (response : AppVersionModel) in
            if response.ResponseCode == "200" {
                SplashVC.isForceUpdate = response.ResponseData.IsForce
                SplashVC.isLoginFirstTime = response.ResponseData.IsLoginFirstTime
                
                // Segment Configuration
                SegmentTracking.shared.segmentWriteKey = response.ResponseData.segmentKey
                SegmentTracking.shared.configureSegment()
                
                if response.ResponseData.setTime.trim.count > 0 {
                    apiCallTimeDifference = response.ResponseData.setTime
                }
                
                if response.ResponseData.supportTitle.trim.count > 0 {
                    supportTitle = response.ResponseData.supportTitle
                }
                
                if response.ResponseData.supportText.trim.count > 0 {
                    supportText = response.ResponseData.supportText
                }
                
                if response.ResponseData.supportEmail.trim.count > 0 {
                    supportEmail = response.ResponseData.supportEmail
                }
                
                self.handleAppUpdatePopup()
            } else {
                self.handleRedirection()
            }
        }
    }
    
}

extension CountryListVC {
    
    // Country List API Call
    func callCountryListAPI() {
        APICallManager.sharedInstance.callAPI(router: APIRouter.countrylist) { (response : CountrylistModel) in
            if response.ResponseCode == "200" {
                self.arrayCountry = response.ResponseData
                self.setupData()
            }
        }
    }
    
}


extension OTPVC {
    
    // Auth (Verify) OTP API Call
    func callAuthOTPAPI(otp : String) {
        var parameters = [String:String]()
        
        let traits = ["name":strName,
                      "phone":"+" + selectedCountry.Code + strMobile,
                      "mobileNo":strMobile,
                      "email":strEmail,
                      "countryCode":selectedCountry.Code,
                      "countryName":selectedCountry.Name,
                      "countryShortName":selectedCountry.ShortName,
                      "source":signUpFlag == "1" ? "SigUp" : "Login"]
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.OTP_Entered, traits: traits)
        
        if signUpFlag == "1" {
            parameters = [
                "OTP":otp,
                "DeviceID":DEVICE_UUID,
                "DeviceType":APP_TYPE,
                "CountryCode":selectedCountry.Code,
                "MobileNo":strMobile,
                "SignupFlag":signUpFlag,
                "Token":FCM_TOKEN,
                "Name":strName,
                "Email":strEmail
            ]
        } else {
            parameters = [
                "OTP":otp,
                "DeviceID":DEVICE_UUID,
                "DeviceType":APP_TYPE,
                "CountryCode":selectedCountry.Code,
                "MobileNo":strMobile,
                "SignupFlag":signUpFlag,
                "Token":FCM_TOKEN
            ]
        }
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.authotp(parameters), displayHud: true, showToast: false) { (response : LoginModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                let userData = response.ResponseData
                if self.signUpFlag == "1" {
                    userData?.CoUserCount = "0"
                    userData?.isMainAccount = "1"
                }
                
                LoginDataModel.currentUser = userData
                if let coUserData = response.ResponseData?.toJsonData() {
                    CoUserDataModel.currentUser = CoUserDataModel(data: coUserData)
                }
                
                lockDownloads = response.ResponseData?.Islock ?? ""
                
                // Segment Tracking
                if let userDetails = response.ResponseData {
                    // Segment - Identify User
                    if userDetails.CoUserCount == "0" {
                        SegmentTracking.shared.identifyUser()
                    } else if self.signUpFlag == "1" {
                        SegmentTracking.shared.identifyUser()
                    }
                    
                    let traits = ["name":userDetails.Name,
                                  "phone":"+" + self.selectedCountry.Code + userDetails.Mobile,
                                  "mobileNo":userDetails.Mobile,
                                  "email":userDetails.Email,
                                  "countryCode":self.selectedCountry.Code,
                                  "countryName":self.selectedCountry.Name,
                                  "countryShortName":self.selectedCountry.ShortName]
                    let eventname = self.signUpFlag == "1" ? SegmentTracking.eventNames.User_Sign_up : SegmentTracking.eventNames.User_Login
                    SegmentTracking.shared.trackGeneralEvents(name: eventname, traits: traits)
                }
                
                if self.signUpFlag == "1" {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass:EmailVerifyVC.self)
                    self.navigationController?.pushViewController(aVC, animated: true)
                } else {
                    self.handleCoUserRedirection()
                }
            } else {
                self.lblError.text = response.ResponseMessage
                self.lblError.isHidden = false
            }
        }
    }
    
}

extension UserListVC {
    
    // User List API Call
    func callUserListAPI() {
        arrayUsers.removeAll()
        tableView.reloadData()
        buttonEnableDisable()
        
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentMainAccountId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.userlist(parameters)) { (response : UserListModel) in
            if response.ResponseCode == "200" {
                self.arrayUsers = response.ResponseData.UserList
                self.tableView.reloadData()
                self.maxUsers = Int(response.ResponseData.Maxuseradd) ?? 0
                self.totalUserCount = Int(response.ResponseData.totalUserCount) ?? 0
                self.setupData()
                
                // Segment Tracking
                self.trackScreenData()
            } else {
                self.setupData()
            }
        }
    }
    
}

extension PinVC {
    
    // Verify Pin API Call
    func callVerifyPinAPI() {
        let strCode = txtFPin1.text! + txtFPin2.text! + txtFPin3.text! + txtFPin4.text!
        let parameters = [APIParameters.UserId:selectedUser?.UserId ?? "",
                          "Pin":strCode]
        
        let lastUserID = CoUserDataModel.currentUserId
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.verifypin(parameters)) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                self.dismiss(animated: false, completion: nil)
                
                CoUserDataModel.currentUser = response.ResponseData
                
                if lastUserID.trim.count > 0 {
                    CoUserDataModel.lastUserID = lastUserID
                }
                
                lockDownloads = response.ResponseData?.Islock ?? ""
                
                // Segment Tracking
                SegmentTracking.shared.coUserEvent(name: SegmentTracking.eventNames.User_Login, trackingType: .track)
                
                // Segment - Identify User
                SegmentTracking.shared.identifyUser()
                
                // Clear Last User Data
                AccountVC.clearUserData()
                showAlertToast(message: "You're in, \(CoUserDataModel.currentUser?.Name ?? "Guest") Let's explore your path to inner peace!")
                
                self.pinVerified?()
            } else {
                showAlertToast(message: response.ResponseMessage)
            }
        }
    }
    
}

extension ProfileForm6VC {
    
    // Profile Answer Save API Call
    func callProfileAnsSaveAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "gender":ProfileFormModel.shared.gender,
                          "genderX":ProfileFormModel.shared.genderX,
                          "dob":ProfileFormModel.shared.dob.dateString(format: Theme.dateFormats.DOB_Backend),
                          "prevDrugUse":ProfileFormModel.shared.prevDrugUse,
                          "Medication":ProfileFormModel.shared.Medication]
        
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.profilesaveans(parameters)) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                let userData = CoUserDataModel.currentUser
                userData?.isProfileCompleted = "1"
                userData?.DOB = ProfileFormModel.shared.dob
                CoUserDataModel.currentUser = userData
                
                // Segment Tracking
                let traits = ["gender":ProfileFormModel.shared.gender,
                              "genderX":ProfileFormModel.shared.genderX,
                              "dob":ProfileFormModel.shared.dob,
                              "prevDrugUse":ProfileFormModel.shared.prevDrugUse,
                              "medication":ProfileFormModel.shared.Medication]
                SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Profile_Form_Submitted, traits: traits)
                
                // Segment - Identify User
                SegmentTracking.shared.identifyUser()
                
                // Reset Profile Data
                ProfileFormModel.shared = ProfileFormModel()
                
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        }
    }
    
}

extension AssessmentVC {
    
    // Fetch Dass Assessment Questions API Call
    func callAssessmentAPI() {
        APICallManager.sharedInstance.callAPI(router: APIRouter.assesmentquestionlist) { (response : AssessmentQueAPIModel) in
            if response.ResponseCode == "200" {
                self.dicAssessment = response.ResponseData
                self.setupData()
            }
        }
    }
    
    // Save Dass Assessment Answers API Call
    func callSaveAnsAssessmentAPI(arrAns:String) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "ans":arrAns]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.assesmentsaveans(parameters)) { (response : AssessmentModel) in
            if response.ResponseCode == "200" {
                let userData = CoUserDataModel.currentUser
                userData?.isAssessmentCompleted = "1"
                userData?.indexScore = response.ResponseData?.indexScore ?? "0"
                userData?.ScoreLevel = response.ResponseData?.ScoreLevel ?? ""
                CoUserDataModel.currentUser = userData
                
                if let assessmentData = response.ResponseData {
                    var improvementFromPreviousSession = assessmentData.IndexScoreDiff + "%"
                    if assessmentData.ScoreIncDec == "Increase" {
                        improvementFromPreviousSession = "+" + assessmentData.IndexScoreDiff + "%"
                    } else if assessmentData.ScoreIncDec == "Decrease" {
                        improvementFromPreviousSession = "-" + assessmentData.IndexScoreDiff + "%"
                    }
                    
                    // Segment Tracking
                    let traits = ["wellnessScore":assessmentData.indexScore,
                                  "scoreLevel":assessmentData.ScoreLevel,
                                  "totalAssessmentsTaken":assessmentData.TotalAssesment,
                                  "numberOfDaysFromLastassessmentstaken":assessmentData.DaysfromLastAssesment,
                                  "improvementFromPreviousSession":improvementFromPreviousSession]
                    SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Assessment_Form_Submitted, traits: traits)
                }
                
                // Segment - Identify User
                SegmentTracking.shared.identifyUser()
                
                showAlertToast(message: response.ResponseMessage)
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
                aVC.isFromEdit = self.isFromEdit
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        }
    }
    
}

extension DassAssessmentResultVC {
    
    // Get Assessment Details API Call
    func callAssesmentGetDetailsAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.assesmentgetdetails(parameters)) { (response :AssessmentModel) in
            
            if response.ResponseCode == "200" {
                self.assessmentData = response.ResponseData
                self.setupData()
            }
        }
    }
}


extension UIViewController {
    
    // Get Co User Details API Call
    func callGetCoUserDetailsAPI(complitionBlock : ((Bool) -> ())?) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getcouserdetails(parameters), displayHud: false) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                CoUserDataModel.currentUser = response.ResponseData
                
                // Segment - Identify User
                if SegmentTracking.shared.userIdentityTracked == false {
                    SegmentTracking.shared.identifyUser()
                }
                
                lockDownloads = response.ResponseData?.Islock ?? ""
                
                DispatchQueue.main.async {
                    complitionBlock?(true)
                }
            } else {
                // CoUserDataModel.currentUser = nil
                DispatchQueue.main.async {
                    complitionBlock?(false)
                }
            }
        }
    }
    
    // Log Out API Call
    func callLogoutAPI(complitionBlock : (() -> ())?) {
        let parameters = [APIParameters.UserId:LoginDataModel.currentUserId,
                          "Token":FCM_TOKEN,
                          "DeviceType":APP_TYPE]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.logout(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                SegmentTracking.shared.coUserEvent(name: SegmentTracking.eventNames.User_Logged_Out, trackingType: .track)
                complitionBlock?()
            } else {
                complitionBlock?()
            }
        }
    }
    
    // Add Audio to Recently Played API Call
    func callRecentlyPlayedAPI(audioID : String, complitionBlock : (() -> ())?) {
        if audioID.trim.count == 0 || DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
            return
        }
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "AudioId":audioID]
        APICallManager.sharedInstance.callAPI(router: APIRouter.recentlyplayed(parameters), displayHud: false) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                refreshAudioData = true
                complitionBlock?()
            }
        }
    }
    
    // Delete Playlist API Call
    func callDeletePlaylistAPI(objPlaylist : PlaylistDetailsModel, complitionBlock : (() -> ())?) {
        // Segment Tracking
        SegmentTracking.shared.playlistDetailEvents(name: SegmentTracking.eventNames.Delete_Playlist_Clicked, objPlaylist: objPlaylist, trackingType: .track)
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":objPlaylist.PlaylistID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.deleteplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                refreshPlaylistData = true
                showAlertToast(message: response.ResponseMessage)
                DispatchQueue.main.async {
                    complitionBlock?()
                }
                
                // Segment Tracking
                SegmentTracking.shared.playlistDetailEvents(name: SegmentTracking.eventNames.Playlist_Deleted, objPlaylist: objPlaylist, trackingType: .track)
            }
        }
    }
    
    // Resource List API Call
    func callResourceListAPI(resourceID : String, complitionBlock : (() -> ())?) {
        var CategoryName = ResourceVC.selectedCategory
        
        if ResourceVC.selectedCategory == "All" {
            CategoryName = ""
        }
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "ResourceTypeId":resourceID,
                          "Category":CategoryName]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.resourcelist(parameters)) { (response : ResourceListModel) in
            
            if response.ResponseCode == "200" && response.ResponseData != nil {
                switch resourceID {
                case ResourcesType.documentaries.rawValue:
                    ResourceVC.documentariesData = response.ResponseData!
                case ResourcesType.podcasts.rawValue:
                    ResourceVC.podcastData = response.ResponseData!
                case ResourcesType.websites.rawValue:
                    ResourceVC.websiteData = response.ResponseData!
                case ResourcesType.apps.rawValue:
                    ResourceVC.appsData = response.ResponseData!
                default:
                    ResourceVC.audioData = response.ResponseData!
                }
                complitionBlock?()
            } else {
                switch resourceID {
                case ResourcesType.documentaries.rawValue:
                    ResourceVC.documentariesData = [ResourceListDataModel]()
                case ResourcesType.podcasts.rawValue:
                    ResourceVC.podcastData = [ResourceListDataModel]()
                case ResourcesType.websites.rawValue:
                    ResourceVC.websiteData = [ResourceListDataModel]()
                case ResourcesType.apps.rawValue:
                    ResourceVC.appsData = [ResourceListDataModel]()
                default:
                    ResourceVC.audioData = [ResourceListDataModel]()
                }
                complitionBlock?()
            }
        }
    }
    
    // Login / SignUp API Call
    func callLoginAPI(signUpFlag:String, country:CountrylistDataModel, mobileNo:String, username:String, email:String, resendOTP : String, complitionBlock : ((SendOTPModel) -> ())?) {
        let parameters = ["DeviceType":APP_TYPE,
                          "CountryCode":country.Code,
                          "MobileNo":mobileNo,
                          "Email":email,
                          "SignupFlag":signUpFlag,
                          "key":"1"]
        
        // Segment Tracking
        let traits = ["name":username,
                      "phone":"+" + country.Code + mobileNo,
                      "mobileNo":mobileNo,
                      "email":email,
                      "countryCode":country.Code,
                      "countryName":country.Name,
                      "countryShortName":country.ShortName,
                      "source":signUpFlag == "1" ? "SignUp" : "Login"]
        
        let eventname = resendOTP == "1" ? SegmentTracking.eventNames.Resend_OTP_Clicked : SegmentTracking.eventNames.Send_OTP_Clicked
        SegmentTracking.shared.trackGeneralEvents(name: eventname, traits: traits)
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.loginsignup(parameters), displayHud: true, showToast: false) { (response : SendOTPModel) in
            if response.ResponseCode == "200" {
                if resendOTP != "1" {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass:OTPVC.self)
                    aVC.signUpFlag = signUpFlag
                    aVC.strName = username
                    aVC.selectedCountry = country
                    aVC.strMobile = mobileNo
                    aVC.strEmail = email
                    self.navigationController?.pushViewController(aVC, animated: true)
                }
                
                complitionBlock?(response)
            }else if response.ResponseCode == "401" {
                showAlertToast(message: response.ResponseMessage)
                if response.ResponseData?.signup == "1" {
                    if response.ResponseMessage != "Please enter a valid mobile number" {
                        let aVC = AppStoryBoard.main.viewController(viewControllerClass:SignUpVC.self)
                        aVC.selectedCountry = country
                        aVC.strMobile = mobileNo
                        aVC.isCountrySelected = true
                        self.navigationController?.pushViewController(aVC, animated: true)
                    }
                }
                
            }else {
                complitionBlock?(response)
            }
        }
    }
    
    // IAP Verify Reciept API Call
    func callVerifyRecieptAPI(strreceiptData : String, complitionBlock : (() -> ())?) {
            let parameters = ["receiptData":strreceiptData]
            
            APICallManager.sharedInstance.callAPI(router: APIRouter.verifyreceipt(parameters), displayHud: false, showToast: false) { (response : GeneralModel) in
                if response.ResponseCode == "200" {
                    DispatchQueue.main.async {
                        complitionBlock?()
                    }
                }
            }
        }
    
    // Forgot Pin API Call
    func callForgotPinAPI(selectedUser : CoUserDataModel, complitionBlock : (() -> ())?) {
        let parameters = [APIParameters.UserId:selectedUser.UserId,
                          "Email":selectedUser.Email]
        
        // Segment Tracking
        let traits : [String:Any] = ["userId":selectedUser.UserId,
                                     "userGroupId":LoginDataModel.currentMainAccountId,
                                     "isAdmin":selectedUser.isAdminUser,
                                     "name":selectedUser.Name,
                                     "mobileNo":selectedUser.Mobile,
                                     "email":selectedUser.Email]
        SegmentTracking.shared.trackEvent(name: SegmentTracking.eventNames.Forgot_Pin_Clicked, traits: traits, trackingType: .track)
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.forgotpin(parameters)) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                complitionBlock?()
            } else {
                showAlertToast(message: response.ResponseMessage)
            }
        }
    }
    
    // Get Co User Details API Call
    func callSendPaymentLinkAPI(complitionBlock : ((Bool) -> ())?) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          APIParameters.MainAccountID:LoginDataModel.currentMainAccountId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.sendpaymentlink(parameters), showToast: false) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                DispatchQueue.main.async {
                    complitionBlock?(true)
                }
            } else {
                DispatchQueue.main.async {
                    complitionBlock?(false)
                }
            }
        }
    }
    
}

extension ManageVC {
    
    // Manage Home API Call
    func callManageHomeAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.managehomescreen(parameters)) { (response : ManageHomeModel) in
            if response.ResponseCode == "200" {
                if let responseData = response.ResponseData {
                    lockDownloads = response.ResponseData?.Islock ?? ""
                    self.suggstedPlaylist = responseData.SuggestedPlaylist
                    self.arrayAudioHomeData = responseData.Audio
                    self.arrayPlaylistHomeData = responseData.Playlist
                    
                    for data in self.arrayAudioHomeData {
                        if data.View == Theme.strings.my_downloads {
                            data.Details = CoreDataHelper.shared.fetchSingleAudios()
                        }
                    }
                    
                    if lockDownloads == "1" {
                        if isAudioPlayerClosed == false {
                            self.clearAudioPlayer()
                            isAudioPlayerClosed = true
                        }
                    }
                    
                    if let playlistData = self.suggstedPlaylist {
                        // Delete Suggested Playlist if updated
                        CoreDataHelper.shared.deleteSuggestedPlaylist(newPlaylist: playlistData)
                        
                        // Clear Audio Player if Suggested Playlist updated
                        self.clearAudioPlayerForSuggestedPlaylist(newPlaylist: playlistData)
                    }
                    
                    self.setupData()
                    
                    // Segment Tracking
                    self.trackScreenData()
                }
            }
        }
    }
    
}

extension ViewAllAudioVC {
    
    // Get All Audio API Call
    @objc func callViewAllAudioAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "GetHomeAudioId":libraryId,
                          "CategoryName":categoryName]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.managehomeviewallaudio(parameters)) { (response : AudioViewAllModel) in
            
            if response.ResponseCode == "200", let responseData = response.ResponseData {
                self.homeData = responseData
                self.objCollectionView.reloadData()
                
                // Segment Tracking
                self.trackScreenData()
            }
        }
    }
    
}

extension PlaylistCategoryVC {
    
    // Playlist Library API Call
    @objc func callPlaylistLibraryAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.playlistlibrary(parameters)) { (response : PlaylistHomeModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlaylistHomeData = response.ResponseData
                for data in self.arrayPlaylistHomeData {
                    if data.View == Theme.strings.my_downloads {
                        data.Details = CoreDataHelper.shared.fetchAllPlaylists()
                    }
                }
                self.tableView.reloadData()
                self.setupData()
                // Segment Tracking
                self.trackScreenData()
            }
        }
    }
    
}

extension ViewAllPlaylistVC {
    
    // Playlist On Get Library API Call
    @objc func callPlaylistOnGetLibraryAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "GetLibraryId":libraryId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.playlistonviewall(parameters)) { (response : PlaylistLibraryModel) in
            
            if response.ResponseCode == "200", let responseData = response.ResponseData {
                self.homeData = responseData
                self.objCollectionView.reloadData()
                
                // Segment Tracking
                self.trackScreenData()
            }
        }
    }
    
}

extension CreatePlaylistVC {
    
    // Create Playlist API Call
    func callCreatePlaylistAPI(PlaylistName : String) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistName":PlaylistName]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.createplaylist(parameters)) { (response : CreatePlaylistModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                if let id = response.ResponseData?.PlaylistID, let name = response.ResponseData?.PlaylistName {
                    let playlistDetails = PlaylistDetailsModel()
                    playlistDetails.PlaylistID = id
                    playlistDetails.PlaylistName = name
                    playlistDetails.Created = "1"
                    playlistDetails.TotalAudio = "1"
                    
                    if self.playlistToAdd.trim.count > 0 || self.audioToAdd.trim.count > 0 {
                        self.delegate?.didCreateNewPlaylist(createdPlaylistID: id)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        refreshPlaylistData = true
                        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
                        aVC.objPlaylist = playlistDetails
                        self.navigationController?.pushViewController(aVC, animated: true)
                    }
                    
                    // Segment Tracking
                    SegmentTracking.shared.playlistDetailEvents(name: SegmentTracking.eventNames.Playlist_Created, objPlaylist: playlistDetails, source: self.source, trackingType: .track)
                }
            }
        }
    }
    
    // Rename Playlist API Call
    func callRenamePlaylistAPI(PlaylistName : String) {
        guard let playlistDetails = objPlaylist else {
            return
        }
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":playlistDetails.PlaylistID,
                          "PlaylistNewName":PlaylistName]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.renameplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                refreshPlaylistData = true
                self.navigationController?.popViewController(animated: true)
                showAlertToast(message: response.ResponseMessage)
                
                // Segment Tracking
                playlistDetails.PlaylistName = PlaylistName
                SegmentTracking.shared.playlistDetailEvents(name: SegmentTracking.eventNames.Playlist_Renamed, objPlaylist: playlistDetails, source: self.source, trackingType: .track)
            }
        }
    }
    
}

extension PlaylistAudiosVC {
    
    // Playlist Detail API Call
    @objc func callPlaylistDetailAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":objPlaylist!.PlaylistID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.playlistdetails(parameters)) { (response : PlaylistDetailsAPIModel) in
            
            if response.ResponseCode == "200" && response.ResponseData != nil {
                self.objPlaylist = response.ResponseData
                self.objPlaylist?.sectionName = self.sectionName
                self.setupData()
                if let playlistID = self.objPlaylist?.PlaylistID, let arraySongs = self.objPlaylist?.PlaylistSongs {
                    refreshNowPlayingSongs(playlistID: playlistID, arraySongs: arraySongs)
                }
            }
        }
    }
    
    // Remove Audio From Playlist API Call
    func callRemoveAudioFromPlaylistAPI(index : Int) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":arraySearchSongs[index].PlaylistID,
                          "AudioId":arraySearchSongs[index].ID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.removeaudiofromplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                // Segment Tracking
                SegmentTracking.shared.playlistEvents(name: SegmentTracking.eventNames.Audio_Removed_From_Playlist, objPlaylist: self.objPlaylist, passPlaybackDetails: true, passPlayerType: true, audioData: self.arraySearchSongs[index], trackingType: .track)
                
                if let indexToDelete = self.objPlaylist?.PlaylistSongs.firstIndex(of: self.arraySearchSongs[index]) {
                    self.objPlaylist?.PlaylistSongs.remove(at: indexToDelete)
                }
                self.tableView.reloadData()
                self.setupData()
                self.callPlaylistDetailAPI()
                showAlertToast(message: response.ResponseMessage)
            }
        }
    }
    
    // Playlist Audio Sorting API Call
    func callSortingPlaylistAudioAPI(audioIds : String) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":objPlaylist!.PlaylistID,
                          "PlaylistAudioId":audioIds]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.sortingplaylistaudio(parameters)) { (response : PlaylistDetailsAPIModel) in
            
            if response.ResponseCode == "200" && response.ResponseData != nil {
                showAlertToast(message: response.ResponseMessage)
                self.callPlaylistDetailAPI()
            }
        }
    }
    
}

extension PlaylistDetailVC {
    
    // Playlist Detail API Call
    @objc func callPlaylistDetailAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":objPlaylist!.PlaylistID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.playlistdetails(parameters)) { (response : PlaylistDetailsAPIModel) in
            
            if response.ResponseCode == "200" && response.ResponseData != nil {
                self.objPlaylist = response.ResponseData
                self.objPlaylist?.sectionName = self.sectionName
                self.setupData()
            }
        }
    }
    
}

extension AddToPlaylistVC {
    
    // My Playlist API Call
    func callMyPlaylistAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getcreatedplaylist(parameters)) { (response : PlaylistListingModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlaylist = response.ResponseData
                if self.playlistID.trim.count > 0 {
                    self.arrayPlaylist = self.arrayPlaylist.filter { $0.PlaylistID != self.playlistID }
                }
                self.tableView.reloadData()
            }
            
            // Segment Tracking
            self.trackScreenData()
        }
    }
    
    // Add Audio to Playlist API Call
    func callAddAudioToPlaylistAPI(playlistID : String) {
        self.view.endEditing(true)
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":playlistID,
                          "AudioId":self.audioID,
                          "FromPlaylistId":self.playlistID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.addaptoplaylist(parameters)) { (response : AudioDetailsModel) in
            
            if response.ResponseCode == "200" {
                self.showGoToPlaylistPopUp()
            }
        }
    }
    
}

extension AudioDetailVC {
    
    // Audio Detail API Call
    func callAudioDetailsAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "AudioId":(audioDetails?.ID ?? "")]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.audiodetail(parameters)) { (response : AudioDetailsModel) in
            
            if response.ResponseCode == "200" {
                guard  let audioData = response.ResponseData.first else {
                    return
                }
                audioData.PlaylistID = self.audioDetails?.PlaylistID ?? ""
                audioData.selfCreated = self.audioDetails?.selfCreated ?? ""
                self.audioDetails = audioData
                self.setupData()
            }
        }
    }
    
    // Remove Audio From Playlist API Call
    func callRemoveAudioFromPlaylistAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":audioDetails!.PlaylistID,
                          "AudioId":audioDetails!.ID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.removeaudiofromplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                let playlistID = self.audioDetails!.PlaylistID
                
                self.handleRemoveFromPlaylist()
                showAlertToast(message: response.ResponseMessage)
                
                self.callPlaylistDetailAPI(playlistId: playlistID)
                
                self.dismiss(animated: true) {
                    self.didClosePlayerDetail?()
                }
            } else {
                self.handleRemoveFromPlaylist()
            }
        }
    }
    
    func handleRemoveFromPlaylist() {
        refreshPlaylistData = true
        NotificationCenter.default.post(name: .refreshPlaylist, object: nil)
        
        self.audioDetails!.PlaylistID = ""
        self.setupData()
    }
    
    // Playlist Detail API Call
    @objc func callPlaylistDetailAPI(playlistId : String) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":playlistId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.playlistdetails(parameters)) { (response : PlaylistDetailsAPIModel) in
            
            if response.ResponseCode == "200" && response.ResponseData != nil {
                let objPlaylist = response.ResponseData
                if let playlistID = objPlaylist?.PlaylistID, let arraySongs = objPlaylist?.PlaylistSongs {
                    refreshNowPlayingSongs(playlistID: playlistID, arraySongs: arraySongs)
                }
            }
        }
    }
    
}

extension AddAudioVC {
    
    // Audio List API Call
    func callAudioAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "playlistId":playlistID]
        APICallManager.sharedInstance.callAPI(router: APIRouter.suggestedaudio(parameters)) { (response :AudioDetailsModel) in
            
            if response.ResponseCode == "200" {
                self.arrayAudio = response.ResponseData
                self.setupData()
            }
            
            // self.callPlaylistAPI()
        }
    }
    
    // Playlist List API Call
    func callPlaylistAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        APICallManager.sharedInstance.callAPI(router: APIRouter.suggestedplaylist(parameters)) { (response :PlaylistListingModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlayList = response.ResponseData
                self.setupData()
            }
        }
    }
    
    // Search Audio / Playlist API Call
    func callSearchAPI(searchText : String) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "SuggestedName":searchText,
                          "playlistId":playlistID ]
        
        // Segment Tracking
        let traits = ["source":isComeFromAddAudio ? "Add Audio Screen" : "Search Screen",
                      "searchKeyword":searchText]
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Audio_Searched, traits: traits)
        
        APICallManager.sharedInstance.apiRequest?.cancel()
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.searchonsuggestedlist(parameters)) { (response : AudioDetailsModel) in
            
            self.arraySearch.removeAll()
            if response.ResponseCode == "200" {
                self.arraySearch.removeAll()
                if (self.txtSearch.text?.trim.count ?? 0) > 0 {
                    self.arraySearch = response.ResponseData.filter { $0.Iscategory == "1" }
                }
                self.reloadSearchData()
            } else {
                self.arraySearch.removeAll()
                self.reloadSearchData()
            }
        }
    }
    
    // Add Audio to Playlist API Call
    func callAddAudioToPlaylistAPI(audioToAdd : String = "" , playlistToAdd : String = "") {
        self.view.endEditing(true)
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":self.playlistID,
                          "AudioId":audioToAdd,
                          "FromPlaylistId":playlistToAdd]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.addaptoplaylist(parameters)) { (response : AudioDetailsModel) in
            
            if response.ResponseCode == "200" {
                refreshNowPlayingSongs(playlistID: self.playlistID, arraySongs: response.ResponseData)
                showAlertToast(message: response.ResponseMessage)
            }
        }
    }
    
}

extension AreaOfFocusVC {
    
    // Fetch Recommended Category list
    func callGetRecommendedCategoryAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getrecommendedcategory(parameters)) { (response :CategoryModel) in
            
            if response.ResponseCode == "200" {
                self.arrayCategoriesMain = response.ResponseData
                self.arrayCategories = response.ResponseData
                self.tableView.reloadData()
                self.footerCollectionview.reloadData()
                self.setInitialData()
            }
        }
    }
    
    // Save Category & Sleep Time API Call
    func callSaveCategoryAPI(areaOfFocus : [[String:Any]]) {
        let parameters : [String : Any] = [APIParameters.UserId:CoUserDataModel.currentUserId,
                                           "AvgSleepTime":self.averageSleepTime,
                                           "CatName":areaOfFocus.toJSON() ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.saverecommendedcategory(parameters), showToast: false) { (response :SaveCategoryModel) in
            
            if response.ResponseCode == "200" {
                let userData = CoUserDataModel.currentUser
                userData?.AvgSleepTime = response.ResponseData?.AvgSleepTime ?? "0"
                userData?.AreaOfFocus = response.ResponseData?.AreaOfFocus ?? [AreaOfFocusModel]()
                CoUserDataModel.currentUser = userData
                
                // Segment Tracking
                self.trackAreaOfFocusSavedEvent(numberOfUpdation: response.ResponseData?.NoUpdation ?? "")
                
                // Segment - Identify User
                SegmentTracking.shared.identifyUser()
                
                if let playlistData = response.ResponseData?.SuggestedPlaylist {
                    // Delete Suggested playlist if updated
                    CoreDataHelper.shared.deleteSuggestedPlaylist(newPlaylist: playlistData)
                    
                    // Clear Audio Player if Suggested Playlist updated
                    self.clearAudioPlayerForSuggestedPlaylist(newPlaylist: playlistData)
                }
                
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: PreparingPlaylistVC.self)
                aVC.isFromEdit = self.isFromEdit
                self.navigationController?.pushViewController(aVC, animated: true)
            } else {
                if let responseData = response.ResponseData, responseData.showAlert == "1" {
                    self.showAlertForChangeSleepTime(data: responseData)
                } else {
                    showAlertToast(message: response.ResponseMessage)
                }
            }
        }
    }
    
}

extension SleepTimeVC {
    
    // Fetch Sleep Time API Call
    func callSleepTimetAPI() {
        APICallManager.sharedInstance.callAPI(router: APIRouter.avgsleeptime) { (response : AverageSleepTimeModel) in
            if response.ResponseCode == "200" {
                self.arrayTimes = response.ResponseData
                if let data = self.arrayTimes.enumerated().first(where: {$0.element.Name == CoUserDataModel.currentUser?.AvgSleepTime}) {
                    data.element.isSelected = true
                }
                self.collectionViewSleepTime.reloadData()
            }
        }
    }
}

extension ManagePlanListVC {
    
    // Fetch Plan List & Other Data API Call
    func callManagePlanListAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        APICallManager.sharedInstance.callAPI(router: APIRouter.planlist(parameters)) { (response :PlanListModel) in
            
            if response.ResponseCode == "200" {
                self.dataModel = response.ResponseData
                self.setupData()
                self.fetchIAPProducts()
            }
        }
    }
    
    func fetchIAPProducts() {
        if IAPHelper.shared.isIAPEnabled {
            let arrayProductIDs : [String] = dataModel.Plan.compactMap({ $0.IOSplanId })
            
            // IAP Purchase Retrive Products
            IAPHelper.shared.productRetrive(arrayProductIDs: arrayProductIDs) { (success, iapProducts) in
                if success {
                    guard let products = iapProducts else {
                        self.setupData()
                        return
                    }
                    
                    print("IAP Products Fetched")
                    for product in products {
                        for plan in self.dataModel.Plan {
                            if plan.IOSplanId == product.iapProductIdentifier {
                                plan.iapProductIdentifier = product.iapProductIdentifier
                                plan.iapPrice = product.iapPrice
                                plan.iapTitle = product.iapTitle
                                plan.iapDescription = product.iapDescription
                                plan.iapTrialPeriod = product.iapTrialPeriod
                                plan.iapSubscriptionPeriod = product.iapSubscriptionPeriod
                            }
                        }
                    }
                    
                    self.setupData()
                }
            }
        }
    }
    
}

extension AddAudioViewAllVC {
    
    // Playlist List API Call
    func callPlaylistAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        APICallManager.sharedInstance.callAPI(router: APIRouter.suggestedplaylist(parameters)) { (response :PlaylistListingModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlayList = response.ResponseData
                self.setupData()
                
                // Segment Tracking
                self.trackScreenData()
            }
        }
    }
    
    // Add Audio to Playlist API Call
    func callAddAudioToPlaylistAPI(audioToAdd : String = "" , playlistToAdd : String = "") {
        self.view.endEditing(true)
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":self.playlistID,
                          "AudioId":audioToAdd,
                          "FromPlaylistId":playlistToAdd]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.addaptoplaylist(parameters)) { (response : AudioDetailsModel) in
            
            if response.ResponseCode == "200" {
                refreshNowPlayingSongs(playlistID: self.playlistID, arraySongs: response.ResponseData)
                showAlertToast(message: response.ResponseMessage)
            }
        }
    }
    
}

extension UserListPopUpVC {
    
    // User List API Call
    func callUserListAPI() {
        arrayUsers.removeAll()
        tableView.reloadData()
        
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentMainAccountId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.userlist(parameters)) { (response : UserListModel) in
            if response.ResponseCode == "200" {
                self.arrayUsers = response.ResponseData.UserList
                self.tableView.reloadData()
                self.maxUsers = Int(response.ResponseData.Maxuseradd) ?? 0
                self.totalUserCount = Int(response.ResponseData.totalUserCount) ?? 0
                self.setupData()
                
                // Segment Tracking
                self.trackScreenData()
            } else {
                self.setupData()
            }
        }
    }
    
}

extension NotificatonVC {
    
    // Notification List API Call
    func callNotificationListAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getnotificationlist(parameters)) { (response : NotificationListModel) in
            if response.ResponseCode == "200" {
                self.arrayNotifications = response.ResponseData
                self.tableView.reloadData()
                self.setupData()
            } else {
                self.setupData()
            }
        }
    }
    
}

extension ResourceVC {
    
    // Resource Category List API Call
    func callResourceCategoryListAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.resourcecatlist(parameters)) { (response : ResourceCategoryModel) in
            
            if response.ResponseCode == "200" && response.ResponseData != nil {
                ResourceVC.arrayCategories = response.ResponseData!
                let all = ResourceCategoryDataModel()
                all.CategoryName = "All"
                ResourceVC.arrayCategories.insert(all, at: 0)
                ResourceVC.selectedCategory.removeAll()
                self.setUpPageMenu()
                self.setupData()
            }
            else {
                ResourceVC.arrayCategories = [ResourceCategoryDataModel]()
                self.setUpPageMenu()
            }
        }
    }
}

extension HomeVC {
    
    // Home API Call
    func callHomeAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "localTimezone":TimeZone.current.identifier]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.homescreen(parameters)) { (response : HomeModel) in
            if response.ResponseCode == "200" {
                self.tableView.isHidden = false
                
                let userData = CoUserDataModel.currentUser
                userData?.indexScore = response.ResponseData.IndexScore
                CoUserDataModel.currentUser = userData
                
                lockDownloads = response.ResponseData.Islock
                self.shouldCheckIndexScore = response.ResponseData.shouldCheckIndexScore
                self.IndexScoreDiff = response.ResponseData.IndexScoreDiff
                self.ScoreIncDec = response.ResponseData.ScoreIncDec
                self.suggstedPlaylist = response.ResponseData.SuggestedPlaylist
                self.arrayGraphIndexScore = response.ResponseData.GraphIndexScore
                self.arraySessionScore = response.ResponseData.SessionScore
                self.arraySessionProgress = response.ResponseData.SessionProgress
                self.arrayGraphActivity = response.ResponseData.GraphAnalytics
                self.dictHome = response.ResponseData
                
                if lockDownloads == "1" {
                    if isAudioPlayerClosed == false {
                        self.clearAudioPlayer()
                        isAudioPlayerClosed = true
                    }
                }
                
                if let playlistData = self.suggstedPlaylist {
                    // Delete Suggested playlist if updated
                    CoreDataHelper.shared.deleteSuggestedPlaylist(newPlaylist: playlistData)
                    
                    // Clear Audio Player if Suggested Playlist updated
                    self.clearAudioPlayerForSuggestedPlaylist(newPlaylist: playlistData)
                }
                
                if response.ResponseData.shouldPlayDisclaimer == "1" {
                    DisclaimerAudio.shared.shouldPlayDisclaimer = true
                }
                
                if let disclaimer = response.ResponseData.disclaimerAudio {
                    DisclaimerAudio.shared.disclaimerAudio = disclaimer
                }
                
                self.setupData()
                
                if response.ResponseData.IsFirst == "1" {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        let aVC = AppStoryBoard.home.viewController(viewControllerClass: ReminderPopUpVC.self)
                        aVC.suggstedPlaylist = self.suggstedPlaylist
                        let navVC = UINavigationController(rootViewController: aVC)
                        navVC.navigationBar.isHidden = true
                        navVC.modalPresentationStyle = .overFullScreen
                        self.present(navVC, animated: true, completion: nil)
                    }
                }
            } else {
                self.setupData()
            }
        }
    }
    
}

extension AccountVC {
    
    // Add Profile Image API
    func callAddProfileImageAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        var uploadData = [UploadDataModel]()
        if imageData.data != nil {
            uploadData = [imageData]
        }
        
        APICallManager.sharedInstance.callUploadWebService(apiUrl: APIRouter.updateprofileimg(parameters).urlRequest!.url!.absoluteString, includeHeader: true, parameters: parameters, uploadParameters: uploadData, httpMethod: .post) { (response : AddProfileImageModel) in
            
            if response.ResponseCode == "200" {
                self.imageData = UploadDataModel()
                showAlertToast(message: response.ResponseMessage)
                self.callGetCoUserDetailsAPI { (success) in
                    if success {
                        self.setupData()
                    }
                }
            }
        }
    }
    
    // Remove Profile Image API
    func callRemoveProfileImageAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.removeprofileimg(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                self.callGetCoUserDetailsAPI { (success) in
                    if success {
                        self.setupData()
                    }
                }
            }
        }
    }
    
}

extension ChangePINVC {
    
    // Change PIN API Call
    func callChangePinAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "OldPin":txtFOldPIN.text ?? "",
                          "NewPin":txtFConfirmPIN.text ?? ""]
        APICallManager.sharedInstance.callAPI(router: APIRouter.changepin(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                // Segment Tracking
                SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Login_Pin_Changed)
                
                showAlertToast(message: response.ResponseMessage)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension ChangePassWordVC {
    
    // Change Password API Call
    func callChangePasswordAPI() {
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentMainAccountId,
                          APIParameters.UserId:CoUserDataModel.currentUserId,
                          "OldPassword":txtfOldPassword.text ?? "",
                          "NewPassword":txtFConfirmPassword.text ?? ""]
        APICallManager.sharedInstance.callAPI(router: APIRouter.changepassword(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                // Segment Tracking
                SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Password_Changed)
                
                showAlertToast(message: response.ResponseMessage)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension FAQVC {
    
    // FAQ List API Call
    func callFAQListAPI() {
        APICallManager.sharedInstance.callAPI(router: APIRouter.faqlist) { (response : FAQListModel) in
            if response.ResponseCode == "200" {
                self.arrayFAQ = response.ResponseData
                self.setupData()
                
                // Segment Tracking
                let traits : [String:Any] = ["faqCategories":self.arrTitle]
                SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.faq_screen, traits: traits)
            } else {
                // Segment Tracking
                let traits : [String:Any] = ["faqCategories":self.arrTitle]
                SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.faq_screen, traits: traits)
            }
        }
    }
    
}

extension ReminderListVC {
    
    // Reminders List API Call
    func callRemListAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.reminderlist(parameters)) { (response :ReminderModel) in
            
            if response.ResponseCode == "200" {
                self.arrayRemList = response.ResponseData
                self.setupData()
                if self.arrayRemList.count > 0 {
                    self.lblNoData.isHidden = true
                    self.tableView.isHidden = false
                }else {
                    self.lblNoData.isHidden = false
                    self.lblNoData.text = "No data found"
                    self.tableView.isHidden = true
                }
                
                // Segment Tracking
                if self.shouldTrackScreen == false {
                    self.shouldTrackScreen = true
                    SegmentTracking.shared.trackReminderScreenViewed(arrayReminders: response.ResponseData)
                }
            }
        }
    }
    
    // Update Reminder Status API Call
    func callRemSatusAPI(status:String) {
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "ReminderStatus":status,
                          "PlaylistId":strRemID ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.reminderstatus(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                
                self.callRemListAPI()
                showAlertToast(message: response.ResponseMessage)
            
            }
        }
    }
    
    // Delete Reminder API Call
    func callRemDeleteAPI(remID:String) {

        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "ReminderId":remID]

        APICallManager.sharedInstance.callAPI(router: APIRouter.deletereminder(parameters)) { (response :GeneralModel) in

            if response.ResponseCode == "200" {
                
                self.callRemListAPI()
                self.setupData()
                showAlertToast(message: response.ResponseMessage)
            }
        }
    }
}

extension DayVC {
    
    // Set Reminder API Call
    func callSetRemAPI() {
        let strDay =  (arrSelectDays.map{String($0)}).joined(separator: ",")
        let time = lblTime.text?.localToUTC(incomingFormat: "h:mm a", outGoingFormat: "h:mm a") ?? ""
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":strPlaylistID ?? "",
                          "IsSingle":"1",
                          "ReminderTime":time,
                          "ReminderDay":strDay]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.setreminder(parameters)) { (response : GeneralModel) in

            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                self.setupData()
                self.tableView.reloadData()
                
                if self.isfromPopUp == true {
                    NotificationCenter.default.post(name: NSNotification.Name.refreshData, object: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension UIImageView {
    
    func loadUserProfileImage(fontSize : CGFloat) {
        self.image = nil
        
        if let userImage = CoUserDataModel.profileImage {
            self.image = userImage
            return
        }
        
        if let userData = CoUserDataModel.currentUser {
            DispatchQueue.global().async {
                if let imgUrl = URL(string: userData.Image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                    do {
                        let imageData = try Data(contentsOf: imgUrl)
                        let profileImage = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            CoUserDataModel.profileImage = profileImage
                            self.image = profileImage
                            if profileImage == nil {
                                self.setUserInitialProfileImage(user: CoUserDataModel.currentUser, fontSize: fontSize)
                            }
                        }
                    } catch {
                        print("Image Download Error : \(error.localizedDescription)")
                        self.setUserInitialProfileImage(user: CoUserDataModel.currentUser, fontSize: fontSize)
                    }
                } else {
                    self.setUserInitialProfileImage(user: CoUserDataModel.currentUser, fontSize: fontSize)
                }
            }
        }
    }
    
    func setUserInitialProfileImage(user : CoUserDataModel?, fontSize : CGFloat) {
        let userName = (user?.Name ?? "").trim.count > 0 ? (user?.Name ?? "") : "Guest"
        let nameInitial : String = "\(userName.first ?? "G")"
        self.setInitialProfileImage(initial: nameInitial, fontSize: fontSize)
    }
    
    func setInitialProfileImage(initial : String, fontSize : CGFloat) {
        DispatchQueue.main.async {
            self.setImageWith(initial, color: Theme.colors.blue_38667E, circular: false, textAttributes: [NSAttributedString.Key.font : UIFont(name: CustomFonts.MontserratSemiBold, size: fontSize) as Any, NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
}

extension EditProfileVC {
    
    // Update Profile Detail API Call
    func callUpdateProfileDetailAPI() {
        var DOB = selectedDOB.stringFromFormat(Theme.dateFormats.DOB_Backend)
        
        if txtFDOB.text?.trim.count == 0 {
            DOB = ""
        }
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          APIParameters.MainAccountID:LoginDataModel.currentMainAccountId,
                          "Name":txtFName.text!,
                          "Dob":DOB ,
                          "MobileNo":txtFMobileNo.text!,
                          "EmailId":txtFEmailAdd.text!]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.editprofile(parameters)) { (response : CoUserModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                self.callGetCoUserDetailsAPI { (success) in
                    if success {
                        self.setupData()
                        // self.navigationController?.popViewController(animated: true)
                        
                        // Segment Tracking
                        if let userData = CoUserDataModel.currentUser {
                            let userName = userData.Name.trim.count > 0 ? userData.Name : "Guest"
                            let dictUserDetails = ["name":userName,
                                                   "phone":"+" + userData.CountryCode + userData.Mobile,
                                                   "mobile":userData.Mobile,
                                                   "countryCode":userData.CountryCode,
                                                   "email":userData.Email,
                                                   "dob":userData.DOB]
                            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Profile_Changes_Saved, traits: dictUserDetails)
                        } else {
                            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Profile_Changes_Saved)
                        }
                        
                        // Segment - Identify User
                        SegmentTracking.shared.identifyUser()
                        
                        if response.ResponseData?.ageSlabChange == "1" {
                            self.presentEditSleepTimeScreen(hideCloseButton: true)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}

extension OrderSummaryVC {
    
    // IAP Plan Purchase API Call
    func callIAPPlanPurchaseAPI() {
        
        guard let receiptURL = Bundle.main.appStoreReceiptURL, let receiptString = try? Data(contentsOf: receiptURL, options: .alwaysMapped).base64EncodedString(options: []) else {
            return
        }

        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          APIParameters.MainAccountID:LoginDataModel.currentMainAccountId,
                          "TransactionID":IAPHelper.shared.originalTransactionID ?? "",
                          "PlanId":IAPHelper.shared.planID ?? "",
                          "AppType":APP_TYPE,
                          "ReceiptData":receiptString]

        APICallManager.sharedInstance.callAPI(router: APIRouter.planpurchase(parameters)) { (response :GeneralModel) in

            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                // Segment Tracking
                let eventname = self.isFromUpdate ? SegmentTracking.eventNames.User_Plan_Upgraded : SegmentTracking.eventNames.Checkout_Completed
                SegmentTracking.shared.trackPlanDetails(name: eventname, planDetails: self.planData, trackingType: .track)
                
                if self.isFromUpdate {
                    NotificationCenter.default.post(name: .planUpdated, object: nil)
                    self.navigationController?.dismiss(animated: false, completion: nil)
                } else {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: ThankYouVC.self)
                    self.navigationController?.pushViewController(aVC, animated: true)
                }
            }
        }
    }
}

extension SetUpPInVC {
    
    // Set Login PIN API Call
    func callSetUpPinAPI() {
        let parameters = [APIParameters.UserId:selectedUser?.UserId ?? "",
                          "Pin":txtFConfirmLoginPin.text ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.setloginpin(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                self.handleUserRedirection()
                if CoUserDataModel.currentUser != nil {
                    self.callGetCoUserDetailsAPI(complitionBlock: nil)
                }
            }
        }
    }
}

extension UserDetailVC {
    
    // Add User (with Same Number) API Call
    func callAddUserDetailAPI() {
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentMainAccountId,
                          "Name":txtFName.text ?? "",
                          "Email":txtFEmail.text ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.addcouser(parameters)) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                // Segment Tracking
                if let userDetails = response.ResponseData {
                    let traits = ["userId":userDetails.UserId,
                                  "userGroupId":userDetails.MainAccountID,
                                  "name":userDetails.Name,
                                  "mobileNo":userDetails.Mobile,
                                  "email":userDetails.Email,
                                  "isSameMobile":"true"]
                    SegmentTracking.shared.trackEvent(name: SegmentTracking.eventNames.Couser_Added, traits: traits, trackingType: .track)
                }
                
                self.handleRedirection()
            }
        }
    }
}

extension ContactVC {
    
    // Invite User API Call
    func callInviteUserAPI(contact : ContactModel) {

        let parameters = [APIParameters.UserId:LoginDataModel.currentUserId,
                          "Name":contact.contactName,
                          "MobileNo":contact.contactNumber.removeWhitespace()]

        APICallManager.sharedInstance.callAPI(router: APIRouter.inviteuser(parameters)) { (response :GeneralModel) in

            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                self.sendMessage(contact: contact, inviteUrl: response.ResponseData?.InviteLink ?? "")
            }
        }
    }
}

extension ManageUserVC {
    
    // User List API Call
    func callManageUserListAPI() {
        arrayUsers.removeAll()
        tableView.reloadData()
        buttonEnableDisable()
        
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentMainAccountId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.manageuserlist(parameters)) { (response : UserListModel) in
            if response.ResponseCode == "200" {
                self.arrayUsers = response.ResponseData.UserList
                self.tableView.reloadData()
                self.maxUsers = Int(response.ResponseData.Maxuseradd) ?? 0
                self.totalUserCount = Int(response.ResponseData.totalUserCount) ?? 0
                self.setupData()
                
                // Segment Tracking
                let traits = ["totalUsers":"\(self.arrayUsers.count)"]
                SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.manage_user, traits: traits)
            } else {
                self.setupData()
            }
        }
    }
    
    // Cancel Invite API Call
    func callCancelInviteAPI(user : CoUserDataModel) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "MobileNo":user.Mobile]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.cancelinviteuser(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                self.callManageUserListAPI()
            }
        }
    }
    
    // Remove User API Call
    func callRemoveUserAPI(userId : String) {
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentMainAccountId,
                          APIParameters.UserId:userId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.removeuser(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                self.callManageUserListAPI()
                
                // Segment Tracking
                let traits = ["removedUserId":userId]
                SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Co_User_Removed, traits: traits)
            }
        }
    }
    
}


//Reminder pop Up
extension ReminderPopUpVC {
    
    // Suggested Playlist Reminder PopUp - Proceed API Call
    func callProceedAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]

        APICallManager.sharedInstance.callAPI(router: APIRouter.proceed(parameters), displayHud: true, showToast: false) { (response :GeneralModel) in
            if response.ResponseCode == "200" {
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: DayVC.self)
                aVC.isfromPopUp = true
                aVC.objPlaylist = self.suggstedPlaylist
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        }
    }
}

extension CancelSubVC {
    
    // Cancel IAP Plan API Call
    func callCancelPlanAPI() {
        var parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "CancelId":"\(selectedOption)"]
        if selectedOption == 4 {
            parameters["CancelReason"] = txtView.text!
        }
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.cancelplan(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                if let planData = self.planDetails {
                    self.trackIAPCancelSubscriptionEvent(planData: planData)
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let url = URL(string: MANAGE_SUBSCRIPTIONS_URL), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    showAlertToast(message: Theme.strings.alert_cannot_open_subscription_setting)
                }
            }
        }
    }
    
    // Cancel Stripe Plan API Call
    func callCancelStripePlanAPI() {
        var parameters = ["UserID":CoUserDataModel.currentUserId,
                          "CancelId":"\(selectedOption)"]
        if selectedOption == 4 {
            parameters["CancelReason"] = txtView.text!
        }
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.cancelplanstripe(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                if let planData = self.oldPlanDetails {
                    self.trackStripeCancelSubscriptionEvent(planData: planData)
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Delete Account API
    func callDeleteAccountAPI() {
        var parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "CancelId":"\(selectedOption)"]
        if selectedOption == 4 {
            parameters["CancelReason"] = txtView.text!
        }
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.deleteuser(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                AccountVC.handleLogout()
                
                // Segment Tracking
                let traits = ["reason":"\(self.selectedOption)",
                              "comments":self.txtView.text!]
                SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Account_Deleted, traits: traits)
            }
        }
    }
}


extension BillingOrderVC {
    
    // IAP Plan Details API
    func callPlanDetailsAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.plandetails(parameters)) { (response :PlanDataModel) in
            
            if response.ResponseCode == "200" {
                self.planDetails = response.ResponseData
                self.setupData()
                self.trackScreenData(planDetails: response.ResponseData)
            }
        }
    }
}


extension BillingOrderStripeVC {
    
    // Stripe Plan Details API
    func callStripePlanDetailsAPI() {
        let parameters = ["UserID":CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.billingorder(parameters)) { (response :StripePlanDataModel) in
            
            if response.ResponseCode == "200" {
                self.oldPlanDetails = response.ResponseData
                self.setupData()
                self.trackScreenData(planDetails: response.ResponseData)
            }
        }
    }
}


extension UpgradePlanVC {
    
    // Fetch Plan List & Other Data
    func callUserPlanListAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        APICallManager.sharedInstance.callAPI(router: APIRouter.userplanlist(parameters)) { (response :PlanListModel) in
            
            if response.ResponseCode == "200" {
                self.strTitle = response.ResponseData.Title
                self.strSubTitle = response.ResponseData.Desc
                self.arrayPlans = response.ResponseData.Plan
                self.setupData()
                self.fetchIAPProducts()
            }
        }
    }
    
    func fetchIAPProducts() {
        if IAPHelper.shared.isIAPEnabled {
            let arrayProductIDs : [String] = arrayPlans.compactMap({ $0.IOSplanId })
            
            // IAP Purchase Retrive Products
            IAPHelper.shared.productRetrive(arrayProductIDs: arrayProductIDs) { (success, iapProducts) in
                if success {
                    guard let products = iapProducts else {
                        self.setupData()
                        return
                    }
                    
                    print("IAP Products Fetched")
                    for product in products {
                        for plan in self.arrayPlans {
                            if plan.IOSplanId == product.iapProductIdentifier {
                                plan.iapProductIdentifier = product.iapProductIdentifier
                                plan.iapPrice = product.iapPrice
                                plan.iapTitle = product.iapTitle
                                plan.iapDescription = product.iapDescription
                                plan.iapTrialPeriod = product.iapTrialPeriod
                                plan.iapSubscriptionPeriod = product.iapSubscriptionPeriod
                            }
                        }
                    }
                    
                    self.setupData()
                }
            }
        }
    }
    
}
