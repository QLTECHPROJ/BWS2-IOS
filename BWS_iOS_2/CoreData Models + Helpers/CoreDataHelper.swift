//
//  CoreDataHelper.swift
//  BWS
//
//  Created by Dhruvit on 22/09/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation
import UIKit
import CoreData


// MARK:- Handle Audio Table

class CoreDataHelper {
    
    public static let shared = CoreDataHelper()
    
    let context = APPDELEGATE.persistentContainer.viewContext
    
    var arrayDownloadedAudios = [AudioDownloads]()
    var arrayDownloadedPlayist = [PlaylistDownloads]()
    
    func saveAudio(audioData : AudioDetailsDataModel, isSingleAudio : Bool) {
        
        let _ = fetchAllAudios()
        let objects = arrayDownloadedAudios.filter {
            $0.id == audioData.ID && $0.playlistID == audioData.PlaylistID && $0.isSingleAudio == (isSingleAudio ? "1" : "")
        }
        
        if objects.count > 0 {
            showAlertToast(message: Theme.strings.alert_audio_already_downloaded)
            return
        }
        
        let downloadAudio = AudioDownloads(context: context)
        downloadAudio.coUserID = CoUserDataModel.currentUserId
        downloadAudio.id = audioData.ID
        downloadAudio.name = audioData.Name
        downloadAudio.audioFile = audioData.AudioFile
        downloadAudio.imageFile = audioData.ImageFile
        downloadAudio.audioDuration = audioData.AudioDuration
        downloadAudio.audioDirection = audioData.AudioDirection
        downloadAudio.audioDescription = audioData.AudioDescription
        downloadAudio.audiomastercat = audioData.Audiomastercat
        downloadAudio.audioSubCategory = audioData.AudioSubCategory
        downloadAudio.playlistID = audioData.PlaylistID
        downloadAudio.selfCreated = "" // audioData.selfCreated
        downloadAudio.like = audioData.Like
        downloadAudio.bitrate = audioData.Bitrate
        downloadAudio.download = "1" //audioData.Download
        downloadAudio.downloadLocation = audioData.downloadLocation
        downloadAudio.isSingleAudio = isSingleAudio ? "1" : ""
        downloadAudio.sortId = audioData.sortId
        
        do {
            try context.save()
            
            
            let isDownloaded = DJDownloadManager.shared.checkFileExists(fileName: audioData.AudioFile)
            if isDownloaded && isSingleAudio {
                showAlertToast(message: Theme.strings.alert_audio_downloaded)
            } else if isSingleAudio {
                showAlertToast(message: Theme.strings.alert_audio_download_started)
            }
            
            DJDownloadManager.shared.fetchNextDownload()
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
            
            // Refresh Downloaded Audios in Player
            refreshPlayerDownloadedAudios()
        } catch {
            print("Error :- ",error.localizedDescription)
            showAlertToast(message: Theme.strings.alert_audio_download_error)
        }
    }
    
