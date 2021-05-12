//
//  Segment+ScreenTracking.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 10/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation

extension SegmentTracking {
    
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
        
        SegmentTracking.shared.trackEvent(name: "My Download Screen Viewed", traits: traits, trackingType: .screen)
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
        
        SegmentTracking.shared.trackEvent(name: "My Download Screen Viewed", traits: traits, trackingType: .screen)
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
        
        SegmentTracking.shared.trackEvent(name: "Add/Edit Reminder Screen Viewed", traits: traits, trackingType: .screen)
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
        
        SegmentTracking.shared.trackEvent(name: "Reminder Screen Viewed", traits: traits, trackingType: .screen)
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
        
        SegmentTracking.shared.trackEvent(name: "Couser List Viewed", traits: traits, trackingType: .screen)
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
        
        SegmentTracking.shared.trackEvent(name: "User List Popup Viewed", traits: traits, trackingType: .screen)
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
            
            SegmentTracking.shared.trackEvent(name: "Area of Focus Saved", traits: dictUserDetails, trackingType: .track)
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
        SegmentTracking.shared.trackEvent(name: "Manage Screen Viewed", traits: traits, trackingType: .screen)
    }
    
}


extension ViewAllAudioVC {
    
    func trackScreenData() {
        var traits : [String:Any] = ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""]
        
        var screenName = "Recently Played Viewed"
        if libraryView.trim.count > 0 {
            switch libraryView {
            case "Recently Played":
                screenName = "Recently Played Viewed"
            case "My Downloads":
                screenName = "My Downloads Viewed"
            case "Library":
                screenName = "Library List Viewed"
            case "Get Inspired":
                screenName = "Get Inspired List Viewed"
            case "Popular":
                screenName = "Popular List Viewed"
            case "Top Categories":
                screenName = "Top Categories Item Viewed"
                traits["categoryName"] = self.categoryName
            default:
                break
            }
        } else {
            screenName = "Top Categories Item Viewed"
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
        
        SegmentTracking.shared.trackEvent(name: screenName, traits: traits, trackingType: .screen)
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
        SegmentTracking.shared.trackEvent(name: "Playlist Screen Viewed", traits: traits, trackingType: .screen)
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
        
        SegmentTracking.shared.trackEvent(name: "View All Playlist Screen Viewed", traits: traits, trackingType: .screen)
    }
    
}


// MARK:- Search Module

extension AddAudioViewAllVC {
    
    func trackScreenData() {
        let eventName = isFromPlaylist ? "Suggested Playlist List Viewed" : "Suggested Audios List Viewed"
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
        
        SegmentTracking.shared.trackEvent(name: "Playlist List Viewed", traits: traits, trackingType: .screen)
    }
    
}

