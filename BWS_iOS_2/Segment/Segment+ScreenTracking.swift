//
//  Segment+ScreenTracking.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 10/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation

extension SegmentTracking {
    
    func trackGeneralScreen(name : String, traits : [String:Any]? = nil) {
        var newTraits = [String : Any]()
        if let allTraits = traits {
            for (key,value) in allTraits {
                newTraits[key] = value
            }
        }
        
        if let userDetails = CoUserDataModel.currentUser {
            newTraits["userId"] = userDetails.UserId
            newTraits["isAdmin"] = userDetails.isAdminUser
        }
        
        if LoginDataModel.currentMainAccountId.count > 0 {
            newTraits["userGroupId"] = LoginDataModel.currentMainAccountId
        }
        
        SegmentTracking.shared.trackEvent(name: name, traits: newTraits, trackingType: .screen)
    }
    
    func trackGeneralEvents(name : String, traits : [String:Any]? = nil) {
        var newTraits = [String : Any]()
        if let allTraits = traits {
            for (key,value) in allTraits {
                newTraits[key] = value
            }
        }
        
        if let userDetails = CoUserDataModel.currentUser {
            newTraits["userId"] = userDetails.UserId
            newTraits["isAdmin"] = userDetails.isAdminUser
        }
        
        if LoginDataModel.currentMainAccountId.count > 0 {
            newTraits["userGroupId"] = LoginDataModel.currentMainAccountId
        }
        
        SegmentTracking.shared.trackEvent(name: name, traits: newTraits, trackingType: .track)
    }
    
    func trackDownloadedAudiosScreenViewed() {
        var traits : [String:Any] = ["tabType":"Audio Tab"]
        
        var downloadedAudios = [[String:String]]()
        
        for audio in CoreDataHelper.shared.fetchSingleAudios() {
            let audioDetails = ["audioId":audio.ID,
                                "audioName":audio.Name,
                                "masterCategory":audio.Audiomastercat,
                                "subCategory":audio.AudioSubCategory,
                                "audioDuration":audio.AudioDuration]
            downloadedAudios.append(audioDetails)
        }
        
        traits["downloadedAudios"] = downloadedAudios
        
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.my_downloads_screen, traits: traits)
    }
    
    func trackDownloadedPlaylistsScreenViewed() {
        var traits : [String:Any] = ["tabType":"Playlist Tab"]
        
        var downloadedPlaylists = [[String:String]]()
        
        for playlist in CoreDataHelper.shared.fetchAllPlaylists() {
            let totalhour = playlist.Totalhour.trim.count > 0 ? playlist.Totalhour : "0"
            let totalminute = playlist.Totalminute.trim.count > 0 ? playlist.Totalminute : "0"
            let totalDuration = "\(totalhour)h \(totalminute)m"
            
            let playlistDetails = ["playlistId":playlist.PlaylistID,
                                   "playlistName":playlist.PlaylistName,
                                   "playlistType":playlist.selfCreated == "1" ? "Created" : "Default",
                                   "playlistDuration":playlist.TotalDuration,
                                   "audioCount":totalDuration]
            downloadedPlaylists.append(playlistDetails)
        }
        
        traits["downloadedPlaylists"] = downloadedPlaylists
        
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.my_downloads_screen, traits: traits)
    }
    
    func trackReminderDetails(objReminderDetail : ReminderListDataModel?) {
        var traits = [String:String]()
        
        if let objReminder = objReminderDetail {
            traits["reminderId"] = objReminder.ReminderId
            traits["playlistId"] = objReminder.PlaylistId
            traits["playlistName"] = objReminder.PlaylistName
            traits["playlistType"] = objReminder.Created == "1" ? "Created" : "Default"
            traits["reminderStatus"] = objReminder.IsCheck
            traits["reminderTime"] = objReminder.ReminderTime
            traits["reminderDay"] = objReminder.ReminderDay
        }
        
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.editReminder, traits: traits)
    }
    
    func trackReminderScreenViewed(arrayReminders : [ReminderListDataModel]) {
        var traits = [String:Any]()
        
        var reminders = [[String:String]]()
        
        for reminder in arrayReminders {
            let reminderDetails = ["reminderId":reminder.ReminderId,
                                   "playlistId":reminder.PlaylistId,
                                   "playlistName":reminder.PlaylistName,
                                   "playlistType":reminder.Created == "1" ? "Created" : "Default",
                                   "reminderStatus":reminder.IsCheck,
                                   "reminderTime":reminder.ReminderTime,
                                   "reminderDay":reminder.ReminderDay]
            reminders.append(reminderDetails)
        }
        
        traits["reminders"] = reminders
        
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.reminder, traits: traits)
    }
    
}

