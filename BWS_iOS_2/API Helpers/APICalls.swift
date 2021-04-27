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
                LoginDataModel.currentUser = response.ResponseData
                
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
        
        let parameters = ["UserID":LoginDataModel.currentUser?.ID ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.userlist(parameters)) { (response : UserListModel) in
            if response.ResponseCode == "200" {
                self.arrayUsers = response.ResponseData.CoUserList
                self.tableView.reloadData()
                self.maxUsers = Int(response.ResponseData.Maxuseradd) ?? 0
                self.setupData()
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
        let parameters = ["UserID":selectedUser?.CoUserId ?? "",
                          "Pin":strCode]
        
        let coUserID = CoUserDataModel.currentUser?.CoUserId
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.verifypin(parameters)) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                self.dismiss(animated: false, completion: nil)
                
                CoUserDataModel.currentUser = response.ResponseData
                
                if let lastCoUserID = coUserID {
                    CoUserDataModel.lastCoUserID = lastCoUserID
                }
                
                // Clear Last User Data
                AccountVC.clearUserData()
                
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
        let parameters = ["UserID":LoginDataModel.currentUser?.ID ?? "",
                          "UserName":txtFName.text ?? "",
                          "Email":txtFEmailAdd.text ?? "",
                          "MobileNo":txtFMobileNo.text ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.addcouser(parameters), displayHud: true, showToast: false) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
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
        let parameters = ["UserID":selectedUser?.UserID ?? "",
                          "CoUserId":selectedUser?.CoUserId ?? "",
                          "Email":selectedUser?.Email ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.forgotpin(parameters)) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension ProfileForm5VC {
    
    // Profile Answer Save API Call
    func callProfileAnsSaveAPI() {
        let parameters = ["UserID":CoUserDataModel.currentUser?.UserID ?? "",
                          "CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "profileType":ProfileFormModel.shared.profileType,
                          "gender":ProfileFormModel.shared.gender,
                          "genderX":ProfileFormModel.shared.genderX,
                          "age":ProfileFormModel.shared.age,
                          "prevDrugUse":ProfileFormModel.shared.prevDrugUse]
        
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.profilesaveans(parameters)) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                showAlertToast(message: response.ResponseMessage)
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
        let parameters = ["UserID":CoUserDataModel.currentUser?.UserID ?? "",
                          "CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "ans":arrAns]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.assesmentsaveans(parameters)) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                let userData = CoUserDataModel.currentUser
                userData?.indexScore = response.ResponseData?.indexScore ?? "0"
                userData?.ScoreLevel = response.ResponseData?.ScoreLevel ?? ""
                CoUserDataModel.currentUser = userData
                showAlertToast(message: response.ResponseMessage)
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        }
    }
    
}

extension UIViewController {
    
    // Call Get Co User Details API
    func callGetCoUserDetailsAPI(complitionBlock : ((Bool) -> ())?) {
        let parameters = ["UserID":CoUserDataModel.currentUser?.UserID ?? "",
                          "CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getcouserdetails(parameters), displayHud: false) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                CoUserDataModel.currentUser = response.ResponseData
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
    
    // Audio Recently Played API Call
    func callRecentlyPlayedAPI(audioID : String, complitionBlock : (() -> ())?) {
        if audioID.trim.count == 0 || DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
            return
        }
        
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
    
}

extension ManageVC {
    
    // Manage Home API Call
    func callManageHomeAPI() {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.managehomescreen(parameters)) { (response : ManageHomeModel) in
            if response.ResponseCode == "200" {
                if let responseData = response.ResponseData {
                    self.suggstedPlaylist = responseData.SuggestedPlaylist
                    self.arrayAudioHomeData = responseData.Audio
                    self.arrayPlaylistHomeData = responseData.Playlist
                    
                    for data in self.arrayAudioHomeData {
                        if data.View == "My Downloads" {
                            data.Details = CoreDataHelper.shared.fetchSingleAudios()
                            lockDownloads = data.IsLock
                            // setDownloadsExpiryDate(expireDateString: data.expireDate)
                            let _ = shouldLockDownloads()
                        }
                    }
                    
                    self.setupData()
                }
            }
        }
    }
}

extension ViewAllAudioVC {
    
    // Get All Audio API Call
    @objc func callViewAllAudioAPI() {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "GetHomeAudioId":libraryId,
                          "CategoryName":categoryName]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.managehomeviewallaudio(parameters)) { (response : AudioViewAllModel) in
            
            if response.ResponseCode == "200", let responseData = response.ResponseData {
                self.homeData = responseData
                self.objCollectionView.reloadData()
            }
        }
    }
    
}

extension PlaylistCategoryVC {
    
    // Playlist Library API Call
    @objc func callPlaylistLibraryAPI() {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.playlistlibrary(parameters)) { (response : PlaylistHomeModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlaylistHomeData = response.ResponseData
                self.tableView.reloadData()
            }
        }
    }
    
}

extension ViewAllPlaylistVC {
    
    // Playlist On Get Library API Call
    @objc func callPlaylistOnGetLibraryAPI() {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "GetLibraryId":libraryId]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.playlistonviewall(parameters)) { (response : PlaylistLibraryModel) in
            
            if response.ResponseCode == "200", let responseData = response.ResponseData {
                self.homeData = responseData
                self.objCollectionView.reloadData()
            }
        }
    }
    
}

