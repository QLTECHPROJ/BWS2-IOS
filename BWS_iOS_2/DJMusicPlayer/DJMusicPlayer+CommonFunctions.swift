//
//  DJMusicPlayer+CommonFunctions.swift
//  BWS
//
//  Created by Dhruvit on 04/11/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import os.log
import EVReflection


// MARK:- Queued Songs Data Model
class QueuedSongsData: EVObject {
    var arraySongs = [AudioDetailsDataModel]()
}


// MARK:- Fetch & Save Now Playing Songs
func fetchNowPlayingSongs() {
    if let userData = UserDefaults.standard.data(forKey: "NowPlayingSongs") {
        DJMusicPlayer.shared.nowPlayingList = QueuedSongsData(data: userData).arraySongs
    } else {
        DJMusicPlayer.shared.nowPlayingList = [AudioDetailsDataModel]()
    }
}

func saveNowPlayingSongs() {
    let lastSongs = DJMusicPlayer.shared.nowPlayingList
    let queueData = QueuedSongsData()
    queueData.arraySongs = lastSongs
    UserDefaults.standard.setValue(queueData.toJsonData(), forKey: "NowPlayingSongs")
    UserDefaults.standard.synchronize()
    fetchNowPlayingSongs()
}

func isPlayingSingleAudio() -> Bool {
    var isSingle = true
    
    let currentPlayerType = DJMusicPlayer.shared.playerType
    if currentPlayerType == .playlist || currentPlayerType == .downloadedPlaylist || currentPlayerType == .downloadedAudios {
        isSingle = false
    }
    
    return isSingle
}


func isPlayingAudio(audioID : String) -> Bool {
    if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
        return false
    }
    
    if DJMusicPlayer.shared.nowPlayingList.count > DJMusicPlayer.shared.playIndex {
        if let currentAudioID = DJMusicPlayer.shared.currentlyPlaying?.ID, currentAudioID.trim.count > 0 {
            if currentAudioID == audioID {
                return true
            }
        }
        else if DJMusicPlayer.shared.nowPlayingList[DJMusicPlayer.shared.playIndex].ID.trim.count > 0 {
            if DJMusicPlayer.shared.nowPlayingList[DJMusicPlayer.shared.playIndex].ID == audioID {
                return true
            }
        }
    }
    
    return false
}

// MARK:- Liked Audios Handler
func isPlayingAudioFromLiked() -> Bool {
    return DJMusicPlayer.shared.playerType == .likedAudios
}

func isPlayingAudioFromLiked(audioID : String) -> Bool {
    if DJMusicPlayer.shared.playerType != .likedAudios {
        return false
    }
    
    if DJMusicPlayer.shared.nowPlayingList.count > 0 {
        if let currentAudioID = DJMusicPlayer.shared.currentlyPlaying?.ID, currentAudioID.trim.count > 0 {
            if currentAudioID == audioID
                && DJMusicPlayer.shared.currentlyPlaying?.Download == ""
                && DJMusicPlayer.shared.currentlyPlaying?.isSingleAudio != "1" {
                return true
            }
        }
        else if DJMusicPlayer.shared.nowPlayingList[0].ID.trim.count > 0 {
            if DJMusicPlayer.shared.nowPlayingList[0].ID == audioID
                && DJMusicPlayer.shared.nowPlayingList[0].Download == ""
                && DJMusicPlayer.shared.nowPlayingList[0].isSingleAudio != "1" {
                return true
            }
        }
    }
    
    return false
}


// MARK:- Downloaded Audios Handler
func isPlayingAudioFrom(playerType : PlayerType) -> Bool {
    return DJMusicPlayer.shared.playerType == playerType
}


// MARK:- Downloaded Audios Handler
func isPlayingAudioFromDownloads() -> Bool {
    return DJMusicPlayer.shared.playerType == .downloadedAudios
}

func isPlayingAudioFromDownloads(audioID : String) -> Bool {
    if DJMusicPlayer.shared.playerType != .downloadedAudios {
        return false
    }
    
    if DJMusicPlayer.shared.nowPlayingList.count > 0 {
        if let currentAudioID = DJMusicPlayer.shared.currentlyPlaying?.ID, currentAudioID.trim.count > 0 {
            if currentAudioID == audioID
                && DJMusicPlayer.shared.currentlyPlaying?.Download == "1"
                && DJMusicPlayer.shared.currentlyPlaying?.isSingleAudio == "1" {
                return true
            }
        }
        else if DJMusicPlayer.shared.nowPlayingList[0].ID.trim.count > 0 {
            if DJMusicPlayer.shared.nowPlayingList[0].ID == audioID
                && DJMusicPlayer.shared.nowPlayingList[0].Download == "1"
                && DJMusicPlayer.shared.nowPlayingList[0].isSingleAudio == "1" {
                return true
            }
        }
    }
    
    return false
}

