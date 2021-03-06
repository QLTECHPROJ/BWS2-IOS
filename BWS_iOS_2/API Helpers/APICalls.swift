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
        let parameters = ["Version":APP_VERSION,
                          "AppType":APP_TYPE]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.appversion(parameters), displayHud: false) { (response : AppVersionModel) in
            if response.ResponseCode == "200" {
                SplashVC.isForceUpdate = response.ResponseData.IsForce
                
                // Segment Configuration
                SegmentTracking.shared.segmentWriteKey = response.ResponseData.segmentKey
                SegmentTracking.shared.configureSegment()
                
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


extension SignUpVC {
    
    // App Version API Call
    func callSignUpAPI() {
        let parameters = ["DeviceType":APP_TYPE,
                          "Name":txtFName.text ?? "",
                          "Email":txtFEmailAdd.text ?? "",
                          "CountryCode":selectedCountry.Code,
                          "MobileNo":txtFMobileNo.text ?? "",
                          "Password":txtFPassWord.text ?? "",
                          "DeviceId":DEVICE_UUID,
                          "Token":FCM_TOKEN]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.signup(parameters), displayHud: true, showToast: false) { (response : LoginModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                // Segment Tracking
                if let userDetails = response.ResponseData {
                    let traits = ["UserID":userDetails.ID,
                                  "name":userDetails.Name,
                                  "countryCode":self.selectedCountry.Code,
                                  "countryName":self.selectedCountry.Name,
                                  "countryShortName":self.selectedCountry.ShortName,
                                  "mobileNo":userDetails.MobileNo,
                                  "email":userDetails.Email]
                    SegmentTracking.shared.trackEvent(name: SegmentTracking.eventNames.User_Sign_up, traits: traits, trackingType: .track)
                }
                
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:LoginVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else {
                if response.ResponseMessage.trim.count > 0 {
                    self.lblErrPass.isHidden = false
                    self.lblErrPass.text = response.ResponseMessage
                }
            }
        }
    }
    
}

extension LoginVC {
    
    // App Version API Call
    func callLoginAPI() {
        let parameters = ["Email":txtFEmailAdd.text ?? "",
                          "Password":txtFPassWord.text ?? "",
                          "DeviceType":APP_TYPE,
                          "DeviceId":DEVICE_UUID,
                          "Token":FCM_TOKEN]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.login(parameters), displayHud: true, showToast: false) { (response : LoginModel) in
            if response.ResponseCode == "200" {
                LoginDataModel.currentUser = response.ResponseData
                
                // Segment Tracking
                if let userDetails = response.ResponseData {
                    let traits = ["UserID":userDetails.ID,
                                  "name":userDetails.Name,
                                  "mobileNo":userDetails.MobileNo,
                                  "email":userDetails.Email]
                    SegmentTracking.shared.trackEvent(name: SegmentTracking.eventNames.User_Login, traits: traits, trackingType: .track)
                }
                
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:UserListVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else {
                if response.ResponseMessage.trim.count > 0 {
                    self.lblErrPass.isHidden = false
                    self.lblErrPass.text = response.ResponseMessage
                }
            }
        }
    }
    
}

extension ForgotPassVC {
    
    // Forgot Password API Call
    func callForgotPasswordAPI() {
        let parameters = ["Email":txtFEmailAdd.text ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.forgotpass(parameters), displayHud: true, showToast: false) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                self.lblErrorEmail.isHidden = false
                self.txtFEmailAdd.text = ""
                
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
                aVC.strDesc = response.ResponseMessage
                aVC.isOkButtonHidden = false
                aVC.descFont = Theme.fonts.montserratFont(ofSize: 10, weight: .regular)
                aVC.modalPresentationStyle = .overFullScreen
                self.present(aVC, animated: false, completion: nil)
            } else {
                if response.ResponseMessage.trim.count > 0 {
                    self.lblErrorEmail.isHidden = false
                    self.lblErrorEmail.text = response.ResponseMessage
                }
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
        
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.userlist(parameters)) { (response : UserListModel) in
            if response.ResponseCode == "200" {
                self.arrayUsers = response.ResponseData.UserList
                self.tableView.reloadData()
                self.maxUsers = Int(response.ResponseData.Maxuseradd) ?? 0
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
                
                // Segment Tracking
                SegmentTracking.shared.identifyUser()
                SegmentTracking.shared.coUserEvent(name: SegmentTracking.eventNames.CoUser_Login, trackingType: .track)
                
                // Clear Last User Data
                AccountVC.clearUserData()
                
                showAlertToast(message: "Welcome \(CoUserDataModel.currentUser?.Name ?? "Guest")!!")
                
                self.pinVerified?()
            } else {
                showAlertToast(message: response.ResponseMessage)
            }
        }
    }
    
}

extension AddProfileVC {
    
    // Add User Profile API Call
    func callAddUserProfileAPI() {
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentUserId,
                          "UserName":txtFName.text ?? "",
                          "Email":txtFEmailAdd.text ?? "",
                          "MobileNo":txtFMobileNo.text ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.addcouser(parameters), displayHud: true, showToast: false) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                // Segment Tracking
                if self.selectedUser == nil {
                    if let userDetails = response.ResponseData {
                        let traits = ["name":userDetails.Name,
                                      "mobileNo":userDetails.Mobile,
                                      "email":userDetails.Email]
                        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Couser_Added, traits: traits)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
            } else {
                if response.ResponseMessage.trim.count > 0 {
                    self.lblErrEmailAdd.isHidden = false
                    self.lblErrEmailAdd.text = response.ResponseMessage
                }
            }
        }
    }
    
    // Forgot Pin API Call
    func callForgotPinAPI() {
        let parameters = [APIParameters.UserId:selectedUser?.UserId ?? "",
                          "Email":selectedUser?.Email ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.forgotpin(parameters)) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension ProfileForm6VC {
    
    // Profile Answer Save API Call
    func callProfileAnsSaveAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "profileType":ProfileFormModel.shared.profileType,
                          "gender":ProfileFormModel.shared.gender,
                          "genderX":ProfileFormModel.shared.genderX,
                          "age":ProfileFormModel.shared.age,
                          "prevDrugUse":ProfileFormModel.shared.prevDrugUse,
                          "Medication":ProfileFormModel.shared.Medication]
        
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.profilesaveans(parameters)) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                
                // Segment Tracking
                SegmentTracking.shared.trackEvent(name: SegmentTracking.eventNames.Profile_Form_Submitted, traits: parameters, trackingType: .track)
                
                ProfileFormModel.shared = ProfileFormModel()
                CoUserDataModel.currentUser?.isProfileCompleted = "1"
                CoUserDataModel.currentUser = CoUserDataModel.currentUser
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DoDassAssessmentVC.self)
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
    
    // Fetch Dass Assessment answer save API Call
    func callSaveAnsAssessmentAPI(arrAns:String) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "ans":arrAns]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.assesmentsaveans(parameters)) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                let userData = CoUserDataModel.currentUser
                userData?.indexScore = response.ResponseData?.indexScore ?? "0"
                userData?.ScoreLevel = response.ResponseData?.ScoreLevel ?? ""
                CoUserDataModel.currentUser = userData
                
                // Segment Tracking
                let traits = ["indexScore":CoUserDataModel.currentUser?.indexScore ?? "",
                              "ScoreLevel":CoUserDataModel.currentUser?.ScoreLevel ?? ""]
                SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Assessment_Form_Submitted, traits: traits, passUserID: true)
                
                showAlertToast(message: response.ResponseMessage)
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
                aVC.isFromEdit = self.isFromEdit
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        }
    }
    
}

