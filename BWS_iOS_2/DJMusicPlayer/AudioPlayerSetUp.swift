//
//  AudioPlayerSetUp.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 19/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation

extension BaseViewController {
    
    func clearAudioPlayerForSuggestedPlaylist(newPlaylist : PlaylistDetailsModel) {
        guard let playlist = DJMusicPlayer.shared.currentPlaylist else {
            return
        }
        
        if playlist.Created == "2" || playlist.selfCreated == "2" {
            if playlist.PlaylistID == newPlaylist.PlaylistID {
                let oldPlaylistAudios = playlist.PlaylistSongs.map({ $0.ID })
                let newPlaylistAudios = newPlaylist.PlaylistSongs.map({ $0.ID })
                
                if oldPlaylistAudios.elementsEqual(newPlaylistAudios) == false {
                    self.clearAudioPlayer()
                }
            }
        }
    }
    
    func clearAudioPlayer() {
        // Player Related Data
        DJMusicPlayer.shared.stop()
        DJMusicPlayer.shared.playIndex = 0
        DJMusicPlayer.shared.currentlyPlaying = nil
        DJMusicPlayer.shared.latestPlayRequest = nil
        DJMusicPlayer.shared.nowPlayingList = [AudioDetailsDataModel]()
        DJMusicPlayer.shared.currentPlaylist = nil
        saveNowPlayingSongs()
        
        DJMusicPlayer.shared.playerType = .audio
        DJMusicPlayer.shared.lastPlayerType = .audio
        DJMusicPlayer.shared.playerScreen = .miniPlayer
        DJMusicPlayer.shared.playingFrom = "Audios"
        
        DisclaimerAudio.shared.shouldPlayDisclaimer = false
        
        // Cancel All ongoing Downloads on logout
        SDDownloadManager.shared.cancelAllDownloads()
    }
    
    // MARK:- Present Player for Single Audio
    func presentAudioPlayer(playerData : AudioDetailsDataModel?) {
        if let audioData = playerData {
            if DJMusicPlayer.shared.canPlayFromDownloads(playerData: audioData) == false && checkInternet() == false {
                //                showAlertToast(message: Theme.strings.alert_check_internet)
                return
            }
            
            DJMusicPlayer.shared.playerType = .audio
            presentAudioPlayer(arrayPlayerData: [audioData])
            DJMusicPlayer.shared.playingFrom = "Audios"
        } else {
            presentAudioPlayer(arrayPlayerData: nil)
        }
    }
    
    // MARK:- Present Player for Multiple Audio
    func presentAudioPlayer(arrayPlayerData : [AudioDetailsDataModel]?, index : Int? = nil) {
        let oldAudioID = DJMusicPlayer.shared.currentlyPlaying?.ID ?? ""
        
        if var audioList = arrayPlayerData, audioList.count > 0 {
            let playIndex = index ?? 0
            if DJMusicPlayer.shared.canPlayFromDownloads(playerData: audioList[playIndex]) == false && checkInternet() == false {
                //                showAlertToast(message: Theme.strings.alert_check_internet)
                if isPlayingAudio(audioID: audioList[playIndex].ID) == false {
                    return
                }
            }
            
            var isFirstPlaybackAudio = true
            
            if isPlayingPlaylist(playlistID: audioList[playIndex].PlaylistID) {
                isFirstPlaybackAudio = false
            } else if isPlayingPlaylistFromDownloads(playlistID: audioList[playIndex].PlaylistID) {
                isFirstPlaybackAudio = false
            } else if isPlayingTopCategory(categoryName: audioList[playIndex].CategoryName) {
                isFirstPlaybackAudio = false
            } else if isPlayingAudioFromDownloads() {
                isFirstPlaybackAudio = false
            } else if isPlayingAudioFromLiked() {
                isFirstPlaybackAudio = false
            } else if isPlayingAudioFrom(playerType: PlayerType.recentlyPlayed) {
                isFirstPlaybackAudio = false
            } else if isPlayingAudioFrom(playerType: PlayerType.library) {
                isFirstPlaybackAudio = false
            } else if isPlayingAudioFrom(playerType: PlayerType.getInspired) {
                isFirstPlaybackAudio = false
            } else if isPlayingAudioFrom(playerType: PlayerType.popular) {
                isFirstPlaybackAudio = false
            } else if isPlayingSingleAudio() {
                isFirstPlaybackAudio = false
            }
            
            if DisclaimerAudio.shared.shouldPlayDisclaimer {
                if let disclaimer = DisclaimerAudio.shared.disclaimerAudio, checkInternet() {
                    disclaimer.ID = audioList[playIndex].ID
                    disclaimer.PlaylistID = audioList[playIndex].PlaylistID
                    disclaimer.Download = audioList[playIndex].Download
                    disclaimer.isSingleAudio = audioList[playIndex].isSingleAudio
                    disclaimer.CategoryName = audioList[playIndex].CategoryName
                    DisclaimerAudio.shared.disclaimerAudio = disclaimer
                    audioList.insert(disclaimer, at: playIndex)
                }
            }
            
            if isFirstPlaybackAudio || DJMusicPlayer.shared.isFirstPlaybackAudio {
                DJMusicPlayer.shared.isFirstPlaybackAudio = true
            }
            
            if DJMusicPlayer.shared.isFirstPlaybackAudio || oldAudioID != audioList[playIndex].ID {
                DJMusicPlayer.shared.currentlyPlaying = nil
            }
            
            // DJMusicPlayer.shared.currentlyPlaying = nil
            DJMusicPlayer.shared.playIndex = 0
            DJMusicPlayer.shared.nowPlayingList = audioList
            DJMusicPlayer.shared.isNowPresenting = true
            saveNowPlayingSongs()
        }
        
        if DJMusicPlayer.shared.isNowPresenting == false {
            return
        }
        
        var playData : AudioDetailsDataModel?
        if let nowData = DJMusicPlayer.shared.nowPlayingList.first {
            playData = nowData
        }
        
        guard var data = playData else {
            return
        }
        
        let playIndex = index ?? 0
        if DJMusicPlayer.shared.nowPlayingList.count > playIndex {
            DJMusicPlayer.shared.playIndex = playIndex
            data = DJMusicPlayer.shared.nowPlayingList[DJMusicPlayer.shared.playIndex]
        }
        
        if arrayPlayerData != nil {
            if DJMusicPlayer.shared.canPlayFromDownloads(playerData: data) == false && checkInternet() == false {
                //            showAlertToast(message: Theme.strings.alert_check_internet)
                if isPlayingAudio(audioID: data.ID) == false {
                    return
                }
            }
            
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlayerVC.self)
            aVC.audioDetails = data
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: true, completion: nil)
            
            if DJMusicPlayer.shared.isFirstPlaybackAudio {
                DJMusicPlayer.shared.requestToPlay()
            } else {
                if oldAudioID == data.ID {
                    if DJMusicPlayer.shared.playbackState == .stopped {
                        DJMusicPlayer.shared.currentlyPlaying = nil
                        DJMusicPlayer.shared.latestPlayRequest = nil
                        DJMusicPlayer.shared.resetPlayer()
                        DJMusicPlayer.shared.requestToPlay()
                    } else if DJMusicPlayer.shared.playbackState == .paused {
                        DJMusicPlayer.shared.play(isResume: true)
                    }
                } else {
                    DJMusicPlayer.shared.requestToPlay()
                }
            }
        }
    }
    
}