extension UserListVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["userID":CoUserDataModel.currentUserId,
                                     "userGroupId":LoginDataModel.currentMainAccountId,
                                     "isAdmin":CoUserDataModel.currentUser?.isAdminUser ?? false,
                                     "maxuseradd":maxUsers]
        
        var users = [[String:String]]()
        
        for userData in arrayUsers {
            let userDetails = ["userID":userData.UserId,
                               "name":userData.Name,
                               "mobile":userData.Mobile,
                               "email":userData.Email,
                               "image":userData.Image,
                               "dob":userData.DOB]
            users.append(userDetails)
        }
        
        traits["userList"] = users
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.coUserList, traits: traits, trackingType: .screen)
    }
    
}

extension UserListPopUpVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["userID":CoUserDataModel.currentUserId,
                                     "userGroupId":LoginDataModel.currentMainAccountId,
                                     "isAdmin":CoUserDataModel.currentUser?.isAdminUser ?? false,
                                     "maxuseradd":maxUsers]
        
        var users = [[String:String]]()
        
        for userData in arrayUsers {
            let userDetails = ["userID":userData.UserId,
                               "name":userData.Name,
                               "mobile":userData.Mobile,
                               "email":userData.Email,
                               "image":userData.Image,
                               "dob":userData.DOB]
            users.append(userDetails)
        }
        
        traits["userList"] = users
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.userListPopup, traits: traits, trackingType: .screen)
    }
    
}

extension AreaOfFocusVC {
    
    func trackScreenData() {
        if let userDetails = CoUserDataModel.currentUser {
            var traits : [String:Any] = [
                "avgSleepTime":userDetails.AvgSleepTime
            ]
            
            var areaOfFocusArray = [[String:Any]]()
            
            for areaOfFocus in userDetails.AreaOfFocus {
                let objAreaOfFocus = ["MainCat":areaOfFocus.MainCat,"RecommendedCat":areaOfFocus.RecommendedCat]
                areaOfFocusArray.append(objAreaOfFocus)
            }
            
            traits["areaOfFocus"] = areaOfFocusArray
            
            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Area_of_Focus_Saved, traits: traits)
        }
    }
    
}

// MARK:- Manage Module

extension ManageVC {
    
    func trackScreenData() {
        if shouldTrackScreen == false {
            return
        }
        
        shouldTrackScreen = false
        
        let sections = self.arrayAudioHomeData.map { $0.View }
        var traits : [String:Any] = ["sections":sections]
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.enhance, traits: traits)
    }
    
}


extension ViewAllAudioVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["source":libraryView]
        
        if libraryView == Theme.strings.top_categories {
            traits["categoryName"] = self.categoryName
        }
        
        var audios = [[String:String]]()
        
        for audio in self.homeData.Details {
            let audioDetails = ["audioId":audio.ID,
                                "audioName":audio.Name,
                                "masterCategory":audio.Audiomastercat,
                                "subCategory":audio.AudioSubCategory,
                                "audioDuration":audio.AudioDuration]
            audios.append(audioDetails)
        }
        
        traits["audios"] = audios
        
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.audio_view_all, traits: traits)
    }
    
}