func refreshPlayerDownloadedAudios() {
    if DJMusicPlayer.shared.playerType != .downloadedAudios {
        return
    }
    
    // Refresh Player Songs
    let currentIndex = DJMusicPlayer.shared.playIndex
    var newIndex : Int?
    
    let arraySongs = CoreDataHelper.shared.fetchSingleAudios()
    
    DJMusicPlayer.shared.nowPlayingList = arraySongs
    saveNowPlayingSongs()
    
    for (index,audio) in DJMusicPlayer.shared.nowPlayingList.enumerated() {
        if audio.ID == DJMusicPlayer.shared.currentlyPlaying?.ID {
            if newIndex == nil {
                newIndex = index
            }
        }
    }
    
    if newIndex != nil {
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
            let disclaimer = DisclaimerAudio.shared.fetchDisclaimerAudio(data: DJMusicPlayer.shared.currentlyPlaying!)
            DJMusicPlayer.shared.nowPlayingList.insert(disclaimer, at: newIndex!)
            saveNowPlayingSongs()
        }
        DJMusicPlayer.shared.playIndex = newIndex!
    } else {
        if DJMusicPlayer.shared.nowPlayingList.count > currentIndex {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                let disclaimer = DisclaimerAudio.shared.fetchDisclaimerAudio(data: DJMusicPlayer.shared.currentlyPlaying!)
                DJMusicPlayer.shared.nowPlayingList.insert(disclaimer, at: currentIndex)
                saveNowPlayingSongs()
            }
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == false {
                if DJMusicPlayer.shared.isPlaying == false {
                    DJMusicPlayer.shared.isAutoPlay = false
                }
                
                DJMusicPlayer.shared.requestToPlay()
            }
        } else {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                let disclaimer = DisclaimerAudio.shared.fetchDisclaimerAudio(data: DJMusicPlayer.shared.currentlyPlaying!)
                DJMusicPlayer.shared.nowPlayingList.insert(disclaimer, at: 0)
                saveNowPlayingSongs()
            }
            DJMusicPlayer.shared.playIndex = 0
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == false {
                if DJMusicPlayer.shared.isPlaying == false {
                    DJMusicPlayer.shared.isAutoPlay = false
                }
                
                DJMusicPlayer.shared.requestToPlay()
            }
        }
    }
    
}

// MARK:- Downloaded Playlist Handler
func isPlayingPlaylistFromDownloads(playlistID : String) -> Bool {
    if DJMusicPlayer.shared.playerType != .downloadedPlaylist {
        return false
    }
    
    if DJMusicPlayer.shared.nowPlayingList.count > 0 {
        if let currentPlaylistID = DJMusicPlayer.shared.currentlyPlaying?.PlaylistID, currentPlaylistID.trim.count > 0 {
            if currentPlaylistID == playlistID
                && DJMusicPlayer.shared.currentlyPlaying?.Download == "1"
                && DJMusicPlayer.shared.currentlyPlaying?.isSingleAudio != "1" {
                return true
            }
        }
        else if DJMusicPlayer.shared.nowPlayingList[0].PlaylistID.trim.count > 0 {
            if DJMusicPlayer.shared.nowPlayingList[0].PlaylistID == playlistID
                && DJMusicPlayer.shared.nowPlayingList[0].Download == "1"
                && DJMusicPlayer.shared.nowPlayingList[0].isSingleAudio != "1" {
                return true
            }
        }
    }
    
    return false
}


// MARK:- Top Category Audios Handler
func isPlayingTopCategory(categoryName : String) -> Bool {
    if DJMusicPlayer.shared.playerType != .topCategories {
        return false
    }
    
    if DJMusicPlayer.shared.nowPlayingList.count > 0 {
        if let currentCategoryName = DJMusicPlayer.shared.currentlyPlaying?.CategoryName, currentCategoryName.trim.count > 0 {
            if currentCategoryName == categoryName
                && DJMusicPlayer.shared.currentlyPlaying?.Download == ""
                && DJMusicPlayer.shared.currentlyPlaying?.isSingleAudio != "1" {
                return true
            }
        }
        else if DJMusicPlayer.shared.nowPlayingList[0].CategoryName.trim.count > 0 {
            if DJMusicPlayer.shared.nowPlayingList[0].CategoryName == categoryName
                && DJMusicPlayer.shared.nowPlayingList[0].Download == ""
                && DJMusicPlayer.shared.nowPlayingList[0].isSingleAudio != "1" {
                return true
            }
        }
    }
    
    return false
}