extension UIViewController {
    
    // Call Get Co User Details API
    func callGetCoUserDetailsAPI(complitionBlock : ((Bool) -> ())?) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getcouserdetails(parameters), displayHud: false) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                CoUserDataModel.currentUser = response.ResponseData
                
                // Segment Tracking
                if SegmentTracking.shared.userIdentityTracked == false {
                    SegmentTracking.shared.identifyUser()
                }
                
                DispatchQueue.main.async {
                    complitionBlock?(true)
                }
            } else {
                CoUserDataModel.currentUser = nil
                DispatchQueue.main.async {
                    complitionBlock?(false)
                }
            }
        }
    }
    
    // Call Log Out API
    func callLogoutAPI(complitionBlock : (() -> ())?) {
        let parameters = [APIParameters.UserId:LoginDataModel.currentUserId,
                          "Token":FCM_TOKEN,
                          "DeviceType":APP_TYPE]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.logout(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                SegmentTracking.shared.coUserEvent(name: SegmentTracking.eventNames.CoUser_Logout, trackingType: .track)
                complitionBlock?()
            } else {
                complitionBlock?()
            }
        }
    }
    
    // Audio Recently Played API Call
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
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":objPlaylist.PlaylistID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.deleteplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                refreshPlaylistData = true
                showAlertToast(message: response.ResponseMessage)
                DispatchQueue.main.async {
                    complitionBlock?()
                }
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
    
}

