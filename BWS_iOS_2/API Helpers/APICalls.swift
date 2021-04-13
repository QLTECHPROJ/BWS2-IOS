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
    
    // Call Get Co User Details API
    func CallGetCoUserDetailsAPI() {
        let parameters = ["UserID":CoUserDataModel.currentUser?.UserID ?? "",
                          "CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.getcouserdetails(parameters), displayHud: false) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                CoUserDataModel.currentUser = response.ResponseData
                self.handleCoUserRedirection()
            } else {
                CoUserDataModel.currentUser = nil
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
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.verifypin(parameters)) { (response : CoUserModel) in
            if response.ResponseCode == "200" {
                self.dismiss(animated: false, completion: nil)
                CoUserDataModel.currentUser = response.ResponseData
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
                CoUserDataModel.currentUser = userData
                showAlertToast(message: response.ResponseMessage)
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
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
                if let id = response.ResponseData?.id, let name = response.ResponseData?.name {
                    if self.playlistToAdd.trim.count > 0 || self.audioToAdd.trim.count > 0 {
                        self.delegate?.didCreateNewPlaylist(createdPlaylistID: id)
                        self.navigationController?.popViewController(animated: true)
                    } else {
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
            }
        }
    }
    
    // Delete Playlist API Call
    func callDeletePlaylistAPI() {
        let parameters = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                          "PlaylistId":objPlaylist!.PlaylistID]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.deleteplaylist(parameters)) { (response : GeneralModel) in
            
            if response.ResponseCode == "200" {
                self.navigationController?.popViewController(animated: true)
                showAlertToast(message: response.ResponseMessage)
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
