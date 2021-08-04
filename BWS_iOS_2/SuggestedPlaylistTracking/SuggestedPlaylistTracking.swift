//
//  SuggestedPlaylistTracking.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 02/08/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import UIKit
import EVReflection

class ActivityTrackDataModel:EVObject {
    var UserId = ""
    var AudioId = ""
    var PlaylistId = ""
    var StartTime = ""
    var CompletedTime = ""
    var Volume = ""
}

class SuggestedPlaylistTracking {
    
    // MARK:- VARIABLES
    static var shared = SuggestedPlaylistTracking()
    var arrayActivity = [ActivityTrackDataModel]()
    var arrayDownload = [[String:Any]]()
    var startTime:String?
    var completedTime:String?
    
    //Track activity offline and online with timestamp
    func trackActivity(activityName:String, audioData:AudioDetailsDataModel) {
        guard let playlistData = DJMusicPlayer.shared.currentPlaylist else {
            return
        }
        
        if  playlistData.Created != "2"  && (DJMusicPlayer.shared.playerType != .playlist || DJMusicPlayer.shared.playerType != .downloadedPlaylist) {
            return
        }
        
        if DJMusicPlayer.shared.playbackState == .playing {
            let timeStamp = Date.currentTimeStamp
            startTime = "\(timeStamp)"
        }else {
            let timeStamp = Date.currentTimeStamp
            completedTime = "\(timeStamp)"
        }
        
        if checkInternet(showToast: false) == false {
            storeActivityTrack(audioData:audioData,startTime:startTime,completedTime:completedTime)
            
        } else {
            if downloadPlaylist != nil {
                guard downloadPlaylist != nil else {
                    return
                }
                let dataValue = UserDefaults.standard.array(forKey: "DownloadPlaylist")
                callAudioActivityTracking(trackingData:arrayActivity,audioData:audioData, arrayDownload: dataValue ?? [])
                
                UserDefaults.standard.removeObject(forKey: "downloadPlaylist")
                UserDefaults.standard.removeObject(forKey: "DownloadPlaylist")
                arrayActivity.removeAll()
            }else {
                arrayActivity.removeAll()
                storeActivityTrack(audioData:audioData,startTime:startTime,completedTime:completedTime)
                callAudioActivityTracking(trackingData:arrayActivity,audioData:audioData, arrayDownload: [])
            }
        }
    }
    
    // API for userActivityTrack - suggested Playlist
    func callAudioActivityTracking(trackingData:[ActivityTrackDataModel],audioData:AudioDetailsDataModel ,arrayDownload:[Any]) {
        let parameters:[String:Any]
        if arrayActivity.count > 0 {
            parameters = ["TrackingData":trackingData.toJsonString()]
        }else {
            let data = convertIntoJSONString(arrayObject: arrayDownload)
            parameters = ["TrackingData":data ?? []]
        }
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.useraudiotracking(parameters), displayHud: false, showToast: false) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                
            } else {
                self.storeActivityTrack(audioData:audioData,startTime:self.startTime,completedTime:self.completedTime)
            }
        }
    }
    
    //stored data for downloaded playing data
    func storeActivityTrack(audioData:AudioDetailsDataModel,startTime:String?,completedTime:String?) {
        let trackData = [APIParameters.UserId:CoUserDataModel.currentUserId,
                         "AudioId":audioData.ID ,
                         "PlaylistId":audioData.PlaylistID ,
                         "StartTime":startTime ?? "",
                         "CompletedTime":completedTime ?? "",
                         "Volume":"\(DJMusicPlayer.shared.audioPlayer.volume)"]
        
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(trackData) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                let dataActivity = ActivityTrackDataModel(data: jsonData)
                if checkInternet(showToast: false) == false {
                    downloadPlaylist = dataActivity
                    arrayDownload.append(trackData)
                    UserDefaults.standard.setValue(arrayDownload, forKey: "DownloadPlaylist")
                } else {
                    arrayActivity.append(dataActivity)
                }
            }
        }
    }
    
    // userdefaults
    var downloadPlaylist : ActivityTrackDataModel? {
        get {
            if let downloadData = UserDefaults.standard.data(forKey: "downloadPlaylist") {
                return ActivityTrackDataModel(data: downloadData)
            }
            return nil
        }
        set {
            if let newData = newValue {
                UserDefaults.standard.setValue(newData.toJsonData(), forKey: "downloadPlaylist")
            } else {
                UserDefaults.standard.setValue(nil, forKey: "downloadPlaylist")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