extension ManageVC {
    
    // Manage Home API Call
    func callManageHomeAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.managehomescreen(parameters)) { (response : ManageHomeModel) in
            if response.ResponseCode == "200" {
                if let responseData = response.ResponseData {
                    self.suggstedPlaylist = responseData.SuggestedPlaylist
                    self.arrayAudioHomeData = responseData.Audio
                    self.arrayPlaylistHomeData = responseData.Playlist
                    
                    for data in self.arrayAudioHomeData {
                        if data.View == Theme.strings.my_downloads {
                            data.Details = CoreDataHelper.shared.fetchSingleAudios()
                            lockDownloads = data.IsLock
                            // setDownloadsExpiryDate(expireDateString: data.expireDate)
                            let _ = shouldLockDownloads()
                        }
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
                    if self.playlistToAdd.trim.count > 0 || self.audioToAdd.trim.count > 0 {
                        self.delegate?.didCreateNewPlaylist(createdPlaylistID: id)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        refreshPlaylistData = true
                        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
                        let playlistDetails = PlaylistDetailsModel()
                        playlistDetails.PlaylistID = id
                        playlistDetails.PlaylistName = name
                        playlistDetails.Created = "1"
                        playlistDetails.TotalAudio = "1"
                        aVC.objPlaylist = playlistDetails
                        self.navigationController?.pushViewController(aVC, animated: true)
                    }
                }
            }
        }
    }
    
    // Rename Playlist API Call
    func callRenamePlaylistAPI(PlaylistName : String) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":objPlaylist!.PlaylistID,
                          "PlaylistNewName":PlaylistName]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.renameplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                refreshPlaylistData = true
                self.navigationController?.popViewController(animated: true)
                showAlertToast(message: response.ResponseMessage)
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
    
    // Playlist Sprting API Call
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
                
                // Segment Tracking
                self.trackScreenData()
            }
        }
    }
    
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
    
    //call audio list
    func callAudioAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        APICallManager.sharedInstance.callAPI(router: APIRouter.suggestedaudio(parameters)) { (response :AudioDetailsModel) in
            
            if response.ResponseCode == "200" {
                self.arrayAudio = response.ResponseData
                self.setupData()
            }
            
            // self.callPlaylistAPI()
        }
    }
    
    //call playlist
    func callPlaylistAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        APICallManager.sharedInstance.callAPI(router: APIRouter.suggestedplaylist(parameters)) { (response :PlaylistListingModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlayList = response.ResponseData
                self.setupData()
            }
        }
    }
    
    //call search
    func callSearchAPI(searchText : String) {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "SuggestedName":searchText]
        
        // Segment Tracking
        let traits = ["source":isComeFromAddAudio ? "Add Audio Screen" : "Search Screen",
                      "searchKeyword":searchText]
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Audio_Playlist_Searched, traits: traits)
        
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
    
    // Save Category & Sleep Time
    func callSaveCategoryAPI(areaOfFocus : [[String:Any]]) {
        let parameters : [String : Any] = [APIParameters.UserId:CoUserDataModel.currentUserId,
                                           "AvgSleepTime":self.averageSleepTime,
                                           "CatName":areaOfFocus.toJSON() ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.saverecommendedcategory(parameters)) { (response :SaveCategoryModel) in
            
            if response.ResponseCode == "200" {
                let userData = CoUserDataModel.currentUser
                userData?.AvgSleepTime = response.ResponseData?.AvgSleepTime ?? "0"
                userData?.AreaOfFocus = response.ResponseData?.CategoryData ?? [AreaOfFocusModel]()
                CoUserDataModel.currentUser = userData
                
                // Segment Tracking
                self.trackScreenData()
                
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: PreparingPlaylistVC.self)
                aVC.isFromEdit = self.isFromEdit
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        }
    }
    
}

extension SleepTimeVC {
    
    // Fetch Sleep Time
    func callSleepTimetAPI() {
        APICallManager.sharedInstance.callAPI(router: APIRouter.avgsleeptime) { (response : AverageSleepTimeModel) in
            if response.ResponseCode == "200" {
                self.arrayTimes = response.ResponseData
                self.collectionViewSleepTime.reloadData()
            }
        }
    }
}