extension CreatePlaylistVC {
    
    // Create Playlist API Call
    func callCreatePlaylistAPI(PlaylistName : String) {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "PlaylistName":PlaylistName]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.createplaylist(parameters)) { (response : CreatePlaylistModel) in
            
            if response.ResponseCode == "200" {
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "PlaylistId":arraySearchSongs[index].PlaylistID,
                          "AudioId":arraySearchSongs[index].ID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.removeaudiofromplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getcreatedplaylist(parameters)) { (response : PlaylistListingModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlaylist = response.ResponseData
                if self.playlistID.trim.count > 0 {
                    self.arrayPlaylist = self.arrayPlaylist.filter { $0.PlaylistID != self.playlistID }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func callAddAudioToPlaylistAPI(playlistID : String) {
        self.view.endEditing(true)
        
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "PlaylistId":audioDetails!.PlaylistID,
                          "AudioId":audioDetails!.ID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.removeaudiofromplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                let playlistID = self.audioDetails!.PlaylistID
                
                self.handleRemoveFromPlaylist()
                showAlertToast(message: response.ResponseMessage)
                
                self.callPlaylistDetailAPI(playlistId: playlistID)
            }
            else {
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        APICallManager.sharedInstance.callAPI(router: APIRouter.suggestedplaylist(parameters)) { (response :PlaylistListingModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlayList = response.ResponseData
                self.setupData()
            }
        }
    }
    
    //call search
    func callSearchAPI(searchText : String) {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "SuggestedName":searchText]
        
        // Segment Tracking
        //        let traits = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
        //                      "source":isComeFromAddAudio ? "Add Audio Screen" : "Search Screen",
        //                      "searchKeyword":searchText]
        //        SegmentTracking.shared.trackEvent(name: "Audio/Playlist Searched", traits: traits, trackingType: .track)
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.searchonsuggestedlist(parameters)) { (response : AudioDetailsModel) in
            
            self.arraySearch.removeAll()
            if response.ResponseCode == "200" {
                self.arraySearch = response.ResponseData
                self.arraySearch = self.arraySearch.filter { $0.Iscategory == "1" }
                self.reloadSearchData()
            } else {
                self.arraySearch.removeAll()
                self.reloadSearchData()
            }
        }
    }
    
    func callAddAudioToPlaylistAPI(audioToAdd : String = "" , playlistToAdd : String = "") {
        self.view.endEditing(true)
        
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getrecommendedcategory(parameters)) { (response :CategoryModel) in
            
            if response.ResponseCode == "200" {
                self.arrayCategories = response.ResponseData
                self.tableView.reloadData()
                self.setupData()
            }
        }
    }
    
    // Save Category & Sleep Time
    func callSaveCategoryAPI(areaOfFocus : String) {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "AvgSleepTime":self.averageSleepTime,
                          "CatName":areaOfFocus]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.saverecommendedcategory(parameters)) { (response :GeneralModel) in
            
            if response.ResponseCode == "200" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: PreparingPlaylistVC.self)
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
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        APICallManager.sharedInstance.callAPI(router: APIRouter.planlist(parameters)) { (response :PlanListModel) in
            
            if response.ResponseCode == "200" {
                self.arrayAudios = response.ResponseData.AudioFiles
                self.arrayVideos = response.ResponseData.TestminialVideo
                self.arrayQuestions = response.ResponseData.FAQs
                self.setupData()
            }
        }
    }
    
}

extension AddAudioViewAllVC {
    
    //call playlist
    func callPlaylistAPI() {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        APICallManager.sharedInstance.callAPI(router: APIRouter.suggestedplaylist(parameters)) { (response :PlaylistListingModel) in
            
            if response.ResponseCode == "200" {
                self.arrayPlayList = response.ResponseData
                self.setupData()
                
                // Segment Tracking
                // self.trackScreenData()
            }
        }
    }
    
    func callAddAudioToPlaylistAPI(audioToAdd : String = "" , playlistToAdd : String = "") {
        self.view.endEditing(true)
        
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
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
        
        let parameters = ["UserID":LoginDataModel.currentUser?.ID ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.userlist(parameters)) { (response : UserListModel) in
            if response.ResponseCode == "200" {
                self.arrayUsers = response.ResponseData.CoUserList
                self.tableView.reloadData()
                self.maxUsers = Int(response.ResponseData.Maxuseradd) ?? 0
                self.setupData()
            } else {
                self.setupData()
            }
        }
    }
    
}

extension HomeVC {
    
    // Home API Call
    func callHomeAPI() {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.homescreen(parameters)) { (response : HomeModel) in
            if response.ResponseCode == "200" {
                self.suggstedPlaylist = response.ResponseData.SuggestedPlaylist
                self.arrayPastIndexScore = response.ResponseData.PastIndexScore
                self.arraySessionScore = response.ResponseData.SessionScore
                self.arraySessionProgress = response.ResponseData.SessionProgress
                self.setupData()
            } else {
                self.setupData()
            }
        }
    }
    
}
