//
//  Segment+EventTracking.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 19/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import AVKit


extension SegmentTracking {
    
    // MARK:- Audio Screen & Event Traking
    
    // Track Audio Player Events
    func callAudioInterruptionAPI(parameters : [String:Any]) {
        APICallManager.sharedInstance.callAPI(router: APIRouter.audiointerruption(parameters), displayHud: false, showToast: false) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                print("API - Audio Interruption")
            }
        }
    }
    
    func getPlayTime(totalSeconds : Double) -> String {
        if totalSeconds.isNaN || totalSeconds.isInfinite || totalSeconds < 0 {
            return "00:00"
        }
        
        let currentTime = totalSeconds
        let hours = Int((currentTime / 60) / 60)
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        let playTime = String(format: "%02d:%02d", minutes, seconds)
        let duration = DJMusicPlayer.shared.currentlyPlaying?.AudioDuration ?? "00:00"
        let progress = String(format: "%0.3f",DJMusicPlayer.shared.progress)
        print(" - (progress - \(progress)) : (playTime - \(playTime)) : (duration - \(duration))")
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func audioPlaybackEvents(name : String, audioData : AudioDetailsDataModel?, interruptionMethod : String? = nil, seekDirection : String? = nil, seekPosition : Double? = nil ,trackingType : TrackingType) {
        var data = audioData
        
        if let audioData = DJMusicPlayer.shared.currentlyPlaying {
            data = audioData
        }
        
        guard let audioDetails = data else {
            return
        }
        
        var traits = ["audioId":audioDetails.ID,
                      "audioName":audioDetails.Name,
                      "audioDescription":audioDetails.AudioDescription,
                      "directions":audioDetails.AudioDirection,
                      "masterCategory":audioDetails.Audiomastercat,
                      "subCategory":audioDetails.AudioSubCategory,
                      "audioDuration":audioDetails.AudioDuration,
                      "bitRate":audioDetails.Bitrate]
        
        if audioDetails.isDisclaimer == true {
            traits = ["bitRate":audioDetails.Bitrate]
        }
        
        // Extra Parameters
        traits["audioType"] = DJDownloadManager.shared.checkFileExists(fileName: audioDetails.AudioFile) ? "Downloaded" : "Streaming"
        traits["playerType"] = DJMusicPlayer.shared.playerScreen.rawValue
        
        let sound : Int = Int(AVAudioSession.sharedInstance().outputVolume * 100)
        traits["sound"] = "\(sound)"
        
        switch UIApplication.shared.applicationState {
        case .active:
            traits["audioService"] = "Foreground"
        default:
            traits["audioService"] = "Background"
        }
        
        
        switch DJMusicPlayer.shared.playerType {
        case .playlist:
            traits["source"] = Theme.strings.playlist
            break
        case .downloadedPlaylist:
            traits["source"] = Theme.strings.downloaded_playlists
            break
        case .topCategories:
            traits["source"] = Theme.strings.top_categories
            break
        case .downloadedAudios:
            traits["source"] = Theme.strings.downloaded_audios
            break
        case .likedAudios:
            traits["source"] = "Liked Audios"
            break
        case .recentlyPlayed:
            traits["source"] = Theme.strings.recently_played
            break
        case .library:
            traits["source"] = Theme.strings.library
            break
        case .getInspired:
            traits["source"] = Theme.strings.get_inspired
            break
        case .popular:
            traits["source"] = Theme.strings.popular_audio
            break
        case .searchAudio:
            traits["source"] = DJMusicPlayer.shared.playingFrom
            break
        default:
            traits["source"] = DJMusicPlayer.shared.playingFrom
            break
        }
        
        traits["position"] = getPlayTime(totalSeconds: DJMusicPlayer.shared.currentTime)
        if let seekPosition = seekPosition {
            traits["seekPosition"] = getPlayTime(totalSeconds: seekPosition)
            if let seekDirection = seekDirection {
                traits["seekDirection"] = seekDirection
            }
        }
        
        if let interruptionMethod = interruptionMethod {
            traits["interruptionMethod"] = interruptionMethod
        }
        
        if trackingType == .screen {
            SegmentTracking.shared.trackGeneralScreen(name: name, traits: traits)
        } else {
            SegmentTracking.shared.trackGeneralEvents(name: name, traits: traits)
        }
    }
    
    func audioPlayerActions(name : String, audioData : AudioDetailsDataModel?, source : String = "", trackingType : TrackingType) {
        var data = audioData
        
        if let audioData = DJMusicPlayer.shared.currentlyPlaying {
            data = audioData
        }
        
        guard let audioDetails = data else {
            return
        }
        
        var traits = ["audioId":audioDetails.ID,
                      "audioName":audioDetails.Name,
                      "audioDescription":audioDetails.AudioDescription,
                      "directions":audioDetails.AudioDirection,
                      "masterCategory":audioDetails.Audiomastercat,
                      "subCategory":audioDetails.AudioSubCategory,
                      "audioDuration":audioDetails.AudioDuration,
                      "bitRate":audioDetails.Bitrate]
        
        if audioDetails.isDisclaimer == true {
            traits = ["bitRate":audioDetails.Bitrate]
        }
        
        // Extra Parameters
        traits["audioType"] = DJDownloadManager.shared.checkFileExists(fileName: audioDetails.AudioFile) ? "Downloaded" : "Streaming"
        traits["playerType"] = DJMusicPlayer.shared.playerScreen.rawValue
        
        switch UIApplication.shared.applicationState {
        case .active:
            traits["audioService"] = "Foreground"
        default:
            traits["audioService"] = "Background"
        }
        
        if DJMusicPlayer.shared.currentlyPlaying?.ID == audioData?.ID {
            let sound : Int = Int(AVAudioSession.sharedInstance().outputVolume * 100)
            traits["sound"] = "\(sound)"
            
            traits["position"] = getPlayTime(totalSeconds: DJMusicPlayer.shared.currentTime)
        }
        
        if source.trim.count > 0 {
            traits["source"] = source
        }
        
        if trackingType == .screen {
            SegmentTracking.shared.trackGeneralScreen(name: name, traits: traits)
        } else {
            SegmentTracking.shared.trackGeneralEvents(name: name, traits: traits)
        }
    }
    
    // Track Audio Detail Events
    func audioDetailsEvents(name : String, audioData : AudioDetailsDataModel?, source : String = "", audioSortPositons : (Int,Int)? = nil, trackingType : TrackingType) {
        guard let audioDetails = audioData else {
            return
        }
        
        var traits = ["audioId":audioDetails.ID,
                      "audioName":audioDetails.Name,
                      "audioDescription":audioDetails.AudioDescription,
                      "directions":audioDetails.AudioDirection,
                      "masterCategory":audioDetails.Audiomastercat,
                      "subCategory":audioDetails.AudioSubCategory,
                      "audioDuration":audioDetails.AudioDuration,
                      "bitRate":audioDetails.Bitrate]
        
        if audioDetails.isDisclaimer == true {
            traits = ["bitRate":audioDetails.Bitrate]
        }
        
        // Extra Parameters
        traits["audioType"] = DJDownloadManager.shared.checkFileExists(fileName: audioDetails.AudioFile) ? "Downloaded" : "Streaming"
        
        switch UIApplication.shared.applicationState {
        case .active:
            traits["audioService"] = "Foreground"
        default:
            traits["audioService"] = "Background"
        }
        
        if DJMusicPlayer.shared.currentlyPlaying?.ID == audioData?.ID {
            let sound : Int = Int(AVAudioSession.sharedInstance().outputVolume * 100)
            traits["sound"] = "\(sound)"
            
            traits["position"] = getPlayTime(totalSeconds: DJMusicPlayer.shared.currentTime)
        }
        
        if source.trim.count > 0 {
            traits["source"] = source
        }
        
        if let sortPosition = audioSortPositons {
            traits["audioSortPosition"] = "\(sortPosition.0)"
            traits["audioSortPositionNew"] = "\(sortPosition.1)"
        }
        
        if trackingType == .screen {
            SegmentTracking.shared.trackGeneralScreen(name: name, traits: traits)
        } else {
            SegmentTracking.shared.trackGeneralEvents(name: name, traits: traits)
        }
    }
    
    // Track - Add Audio To Playlist
    func addAudioToPlaylistEvent(audioData : AudioDetailsDataModel?, source : String = "") {
        guard let audioDetails = audioData else {
            return
        }
        
        var traits = ["audioId":audioDetails.ID,
                      "audioName":audioDetails.Name,
                      "audioDescription":audioDetails.AudioDescription,
                      "directions":audioDetails.AudioDirection,
                      "masterCategory":audioDetails.Audiomastercat,
                      "subCategory":audioDetails.AudioSubCategory,
                      "audioDuration":audioDetails.AudioDuration,
                      "bitRate":audioDetails.Bitrate]
        
        if audioDetails.isDisclaimer == true {
            traits = ["bitRate":audioDetails.Bitrate]
        }
        
        // Extra Parameters
        traits["audioType"] = DJDownloadManager.shared.checkFileExists(fileName: audioDetails.AudioFile) ? "Downloaded" : "Streaming"
        
        if source.trim.count > 0 {
            traits["source"] = source
        }
        
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Add_to_Playlist_Clicked, traits: traits)
    }
    
    // MARK:- Playlist Screen & Event Traking
    
    // Track Playlist Events
    func playlistEvents(name : String, objPlaylist : PlaylistDetailsModel?, passPlaybackDetails : Bool = false, passPlayerType : Bool = false, audioData : AudioDetailsDataModel? = nil, audioSortPositons : (Int,Int)? = nil, trackingType : TrackingType) {
        if let playlistDetails = objPlaylist {
            var traits = ["playlistId":playlistDetails.PlaylistID,
                          "playlistName":playlistDetails.PlaylistName,
                          "playlistDescription":playlistDetails.PlaylistDesc,
                          "audioCount":playlistDetails.TotalAudio]
            
            if playlistDetails.Created == "1" {
                traits["playlistType"] = "Created"
            } else if playlistDetails.Created == "2" {
                traits["playlistType"] = "Suggested"
            } else {
                traits["playlistType"] = "Default"
            }
            
            let totalhour = playlistDetails.Totalhour.trim.count > 0 ? playlistDetails.Totalhour : "0"
            let totalminute = playlistDetails.Totalminute.trim.count > 0 ? playlistDetails.Totalminute : "0"
            traits["playlistDuration"] = "\(totalhour)h \(totalminute)m"
            
            if playlistDetails.sectionName.trim.count > 0 {
                traits["source"] = playlistDetails.sectionName
            }
            
            // Extra Parameters
            if passPlaybackDetails {
                let sound : Int = Int(AVAudioSession.sharedInstance().outputVolume * 100)
                traits["sound"] = "\(sound)"
                
                switch UIApplication.shared.applicationState {
                case .active:
                    traits["audioService"] = "Foreground"
                default:
                    traits["audioService"] = "Background"
                }
            }
            
            if passPlayerType {
                traits["playerType"] = DJMusicPlayer.shared.playerScreen.rawValue
            }
            
            // Audio Parameters
            if let audioDetails = audioData {
                traits["audioId"] = audioDetails.ID
                traits["audioName"] = audioDetails.Name
                traits["masterCategory"] = audioDetails.Audiomastercat
                traits["subCategory"] = audioDetails.AudioSubCategory
                
                if let sortPosition = audioSortPositons {
                    traits["audioSortPosition"] = "\(sortPosition.0)"
                    traits["audioSortPositionNew"] = "\(sortPosition.1)"
                }
            }
            
            if trackingType == .screen {
                SegmentTracking.shared.trackGeneralScreen(name: name, traits: traits)
            } else {
                SegmentTracking.shared.trackGeneralEvents(name: name, traits: traits)
            }
        }
    }
    
    // Playlist Detail Events
    func playlistDetailEvents(name : String, objPlaylist : PlaylistDetailsModel?, source : String = "", trackingType : TrackingType) {
        if let playlistDetails = objPlaylist {
            var traits = ["playlistId":playlistDetails.PlaylistID,
                          "playlistName":playlistDetails.PlaylistName,
                          "playlistDescription":playlistDetails.PlaylistDesc,
                          "audioCount":playlistDetails.TotalAudio]
            
            if playlistDetails.Created == "1" {
                traits["playlistType"] = "Created"
            } else if playlistDetails.Created == "2" {
                traits["playlistType"] = "Suggested"
            } else {
                traits["playlistType"] = "Default"
            }
            
            let totalhour = playlistDetails.Totalhour.trim.count > 0 ? playlistDetails.Totalhour : "0"
            let totalminute = playlistDetails.Totalminute.trim.count > 0 ? playlistDetails.Totalminute : "0"
            traits["playlistDuration"] = "\(totalhour)h \(totalminute)m"
            
            if source.trim.count > 0 {
                traits["source"] = source
            }
            
            if trackingType == .screen {
                SegmentTracking.shared.trackGeneralScreen(name: name, traits: traits)
            } else {
                SegmentTracking.shared.trackGeneralEvents(name: name, traits: traits)
            }
        }
    }
    
    // Track - Add Playlist To Playlist
    func addPlaylistToPlaylistEvent(objPlaylist : PlaylistDetailsModel?, source : String = "") {
        if let playlistDetails = objPlaylist {
            var traits = ["playlistId":playlistDetails.PlaylistID,
                          "playlistName":playlistDetails.PlaylistName,
                          "playlistDescription":playlistDetails.PlaylistDesc,
                          "audioCount":playlistDetails.TotalAudio]
            
            if playlistDetails.Created == "1" {
                traits["playlistType"] = "Created"
            } else if playlistDetails.Created == "2" {
                traits["playlistType"] = "Suggested"
            } else {
                traits["playlistType"] = "Default"
            }
            
            let totalhour = playlistDetails.Totalhour.trim.count > 0 ? playlistDetails.Totalhour : "0"
            let totalminute = playlistDetails.Totalminute.trim.count > 0 ? playlistDetails.Totalminute : "0"
            traits["playlistDuration"] = "\(totalhour)h \(totalminute)m"
            
            if source.trim.count > 0 {
                traits["source"] = source
            }
            
            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Add_to_Playlist_Clicked, traits: traits)
        }
    }
    
    // Track - Reminder Events
    func trackReminderDetails(name : String, reminder : ReminderListDataModel?, trackingType : TrackingType) {
        if let reminderDetails = reminder {
            var traits = ["reminderId":reminderDetails.ReminderId,
                          "playlistId":reminderDetails.PlaylistId,
                          "playlistName":reminderDetails.PlaylistName,
                          "reminderStatus":reminderDetails.IsCheck,
                          "reminderTime":reminderDetails.ReminderTime,
                          "reminderDay":reminderDetails.RDay]
            
            if reminderDetails.Created == "1" {
                traits["playlistType"] = "Created"
            } else if reminderDetails.Created == "2" {
                traits["playlistType"] = "Suggested"
            } else {
                traits["playlistType"] = "Default"
            }
            
            if trackingType == .screen {
                SegmentTracking.shared.trackGeneralScreen(name: name, traits: traits)
            } else {
                SegmentTracking.shared.trackGeneralEvents(name: name, traits: traits)
            }
        }
    }
    
    func trackReminderDetails(name : String, playlist : PlaylistDetailsModel?, trackingType : TrackingType) {
        if let playlistDetails = playlist {
            var traits = ["reminderId":playlistDetails.ReminderId,
                          "playlistId":playlistDetails.PlaylistID,
                          "playlistName":playlistDetails.PlaylistName,
                          "reminderStatus":playlistDetails.IsReminder,
                          "reminderTime":playlistDetails.ReminderTime,
                          "reminderDay":playlistDetails.ReminderDay]
            
            if playlistDetails.Created == "1" {
                traits["playlistType"] = "Created"
            } else if playlistDetails.Created == "2" {
                traits["playlistType"] = "Suggested"
            } else {
                traits["playlistType"] = "Default"
            }
            
            SegmentTracking.shared.trackGeneralEvents(name: name, traits: traits)
        }
    }
    
    func trackPlanDetails(name : String, planDetails : PlanDetailsModel?, trackingType : TrackingType) {
        guard let planData = planDetails else {
            return
        }
        
        var planPrice = "$" + planData.PlanAmount
        if planData.iapPrice.trim.count > 0 {
            planPrice = planData.iapPrice
        }
        
        let traits = ["planId":"",
                      "plan":planData.SubName,
                      "planAmount":planPrice,
                      "planInterval":planData.PlanInterval,
                      "totalProfile":planData.ProfileCount]
        
        if trackingType == .screen {
            SegmentTracking.shared.trackGeneralScreen(name: name, traits: traits)
        } else {
            SegmentTracking.shared.trackGeneralEvents(name: name, traits: traits)
        }
    }
    
}