    func fetchAllAudios() -> [AudioDetailsDataModel] {
        
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@", CoUserDataModel.currentUserId)
        
        do {
            arrayDownloadedAudios = try context.fetch(fetchRequest)
            var arrayAudioData = [AudioDetailsDataModel]()
            for audio in arrayDownloadedAudios {
                let audioData = AudioDetailsDataModel()
                audioData.ID = audio.id ?? ""
                audioData.Name = audio.name ?? ""
                audioData.AudioFile = audio.audioFile ?? ""
                audioData.ImageFile = audio.imageFile ?? ""
                audioData.AudioDuration = audio.audioDuration ?? ""
                audioData.AudioDirection = audio.audioDirection ?? ""
                audioData.AudioDescription = audio.audioDescription ?? ""
                audioData.Audiomastercat = audio.audiomastercat ?? ""
                audioData.AudioSubCategory = audio.audioSubCategory ?? ""
                audioData.PlaylistID = audio.playlistID ?? ""
                audioData.selfCreated = "" // audio.selfCreated ?? ""
                audioData.Like = audio.like ?? ""
                audioData.Bitrate = audio.bitrate ?? ""
                audioData.Download = audio.download ?? ""
                audioData.downloadLocation = audio.downloadLocation ?? ""
                audioData.isSingleAudio = audio.isSingleAudio ?? ""
                audioData.sortId = audio.sortId ?? ""
                arrayAudioData.append(audioData)
            }
            
            return arrayAudioData
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return [AudioDetailsDataModel]()
    }
    
    func fetchSingleAudios() -> [AudioDetailsDataModel] {
        
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && isSingleAudio == %@", CoUserDataModel.currentUserId, "1")
        
        do {
            arrayDownloadedAudios = try context.fetch(fetchRequest)
            var arrayAudioData = [AudioDetailsDataModel]()
            for audio in arrayDownloadedAudios {
                let audioData = AudioDetailsDataModel()
                audioData.ID = audio.id ?? ""
                audioData.Name = audio.name ?? ""
                audioData.AudioFile = audio.audioFile ?? ""
                audioData.ImageFile = audio.imageFile ?? ""
                audioData.AudioDuration = audio.audioDuration ?? ""
                audioData.AudioDirection = audio.audioDirection ?? ""
                audioData.AudioDescription = audio.audioDescription ?? ""
                audioData.Audiomastercat = audio.audiomastercat ?? ""
                audioData.AudioSubCategory = audio.audioSubCategory ?? ""
                audioData.PlaylistID = audio.playlistID ?? ""
                audioData.selfCreated = "" // audio.selfCreated ?? ""
                audioData.Like = audio.like ?? ""
                audioData.Bitrate = audio.bitrate ?? ""
                audioData.Download = audio.download ?? ""
                audioData.downloadLocation = audio.downloadLocation ?? ""
                audioData.isSingleAudio = audio.isSingleAudio ?? ""
                audioData.sortId = audio.sortId ?? ""
                arrayAudioData.append(audioData)
            }
            
            // return arrayAudioData.reversed()
            return arrayAudioData
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return [AudioDetailsDataModel]()
    }
    
    func fetchPlaylistAudios(playlistID : String) -> [AudioDetailsDataModel] {
        
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && playlistID == %@ && isSingleAudio != %@", CoUserDataModel.currentUserId, playlistID, "1")
        
        do {
            let audiosToFetch = try context.fetch(fetchRequest)
            var arrayAudioData = [AudioDetailsDataModel]()
            for audio in audiosToFetch {
                let audioData = AudioDetailsDataModel()
                audioData.ID = audio.id ?? ""
                audioData.Name = audio.name ?? ""
                audioData.AudioFile = audio.audioFile ?? ""
                audioData.ImageFile = audio.imageFile ?? ""
                audioData.AudioDuration = audio.audioDuration ?? ""
                audioData.AudioDirection = audio.audioDirection ?? ""
                audioData.AudioDescription = audio.audioDescription ?? ""
                audioData.Audiomastercat = audio.audiomastercat ?? ""
                audioData.AudioSubCategory = audio.audioSubCategory ?? ""
                audioData.PlaylistID = audio.playlistID ?? ""
                audioData.selfCreated = "" // audio.selfCreated ?? ""
                audioData.Like = audio.like ?? ""
                audioData.Bitrate = audio.bitrate ?? ""
                audioData.Download = audio.download ?? ""
                audioData.downloadLocation = audio.downloadLocation ?? ""
                audioData.isSingleAudio = audio.isSingleAudio ?? ""
                audioData.sortId = audio.sortId ?? ""
                arrayAudioData.append(audioData)
            }
            
            return arrayAudioData
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return [AudioDetailsDataModel]()
    }
    
    func fetchPlaylistDownloadedAudios(playlistID : String) -> [AudioDetailsDataModel] {
        
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && playlistID == %@ && isSingleAudio != %@", CoUserDataModel.currentUserId, playlistID, "1")
        
        do {
            let audiosToFetch = try context.fetch(fetchRequest)
            var arrayAudioData = [AudioDetailsDataModel]()
            for audio in audiosToFetch {
                let audioData = AudioDetailsDataModel()
                audioData.ID = audio.id ?? ""
                audioData.Name = audio.name ?? ""
                audioData.AudioFile = audio.audioFile ?? ""
                audioData.ImageFile = audio.imageFile ?? ""
                audioData.AudioDuration = audio.audioDuration ?? ""
                audioData.AudioDirection = audio.audioDirection ?? ""
                audioData.AudioDescription = audio.audioDescription ?? ""
                audioData.Audiomastercat = audio.audiomastercat ?? ""
                audioData.AudioSubCategory = audio.audioSubCategory ?? ""
                audioData.PlaylistID = audio.playlistID ?? ""
                audioData.selfCreated = "" // audio.selfCreated ?? ""
                audioData.Like = audio.like ?? ""
                audioData.Bitrate = audio.bitrate ?? ""
                audioData.Download = audio.download ?? ""
                audioData.downloadLocation = audio.downloadLocation ?? ""
                audioData.isSingleAudio = audio.isSingleAudio ?? ""
                audioData.sortId = audio.sortId ?? ""
                
                if DJDownloadManager.shared.checkFileExists(fileName: audio.audioFile ?? "") {
                    arrayAudioData.append(audioData)
                }
            }
            
            return arrayAudioData
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return [AudioDetailsDataModel]()
    }
    
    func checkAudioInDatabase(audioData : AudioDetailsDataModel) -> Bool {
        
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && audioFile == %@ && isSingleAudio == %@", CoUserDataModel.currentUserId, audioData.AudioFile, "1")
        
        do {
            let items = try context.fetch(fetchRequest)
            return items.count > 0
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return false
    }
    
    func checkAudioFileInDatabase(filePath : String) -> Bool {
        
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && audioFile == %@", CoUserDataModel.currentUserId, filePath)
        
        do {
            let items = try context.fetch(fetchRequest)
            return items.count > 0
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return false
    }
    
    func updateDownloadAudio(audioData : AudioDetailsDataModel) {
        let _ = fetchAllAudios()
        let objects = arrayDownloadedAudios.filter {
            $0.id == audioData.ID
        }
        
        for downloadAudio in objects {
            downloadAudio.id = audioData.ID
            downloadAudio.name = audioData.Name
            downloadAudio.audioFile = audioData.AudioFile
            downloadAudio.imageFile = audioData.ImageFile
            downloadAudio.audioDuration = audioData.AudioDuration
            downloadAudio.audioDirection = audioData.AudioDirection
            downloadAudio.audioDescription = audioData.AudioDescription
            downloadAudio.audiomastercat = audioData.Audiomastercat
            downloadAudio.audioSubCategory = audioData.AudioSubCategory
            downloadAudio.playlistID = audioData.PlaylistID
            downloadAudio.selfCreated = "" // audioData.selfCreated
            downloadAudio.like = audioData.Like
            downloadAudio.bitrate = audioData.Bitrate
            downloadAudio.download = audioData.Download
            downloadAudio.downloadLocation = audioData.downloadLocation
            downloadAudio.isSingleAudio = audioData.isSingleAudio
            downloadAudio.sortId = audioData.sortId
        }
        
        do {
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
        } catch {
            print("Error :- ",error.localizedDescription)
        }
    }
    
    func deleteDownloadedAudio(audioData : AudioDetailsDataModel) {
        let _ = fetchAllAudios()
        let objects = arrayDownloadedAudios.filter {
            $0.id == audioData.ID && $0.playlistID == audioData.PlaylistID && $0.isSingleAudio == audioData.isSingleAudio
        }
        
        for data in objects {
            context.delete(data)
            DJDownloadManager.shared.deleteFileExists(fileName: audioData.AudioFile)
        }
        
        do {
            try context.save()
            showAlertToast(message: Theme.strings.alert_removed_from_downloads)
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
        } catch {
            print("Error :- ",error.localizedDescription)
            showAlertToast(message: Theme.strings.alert_audio_delete_error)
        }
        
        DJDownloadManager.shared.fetchNextDownload()
    }
    
    func deleteAllAudio() {
        let deleteFetch = NSBatchDeleteRequest(fetchRequest: AudioDownloads.fetchRequest())
        
        do {
            try context.execute(deleteFetch)
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
        }
        catch {
            print("Error :- ",error.localizedDescription)
            showAlertToast(message: Theme.strings.alert_audios_delete_error)
        }
    }
    
}


// MARK:- Handle Playlist Table
extension CoreDataHelper {
    
    func savePlayist(playlistData : PlaylistDetailsModel) {
        
        if self.checkPlaylistDownloaded(playlistData: playlistData) {
            showAlertToast(message: Theme.strings.alert_playlist_already_downloaded)
            return
        }
        
        let downloadPlaylist = PlaylistDownloads(context: context)
        downloadPlaylist.coUserID = CoUserDataModel.currentUserId
        downloadPlaylist.playlistID = playlistData.PlaylistID
        downloadPlaylist.playlistName = playlistData.PlaylistName
        downloadPlaylist.playlistDesc = playlistData.PlaylistDesc
        downloadPlaylist.playlistMastercat = playlistData.PlaylistMastercat
        downloadPlaylist.playlistSubcat = playlistData.PlaylistSubcat
        downloadPlaylist.playlistImage = playlistData.PlaylistImage
        downloadPlaylist.playlistImageDetail = playlistData.PlaylistImageDetail
        downloadPlaylist.created = "" // playlistData.Created
        downloadPlaylist.selfCreated = playlistData.Created
        downloadPlaylist.totalAudio = playlistData.TotalAudio
        downloadPlaylist.totalDuration = playlistData.TotalDuration
        downloadPlaylist.totalhour = playlistData.Totalhour
        downloadPlaylist.totalminute = playlistData.Totalminute
        downloadPlaylist.download = playlistData.Download
        
        for audio in playlistData.PlaylistSongs {
            audio.isSingleAudio = ""
            self.saveAudio(audioData: audio, isSingleAudio: false)
        }
        
        do {
            try context.save()
            let playlistDownloadProgress = CoreDataHelper.shared.updatePlaylistDownloadProgress(playlistID: playlistData.PlaylistID)
            if  playlistDownloadProgress < 1 {
                showAlertToast(message: Theme.strings.alert_playlist_download_started)
            } else {
                showAlertToast(message: Theme.strings.alert_playlist_downloaded)
            }
            DJDownloadManager.shared.fetchNextDownload()
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
        } catch {
            print("Error :- ",error.localizedDescription)
            showAlertToast(message: Theme.strings.alert_playlist_download_error)
        }
    }
    
    func fetchAllPlaylists() -> [PlaylistDetailsModel] {
        
        let fetchRequest = PlaylistDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@", CoUserDataModel.currentUserId)
        
        do {
            arrayDownloadedPlayist = try context.fetch(fetchRequest)
            var arrayPlaylistData = [PlaylistDetailsModel]()
            for playlist in arrayDownloadedPlayist {
                let data = PlaylistDetailsModel()
                data.PlaylistID = playlist.playlistID ?? ""
                data.PlaylistName = playlist.playlistName ?? ""
                data.PlaylistDesc = playlist.playlistDesc ?? ""
                data.PlaylistMastercat = playlist.playlistMastercat ?? ""
                data.PlaylistSubcat = playlist.playlistSubcat ?? ""
                data.PlaylistImage = playlist.playlistImage ?? ""
                data.PlaylistImageDetail = playlist.playlistImageDetail ?? ""
                data.Created = "" // playlist.created ?? ""
                data.selfCreated = playlist.selfCreated ?? ""
                data.TotalAudio = playlist.totalAudio ?? ""
                data.TotalDuration = playlist.totalDuration ?? ""
                data.Totalhour = playlist.totalhour ?? ""
                data.Totalminute = playlist.totalminute ?? ""
                data.Download = playlist.download ?? ""
                
                arrayPlaylistData.append(data)
            }
            
            return arrayPlaylistData
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return [PlaylistDetailsModel]()
    }
    
    func fetchPlaylistDetails(playlistID : String) -> PlaylistDetailsModel? {
        
        let fetchRequest = PlaylistDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && playlistID == %@", CoUserDataModel.currentUserId, playlistID)
        
        do {
            guard let playlist = try context.fetch(fetchRequest).first else {
                return nil
            }
            
            let data = PlaylistDetailsModel()
            data.PlaylistID = playlist.playlistID ?? ""
            data.PlaylistName = playlist.playlistName ?? ""
            data.PlaylistDesc = playlist.playlistDesc ?? ""
            data.PlaylistMastercat = playlist.playlistMastercat ?? ""
            data.PlaylistSubcat = playlist.playlistSubcat ?? ""
            data.PlaylistImage = playlist.playlistImage ?? ""
            data.PlaylistImageDetail = playlist.playlistImageDetail ?? ""
            data.Created = "" // playlist.created ?? ""
            data.selfCreated = playlist.selfCreated ?? ""
            data.TotalAudio = playlist.totalAudio ?? ""
            data.TotalDuration = playlist.totalDuration ?? ""
            data.Totalhour = playlist.totalhour ?? ""
            data.Totalminute = playlist.totalminute ?? ""
            data.Download = playlist.download ?? ""
            
            return data
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return nil
    }
    
    func checkPlaylistDownloaded(playlistData : PlaylistDetailsModel) -> Bool {
        
        let fetchRequest = PlaylistDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && playlistID == %@", CoUserDataModel.currentUserId, playlistData.PlaylistID)
        
        do {
            let items = try context.fetch(fetchRequest)
            if items.count > 0 {
                return true
            }
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return false
    }
    
    func deleteDownloadedPlaylist(playlistData : PlaylistDetailsModel) {
        
        let fetchRequest = PlaylistDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && playlistID == %@", CoUserDataModel.currentUserId, playlistData.PlaylistID)
        
        do {
            let items = try context.fetch(fetchRequest)
            
            for data in items {
                deletePlaylistAudios(playlistID: playlistData.PlaylistID)
                context.delete(data)
            }
            
            try context.save()
            showAlertToast(message: Theme.strings.alert_playlist_removed)
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
            DJDownloadManager.shared.fetchNextDownload()
        } catch {
            print("Error :- ",error.localizedDescription)
            showAlertToast(message: Theme.strings.alert_playlist_delete_error)
        }
    }
    
    func deletePlaylistAudios(playlistID : String) {
        
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && playlistID == %@ && isSingleAudio != %@", CoUserDataModel.currentUserId, playlistID, "1")
        
        do {
            let items = try context.fetch(fetchRequest)
            
            for data in items {
                context.delete(data)
                DJDownloadManager.shared.deleteFileExists(fileName: data.audioFile ?? "")
            }
            
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
        } catch {
            print("Error :- ",error.localizedDescription)
        }
    }
    
    func deleteAllPlaylist() {
        let deleteFetch = NSBatchDeleteRequest(fetchRequest: PlaylistDownloads.fetchRequest())
        
        do {
            try context.execute(deleteFetch)
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
        } catch {
            print("Error :- ",error.localizedDescription)
            showAlertToast(message: Theme.strings.alert_playlists_delete_error)
        }
    }
    
    func updatePlaylistDownloadProgress(playlistID : String) -> Double {
        
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "coUserID == %@ && playlistID == %@ && isSingleAudio != %@", CoUserDataModel.currentUserId, playlistID, "1")
        
        do {
            let audiosToFetch = try context.fetch(fetchRequest)
            var downloadCount = 0
            if audiosToFetch.count > 0 {
                for audio in audiosToFetch {
                    if DJDownloadManager.shared.checkFileExists(fileName: audio.audioFile ?? "") {
                        downloadCount = downloadCount + 1
                    }
                }
                
                let progress : Double = Double(downloadCount) / Double(audiosToFetch.count)
                return progress
            } else {
                return 0
            }
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return 0
    }
    
}


extension CoreDataHelper {
    
    func fetchAudios(filePath : String) -> [AudioDownloads] {
        let fetchRequest = AudioDownloads.fetchRequest() as NSFetchRequest
        fetchRequest.predicate = NSPredicate(format: "audioFile == %@", filePath)
        
        do {
            let items = try context.fetch(fetchRequest)
            return items
        } catch {
            print("Error :- ",error.localizedDescription)
        }
        
        return [AudioDownloads]()
    }
    
}