// MARK:- Online Playlist Handler
func isPlayingPlaylist(playlistID : String) -> Bool {
    if DJMusicPlayer.shared.playerType != .playlist {
        return false
    }
    
    if DJMusicPlayer.shared.nowPlayingList.count > 0 {
        if let currentPlaylistID = DJMusicPlayer.shared.currentlyPlaying?.PlaylistID, currentPlaylistID.trim.count > 0 {
            if currentPlaylistID == playlistID
                && DJMusicPlayer.shared.currentlyPlaying?.Download == ""
                && DJMusicPlayer.shared.currentlyPlaying?.isSingleAudio != "1" {
                return true
            }
        }
        else if DJMusicPlayer.shared.nowPlayingList[0].PlaylistID.trim.count > 0 {
            if DJMusicPlayer.shared.nowPlayingList[0].PlaylistID == playlistID
                && DJMusicPlayer.shared.nowPlayingList[0].Download == ""
                && DJMusicPlayer.shared.nowPlayingList[0].isSingleAudio != "1" {
                return true
            }
        }
    }
    
    return false
}

func refreshNowPlayingSongs(playlistID : String, arraySongs : [AudioDetailsDataModel]) {
    if DJMusicPlayer.shared.playerType != .playlist {
        return
    }
    
    var shouldRefreshPlaylist = false
    
    if DJMusicPlayer.shared.nowPlayingList.count > 0 && arraySongs.count > 0 {
        if let currentPlaylistID = DJMusicPlayer.shared.currentlyPlaying?.PlaylistID, currentPlaylistID.trim.count > 0 {
            if currentPlaylistID == arraySongs[0].PlaylistID {
                if arraySongs.count > 0 {
                    shouldRefreshPlaylist = true
                }
            }
        }
    }
    
    if shouldRefreshPlaylist == false {
        return
    }
    
    // Refresh Playlist Songs
    let currentIndex = DJMusicPlayer.shared.playIndex
    var newIndex : Int?
    
    DJMusicPlayer.shared.nowPlayingList = arraySongs
    for audio in DJMusicPlayer.shared.nowPlayingList {
        audio.selfCreated = "1"
    }
    saveNowPlayingSongs()
    
    for (index,audio) in DJMusicPlayer.shared.nowPlayingList.enumerated() {
        if audio.ID == DJMusicPlayer.shared.currentlyPlaying?.ID {
            if newIndex == nil {
                newIndex = index
            }
        }
    }
    
    if newIndex != nil {
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
            let disclaimer = DisclaimerAudio.shared.fetchDisclaimerAudio(data: DJMusicPlayer.shared.currentlyPlaying!)
            DJMusicPlayer.shared.nowPlayingList.insert(disclaimer, at: newIndex!)
            saveNowPlayingSongs()
        }
        DJMusicPlayer.shared.playIndex = newIndex!
    } else {
        if DJMusicPlayer.shared.nowPlayingList.count > currentIndex {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                let disclaimer = DisclaimerAudio.shared.fetchDisclaimerAudio(data: DJMusicPlayer.shared.currentlyPlaying!)
                DJMusicPlayer.shared.nowPlayingList.insert(disclaimer, at: currentIndex)
                saveNowPlayingSongs()
            }
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == false {
                if DJMusicPlayer.shared.isPlaying == false {
                    DJMusicPlayer.shared.isAutoPlay = false
                }
                
                DJMusicPlayer.shared.requestToPlay()
            }
        } else {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                let disclaimer = DisclaimerAudio.shared.fetchDisclaimerAudio(data: DJMusicPlayer.shared.currentlyPlaying!)
                DJMusicPlayer.shared.nowPlayingList.insert(disclaimer, at: 0)
                saveNowPlayingSongs()
            }
            DJMusicPlayer.shared.playIndex = 0
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == false {
                if DJMusicPlayer.shared.isPlaying == false {
                    DJMusicPlayer.shared.isAutoPlay = false
                }
                
                DJMusicPlayer.shared.requestToPlay()
            }
        }
    }
    
    //    if DJMusicPlayer.shared.isPlaying {
    //        DJMusicPlayer.shared.requestToPlay()
    //    }
    
}
