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
import CoreData

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
    var arrayDownload = [UserActivity]()
    var startTime:String?
    var completedTime:String?
    var isAudioCompleted = false
    
    // MARK:- Track activity offline and online with timestamp
    func activityTrack() {
        guard let playlistData = DJMusicPlayer.shared.currentPlaylist else {
            return
        }
        
        if checkInternet(showToast: false) == false {
            checkTime(time: "\(Date.currentTimeStamp)")
            if  playlistData.selfCreated == "2"  &&  DJMusicPlayer.shared.playerType == .downloadedPlaylist {
                if let audioData = DJMusicPlayer.shared.currentlyPlaying {
                    storeAudioActivityTrack(audioData: audioData)
                }
            }
        }else {
            if  playlistData.Created == "2" || playlistData.selfCreated == "2" &&  DJMusicPlayer.shared.playerType == .playlist || DJMusicPlayer.shared.playerType == .downloadedPlaylist{
                
                if let audioData = DJMusicPlayer.shared.currentlyPlaying {
                    arrayDownload.removeAll()
                    arrayActivity.removeAll()
                    fetchAudioActivityTrack(audiodata: audioData)
                }else {
                    for audioData in playlistData.PlaylistSongs {
                        arrayDownload.removeAll()
                        arrayActivity.removeAll()
                        fetchAudioActivityTrack(audiodata: audioData)
                    }
                }
            }
        }
        
    }
    
    
    // MARK:-  API for userActivityTrack - suggested Playlist
    func callAudioActivityTracking(trackingData:[ActivityTrackDataModel],audioData:AudioDetailsDataModel) {
        let data  = trackingData.removingDuplicates()
        let parameters = ["TrackingData":data.toJsonString()]
        
        APICallManager.sharedInstance.callAPI(router: APIRouter.useraudiotracking(parameters), displayHud: false, showToast: false) { (response : GeneralModel) in
            if response.ResponseCode == "200" {
                self.arrayDownload.removeAll()
                self.arrayActivity.removeAll()
                let value = data.filter {$0.CompletedTime != ""}
                if value.count > 0 {
                    for i in 0..<value.count {
                        if value[i].CompletedTime != "" {
                            self.isAudioCompleted = false
                        }
                    }
                    
                }
            } else {
                self.storeAudioActivityTrack(audioData : audioData)
                self.arrayDownload.removeAll()
                self.arrayActivity.removeAll()
                
            }
        }
    }
    
    
    // MARK:- sending online data
    func checkActivityTrack(audioData:AudioDetailsDataModel) {
        checkTime(time: "\(Date.currentTimeStamp)")
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
                    storeAudioActivityTrack(audioData : audioData)
                    self.arrayDownload.removeAll()
                    self.arrayActivity.removeAll()
                } else {
                    arrayActivity.append(dataActivity)
                    callAudioActivityTracking(trackingData: arrayActivity, audioData: audioData)
                }
            }
        }
    }
    
    
    // MARK:- check start and complted time
    func checkTime(time:String) {
        if isAudioCompleted == false {
            let str = time.dropLast(3)
            self.startTime = String(str)
            self.completedTime = ""
        }else {
            let str = time.dropLast(3)
            self.completedTime = String(str)
            self.startTime = ""
        }
    }
    
    // MARK:- coredata - Save
    func storeAudioActivityTrack(audioData : AudioDetailsDataModel) {
        let managedContext =
            APPDELEGATE.persistentContainer.viewContext
        
        let userAudio = UserActivity(context: managedContext)
        userAudio.userId = CoUserDataModel.currentUserId
        userAudio.playlistId = audioData.PlaylistID
        userAudio.audioId = audioData.ID
        userAudio.startTime = startTime ?? ""
        userAudio.completedTime = completedTime ?? ""
        userAudio.volume = "\(DJMusicPlayer.shared.audioPlayer.volume)"
        
        do {
            try managedContext.save()
            // arrayActivity.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK:- coredata - fetch
    func fetchAudioActivityTrack(audiodata:AudioDetailsDataModel) {
        checkTime(time: "\(Date.currentTimeStamp)")
        let managedContext =
            APPDELEGATE.persistentContainer.viewContext
        
        let fetchRequest = UserActivity.fetchRequest() as NSFetchRequest
        
        do {
            arrayDownload = try managedContext.fetch(fetchRequest)
            
            for audio in arrayDownload {
                let audioData = ActivityTrackDataModel()
                audioData.UserId = audio.userId ?? ""
                audioData.PlaylistId = audio.playlistId ?? ""
                audioData.AudioId = audio.audioId ?? ""
                audioData.StartTime = audio.startTime ?? ""
                audioData.CompletedTime = audio.completedTime ?? ""
                audioData.Volume = audio.volume ?? ""
                arrayActivity.append(audioData)
            }
            
            if checkInternet(showToast: false) == false {
                if arrayActivity.count > 0 {
                    arrayActivity.removeDuplicates()
                    callAudioActivityTracking(trackingData: arrayActivity, audioData: audiodata)
                }
            } else {
                
                if arrayActivity.count > 0 {
                    callAudioActivityTracking(trackingData: arrayActivity, audioData: audiodata)
                    deleteAllRecords()
                    activityTrack()
                }else {
                    if let audioData = DJMusicPlayer.shared.currentlyPlaying {
                        checkTime(time:"\(Date.currentTimeStamp)")
                        checkActivityTrack(audioData:audioData)
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK:- coredata - delete
    func deleteAllRecords() {
        //delete all data
        let context = APPDELEGATE.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserActivity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}

extension Date {
    static var currentTimeStamp:Int{
        return Int(Date().timeIntervalSince1970 * 1000)
    }
}