extension ManagePlanListVC {
    
    // Fetch Plan List & Other Data
    func callManagePlanListAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        APICallManager.sharedInstance.callAPI(router: APIRouter.planlist(parameters)) { (response :PlanListModel) in
            
            if response.ResponseCode == "200" {
                self.dataModel = response.ResponseData
                self.setupData()
            }
        }
    }
    
}

extension AddAudioViewAllVC {
    
    //call playlist
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
        
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.userlist(parameters)) { (response : UserListModel) in
            if response.ResponseCode == "200" {
                self.arrayUsers = response.ResponseData.UserList
                self.tableView.reloadData()
                self.maxUsers = Int(response.ResponseData.Maxuseradd) ?? 0
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
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.homescreen(parameters)) { (response : HomeModel) in
            if response.ResponseCode == "200" {
                self.tableView.isHidden = false
                
                let userData = CoUserDataModel.currentUser
                userData?.indexScore = response.ResponseData.IndexScore
                CoUserDataModel.currentUser = userData
                
                self.shouldCheckIndexScore = response.ResponseData.shouldCheckIndexScore
                self.IndexScoreDiff = response.ResponseData.IndexScoreDiff
                self.ScoreIncDec = response.ResponseData.ScoreIncDec
                self.suggstedPlaylist = response.ResponseData.SuggestedPlaylist
                self.arrayPastIndexScore = response.ResponseData.PastIndexScore
                self.arraySessionScore = response.ResponseData.SessionScore
                self.arraySessionProgress = response.ResponseData.SessionProgress
                
                if response.ResponseData.shouldPlayDisclaimer == "1" {
                    DisclaimerAudio.shared.shouldPlayDisclaimer = true
                }
                
                if let disclaimer = response.ResponseData.disclaimerAudio {
                    DisclaimerAudio.shared.disclaimerAudio = disclaimer
                }
                
                self.setupData()
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
    
    //call change pin
    func callChangePinAPI() {
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "OldPin":txtFOldPIN.text ?? "",
                          "NewPin":txtFConfirmPIN.text ?? ""]
        APICallManager.sharedInstance.callAPI(router: APIRouter.changepin(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                // Segment Tracking
                SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.eventNames.Login_Pin_Changed)
                
                showAlertToast(message: response.ResponseMessage)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension ChangePassWordVC {
    
    //call change pin
    func callChangePasswordAPI() {
        let parameters = [APIParameters.MainAccountID:LoginDataModel.currentUserId,
                          APIParameters.UserId:CoUserDataModel.currentUserId,
                          "OldPassword":txtfOldPassword.text ?? "",
                          "NewPassword":txtFConfirmPassword.text ?? ""]
        APICallManager.sharedInstance.callAPI(router: APIRouter.changepassword(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                // Segment Tracking
                SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.eventNames.Password_Changed)
                
                showAlertToast(message: response.ResponseMessage)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension FAQVC {
    
    // Country List API Call
    func callFAQtAPI() {
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
    
    func callSetRemAPI() {
        
        let strDay =  (arrSelectDays.map{String($0)}).joined(separator: ",")
        print(strDay)
        let time = lblTime.text?.localToUTC(incomingFormat: "h:mm a", outGoingFormat: "h:mm a") ?? ""

        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          "PlaylistId":strPlaylistID ?? "",
                          "IsSingle":"1",
                          "ReminderTime":time,
                          "ReminderDay":strDay]

        APICallManager.sharedInstance.callAPI(router: APIRouter.setreminder(parameters)) { (response : GeneralModel) in

            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
            self.navigationController?.popViewController(animated: true)
                self.setupData()
                self.tableView.reloadData()

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
    
    //Update Profile Detail API
    func callUpdateProfileDetailAPI() {
        var DOB = selectedDOB.stringFromFormat(Theme.dateFormats.DOB_Backend)
        
        if txtFDOB.text?.trim.count == 0 {
            DOB = ""
        }
        
        let parameters = [APIParameters.UserId:CoUserDataModel.currentUserId,
                          APIParameters.MainAccountID:LoginDataModel.currentUserId,
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
                        self.navigationController?.popViewController(animated: true)
                        
                        // Segment Tracking
                        SegmentTracking.shared.identifyUser()
                        SegmentTracking.shared.coUserEvent(name: SegmentTracking.eventNames.Profile_Changes_Saved, trackingType: .track)
                    }
                }
            }
        }
    }
}