// MARK:- Playlist Module

extension PlaylistCategoryVC {
    
    func trackScreenData() {
        if shouldTrackScreen == false {
            return
        }
        
        shouldTrackScreen = false
        
        let sections = self.arrayPlaylistHomeData.map { $0.View }
        let traits : [String:Any] = ["sections":sections]
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.playlist, traits: traits)
    }
    
}


extension ViewAllPlaylistVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["section":libraryTitle]
        var playlists = [[String:String]]()
        
        for playlist in self.homeData.Details {
            let totalhour = playlist.Totalhour.trim.count > 0 ? playlist.Totalhour : "0"
            let totalminute = playlist.Totalminute.trim.count > 0 ? playlist.Totalminute : "0"
            let totalDuration = "\(totalhour)h \(totalminute)m"
            
            let playlistDetails = ["playlistId":playlist.PlaylistID,
                                   "playlistName":playlist.PlaylistName,
                                   "playlistType":playlist.Created == "1" ? "Created" : "Default",
                                   "playlistDuration":totalDuration,
                                   "audioCount":playlist.TotalAudio]
            playlists.append(playlistDetails)
        }
        
        traits["playlists"] = playlists
        
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.playlist_view_all, traits: traits)
    }
    
}


// MARK:- Search Module

extension AddAudioViewAllVC {
    
    func trackScreenData() {
        let eventName = isFromPlaylist ? SegmentTracking.screenNames.suggested_playlist_list : SegmentTracking.screenNames.suggested_audio_list
        var traits : [String:Any] = ["source": isComeFromAddAudio ? "Add Audio Screen" : "Search Screen"]
        
        
        if isFromPlaylist {
            var playlists = [[String:String]]()
            
            for playlist in self.arrayPlayList {
                let totalhour = playlist.Totalhour.trim.count > 0 ? playlist.Totalhour : "0"
                let totalminute = playlist.Totalminute.trim.count > 0 ? playlist.Totalminute : "0"
                let totalDuration = "\(totalhour)h \(totalminute)m"
                
                let playlistDetails = ["playlistId":playlist.PlaylistID,
                                       "playlistName":playlist.PlaylistName,
                                       "playlistType":playlist.Created == "1" ? "Created" : "Default",
                                       "playlistDuration":totalDuration,
                                       "audioCount":playlist.TotalAudio]
                playlists.append(playlistDetails)
            }
            
            traits["playlists"] = playlists
        } else {
            var audios = [[String:String]]()
            
            for audio in self.arrayAudio {
                let audioDetails = ["audioId":audio.ID,
                                    "audioName":audio.Name,
                                    "masterCategory":audio.Audiomastercat,
                                    "subCategory":audio.AudioSubCategory,
                                    "audioDuration":audio.AudioDuration]
                audios.append(audioDetails)
            }
            
            traits["audios"] = audios
        }
        
        SegmentTracking.shared.trackGeneralScreen(name: eventName, traits: traits)
    }
    
}


extension AddToPlaylistVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["source":self.source]
        var playlists = [[String:String]]()
        
        for playlist in self.arrayPlaylist {
            // let totalhour = playlist.Totalhour.trim.count > 0 ? playlist.Totalhour : "0"
            // let totalminute = playlist.Totalminute.trim.count > 0 ? playlist.Totalminute : "0"
            // let totalDuration = "\(totalhour)h \(totalminute)m"
            
            let playlistDetails = [
                "playlistId":playlist.PlaylistID,
                "playlistName":playlist.PlaylistName,
                "playlistType": "", // playlist.Created == "1" ? "Created" : "Default",
                "playlistDuration": "", // totalDuration,
                "audioCount": "" // playlist.TotalAudio]
            ]
            playlists.append(playlistDetails)
        }
        
        traits["playlists"] = playlists
        
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.add_to_playlist, traits: traits)
    }
    
}

