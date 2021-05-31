//
//  Segment+ScreenTracking.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 10/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation

extension SegmentTracking {
    
    func trackGeneralScreen(name : String, traits : [String:Any]? = nil, passUserID : Bool = false) {
        var newTraits = [String : Any]()
        if let allTraits = traits {
            for (key,value) in allTraits {
                newTraits[key] = value
            }
        }
        
        if let CoUserId = CoUserDataModel.currentUser?.CoUserId {
            newTraits["CoUserId"] = CoUserId
        }
        
        if passUserID {
            if let UserId = CoUserDataModel.currentUser?.UserID {
                newTraits["UserId"] = UserId
            } else if let UserId = LoginDataModel.currentUser?.ID {
                newTraits["UserId"] = UserId
            }
        }
        
        SegmentTracking.shared.trackEvent(name: name, traits: newTraits, trackingType: .screen)
    }
    
    func trackGeneralEvents(name : String, traits : [String:Any]? = nil, passUserID : Bool = false) {
        var newTraits = [String : Any]()
        if let allTraits = traits {
            for (key,value) in allTraits {
                newTraits[key] = value
            }
        }
        
        if let CoUserId = CoUserDataModel.currentUser?.CoUserId {
            newTraits["CoUserId"] = CoUserId
        }
        
        if passUserID {
            if let UserId = CoUserDataModel.currentUser?.UserID {
                newTraits["UserId"] = UserId
            } else if let UserId = LoginDataModel.currentUser?.ID {
                newTraits["UserId"] = UserId
            }
        }
        
        SegmentTracking.shared.trackEvent(name: name, traits: newTraits, trackingType: .track)
    }
    
    func trackDownloadedAudiosScreenViewed() {
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                                     "tabType":"Audio Tab"]
        
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
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.my_downloads_screen, traits: traits, trackingType: .screen)
    }
    
    func trackDownloadedPlaylistsScreenViewed() {
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                                     "tabType":"Playlist Tab"]
        
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
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.my_downloads_screen, traits: traits, trackingType: .screen)
    }
    
    func trackReminderDetails(objReminderDetail : ReminderListDataModel?) {
        var traits = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        if let objReminder = objReminderDetail {
            traits["reminderId"] = objReminder.ReminderId
            traits["playlistId"] = objReminder.PlaylistId
            traits["playlistName"] = objReminder.PlaylistName
            traits["playlistType"] = objReminder.Created == "1" ? "Created" : "Default"
            traits["reminderStatus"] = objReminder.IsCheck
            traits["reminderTime"] = objReminder.ReminderTime
            traits["reminderDay"] = objReminder.ReminderDay
        }
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.editReminder, traits: traits, trackingType: .screen)
    }
    
    func trackReminderScreenViewed(arrayReminders : [ReminderListDataModel]) {
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
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
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.reminder, traits: traits, trackingType: .screen)
    }
    
}

extension UserListVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["UserID":CoUserDataModel.currentUser?.UserID ?? "",
                                     "maxuseradd":maxUsers]
        
        var users = [[String:String]]()
        
        for userData in arrayUsers {
            let userDetails = ["CoUserId":userData.CoUserId,
                               "Name":userData.Name,
                               "Mobile":userData.Mobile,
                               "Email":userData.Email,
                               "Image":userData.Image,
                               "DOB":userData.DOB]
            users.append(userDetails)
        }
        
        traits["coUserList"] = users
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.coUserList, traits: traits, trackingType: .screen)
    }
    
}

extension UserListPopUpVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                                     "UserID":CoUserDataModel.currentUser?.UserID ?? "",
                                     "maxuseradd":maxUsers]
        
        var users = [[String:String]]()
        
        for userData in arrayUsers {
            let userDetails = ["CoUserId":userData.CoUserId,
                               "Name":userData.Name,
                               "Mobile":userData.Mobile,
                               "Email":userData.Email,
                               "Image":userData.Image,
                               "DOB":userData.DOB]
            users.append(userDetails)
        }
        
        traits["coUserList"] = users
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.userListPopup, traits: traits, trackingType: .screen)
    }
    
}

extension AreaOfFocusVC {
    
    func trackScreenData() {
        if let userDetails = CoUserDataModel.currentUser {
            var dictUserDetails : [String:Any] = [
                "CoUserId":userDetails.CoUserId,
                "avgSleepTime":userDetails.AvgSleepTime
            ]
            
            var areaOfFocusArray = [[String:Any]]()
            
            for areaOfFocus in userDetails.AreaOfFocus {
                let objAreaOfFocus = ["MainCat":areaOfFocus.MainCat,"RecommendedCat":areaOfFocus.RecommendedCat]
                areaOfFocusArray.append(objAreaOfFocus)
            }
            
            dictUserDetails["areaOfFocus"] = areaOfFocusArray
            
            SegmentTracking.shared.trackEvent(name: SegmentTracking.eventNames.Area_of_Focus_Saved, traits: dictUserDetails, trackingType: .track)
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
        
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        let sections = self.arrayAudioHomeData.map { $0.View }
        traits["sections"] = sections
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.enhance, traits: traits, trackingType: .screen)
    }
    
}


extension ViewAllAudioVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                                     "source":libraryView]
        
        if libraryView == "Top Categories" {
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
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.audio_view_all, traits: traits, trackingType: .screen)
    }
    
}


// MARK:- Playlist Module

extension PlaylistCategoryVC {
    
    func trackScreenData() {
        if shouldTrackScreen == false {
            return
        }
        
        shouldTrackScreen = false
        
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        let sections = self.arrayPlaylistHomeData.map { $0.View }
        traits["sections"] = sections
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.playlist, traits: traits, trackingType: .screen)
    }
    
}


extension ViewAllPlaylistVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                                     "section":libraryTitle]
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
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.playlist_view_all, traits: traits, trackingType: .screen)
    }
    
}


// MARK:- Search Module

extension AddAudioViewAllVC {
    
    func trackScreenData() {
        let eventName = isFromPlaylist ? SegmentTracking.screenNames.suggested_playlist_list : SegmentTracking.screenNames.suggested_audio_list
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                                     "source": isComeFromAddAudio ? "Add Audio Screen" : "Search Screen"]
        
        
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
        
        SegmentTracking.shared.trackEvent(name: eventName, traits: traits, trackingType: .screen)
    }
    
}


extension AddToPlaylistVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "",
                                     "source":self.source]
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
        
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.add_to_playlist, traits: traits, trackingType: .screen)
    }
    
}

