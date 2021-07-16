//
//  Segment+Functions.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 10/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import Segment
import AVKit

enum TrackingType {
    case identify
    case screen
    case track
}

class SegmentTracking {
    
    static var shared = SegmentTracking()
    
    static var screenNames = ScreenNames()
    static var eventNames = EventNames()
    
    var isConfigured = false
    
    // Segment Write Keys
    // segmentWriteKey = "43bAg2MDfphRaYWFqZvWo7nxNhVtg8jt" // dhruvit@qltech.com.au
    // segmentWriteKeySapna = "MpDOpy9WI8Kt86nteyY5aNAML5F9PMTd" // sapna@qltech.com.au
    var segmentWriteKey : String {
        get {
            return UserDefaults.standard.string(forKey: "segmentWriteKey") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "segmentWriteKey")
            UserDefaults.standard.synchronize()
        }
    }
    
    var userIdentityTracked : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "userIdentityTracked")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userIdentityTracked")
            UserDefaults.standard.synchronize()
        }
    }
    
    func configureSegment(launchOptions : [AnyHashable : Any]? = nil) {
        if segmentWriteKey.trim.count > 0 {
            isConfigured = true
            
            let configuration = AnalyticsConfiguration(writeKey: segmentWriteKey)
            configuration.trackApplicationLifecycleEvents = true
            configuration.trackDeepLinks = true
            configuration.trackPushNotifications = true
            configuration.recordScreenViews = false
            if launchOptions != nil {
                configuration.launchOptions = launchOptions
            }
            Analytics.setup(with: configuration)
            Analytics.debug(true)
        }
    }
    
    func trackEvent(name : String, traits : [String:Any]?, trackingType : TrackingType) {
        if isConfigured == false {
            return
        }
        
        var newTraits = [String:Any]()
        if let oldTraits = traits {
            for (key,value) in oldTraits {
                newTraits[key] = value
            }
        }
        
        newTraits["deviceType"] = "iOS"
        newTraits["appVersion"] = APP_VERSION
        newTraits["deviceID"] = DEVICE_UUID
        newTraits["batteryLevel"] = NSString(format: "%0.0f",APPDELEGATE.batteryLevel)
        newTraits["batteryState"] = APPDELEGATE.batteryState
        
        if name == "Audio Interrupted" || name == "Disclaimer Interrupted" {
            self.callAudioInterruptionAPI(parameters: newTraits)
        }
        
        switch trackingType {
        case .identify:
            Analytics.shared().identify(name, traits: traits)
            break
        case .screen:
            Analytics.shared().screen(name, properties: newTraits)
            break
        case .track:
            Analytics.shared().track(name, properties: newTraits)
            break
        }
    }
    
    func identifyUser() {
        if let userDetails = CoUserDataModel.currentUser {
            userIdentityTracked = true
            
            let userName = userDetails.Name.trim.count > 0 ? userDetails.Name : "Guest"
            
            var dictUserDetails : [String:Any] = [
                "userId":CoUserDataModel.currentUserId,
                "userGroupId":LoginDataModel.currentMainAccountId,
                "isAdmin":userDetails.isAdminUser,
                "id":CoUserDataModel.currentUserId,
                "deviceId":DEVICE_UUID,
                "deviceType":"iOS",
                "name":userName,
                "email":userDetails.Email,
                "phone":userDetails.Mobile,
                "dob":userDetails.DOB,
                "profileImage":userDetails.Image,
                "isProfileCompleted":userDetails.isProfileCompleted,
                "isAssessmentCompleted":userDetails.isAssessmentCompleted,
                "wellnessScore":userDetails.indexScore,
                "scoreLevel":userDetails.ScoreLevel,
                "avgSleepTime":userDetails.AvgSleepTime
            ]
            
            var areaOfFocusArray = [[String:Any]]()
            
            for areaOfFocus in userDetails.AreaOfFocus {
                let objAreaOfFocus = ["MainCat":areaOfFocus.MainCat,"RecommendedCat":areaOfFocus.RecommendedCat]
                areaOfFocusArray.append(objAreaOfFocus)
            }
            
            dictUserDetails["areaOfFocus"] = areaOfFocusArray
            
            // "Plan":userDetails.planDetails,
            // "PlanStatus":userDetails.PlanStatus,
            // "planStartDt":userDetails.PlanStartDt,
            // "planExpiryDt":userDetails.PlanExpiryDate,
            // "countryCode":userDetails.CountryCode,
            // "countryName":userDetails.CountryName]
            
            SegmentTracking.shared.trackEvent(name: CoUserDataModel.currentUserId, traits: dictUserDetails, trackingType: .identify)
        }
    }
    
    func coUserEvent(name : String, trackingType : TrackingType) {
        if let userDetails = CoUserDataModel.currentUser {
            
            let userName = userDetails.Name.trim.count > 0 ? userDetails.Name : "Guest"
            
            var dictUserDetails : [String:Any] = [
                "userId":CoUserDataModel.currentUserId,
                "userGroupId":LoginDataModel.currentMainAccountId,
                "isAdmin":userDetails.isAdminUser,
                "id":CoUserDataModel.currentUserId,
                "deviceId":DEVICE_UUID,
                "deviceType":"iOS",
                "name":userName,
                "email":userDetails.Email,
                "phone":userDetails.Mobile,
                "dob":userDetails.DOB,
                "profileImage":userDetails.Image,
                "isProfileCompleted":userDetails.isProfileCompleted,
                "isAssessmentCompleted":userDetails.isAssessmentCompleted,
                "wellnessScore":userDetails.indexScore,
                "scoreLevel":userDetails.ScoreLevel,
                "avgSleepTime":userDetails.AvgSleepTime
            ]
            
            var areaOfFocusArray = [[String:Any]]()
            
            for areaOfFocus in userDetails.AreaOfFocus {
                let objAreaOfFocus = ["MainCat":areaOfFocus.MainCat,"RecommendedCat":areaOfFocus.RecommendedCat]
                areaOfFocusArray.append(objAreaOfFocus)
            }
            
            dictUserDetails["areaOfFocus"] = areaOfFocusArray
            
            // "Plan":userDetails.planDetails,
            // "PlanStatus":userDetails.PlanStatus,
            // "planStartDt":userDetails.PlanStartDt,
            // "planExpiryDt":userDetails.PlanExpiryDate,
            // "countryCode":userDetails.CountryCode,
            // "countryName":userDetails.CountryName]
            
            SegmentTracking.shared.trackEvent(name: name, traits: dictUserDetails, trackingType: trackingType)
        }
    }
    
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
    
    func reset() {
        Analytics.shared().reset()
    }
    
    func flush() {
        Analytics.shared().flush()
    }
    
}
