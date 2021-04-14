//
//  DJMusicPlayer+Functionalities.swift
//  BWS
//
//  Created by Dhruvit on 19/11/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation

extension DJMusicPlayer {
    
    // MARK:- Get Random Index for Shuffle
    func getRandomIndex() -> Int {
        if nowPlayingList.count > 1 && !isPlayingFromQueue {
            let randomm = Int.random(in: 0..<nowPlayingList.count)
            if playIndex == randomm {
                return getRandomIndex()
            }
            else {
                return randomm
            }
        }
        else if queuedSongs.count > 1 {
            let randomm = Int.random(in: 0..<queuedSongs.count)
            if playIndex == randomm {
                return getRandomIndex()
            }
            else {
                return randomm
            }
        }
        return 0
    }
    
    // MARK:- Handle Next Audio
    func playNext(isForce : Bool = true) {
        if let item = lastPlayerItem {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        }
        //        self.currentlyPlaying = nil
        self.latestPlayRequest = nil
        
        if repeatPlaylist == .all {
            self.currentlyPlaying = nil
            if nowPlayingList.count > 0 && !isPlayingFromQueue {
                playNextFromNowPlaying(isForce: isForce)
            }
            else {
                playNextFromQueue(isForce: isForce)
            }
        }
        else {
            if nowPlayingList.count > 0 && !isPlayingFromQueue {
                playNextFromNowPlaying(isForce: isForce)
            }
            else if queuedSongs.count > 0 {
                playNextFromQueue(isForce: isForce)
            }
        }
    }
    
    func playNextFromNowPlaying(isForce : Bool) {
        if repeatPlaylist == .all {
            if playIndex < nowPlayingList.count - 1 {
                let newIndex = shufflePlaylist ? getRandomIndex() : playIndex + 1
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
            else {
                if shufflePlaylist {
                    let newIndex = shufflePlaylist ? getRandomIndex() : 0
                    if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = newIndex
                    self.requestToPlay()
                }
                else {
                    // Repeat All - Play Queue First Audio from Playlist Last Audio
                    if DJMusicPlayer.shared.queuedSongs.count > 0 {
                        isPlayingFromQueue = true
                        lastPlayerType = playerType
                        playerType = .queue
                    }
                    let newIndex = 0
                    if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = newIndex
                    self.requestToPlay()
                }
            }
        }
        else {
            if playIndex < nowPlayingList.count - 1 {
                let newIndex = shufflePlaylist ? getRandomIndex() : playIndex + 1
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
            else {
                // if isForce || shufflePlaylist {
                if isForce {
                    if shufflePlaylist {
                        let newIndex = shufflePlaylist ? getRandomIndex() : 0
                        if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                            // return
                        }
                        playIndex = newIndex
                        self.requestToPlay()
                    }
                    else {
                        // Repeat Off - Play Queue First Audio from Playlist Last Audio
                        if DJMusicPlayer.shared.queuedSongs.count > 0 {
                            isPlayingFromQueue = true
                            lastPlayerType = playerType
                            playerType = .queue
                        }
                        let newIndex = 0
                        if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                            // return
                        }
                        playIndex = newIndex
                        self.requestToPlay()
                    }
                }
                else {
                    if shufflePlaylist {
                        let newIndex = shufflePlaylist ? getRandomIndex() : 0
                        if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                            // return
                        }
                        playIndex = newIndex
                        self.requestToPlay()
                    }
                    else {
                        stop(shouldTrack: true)
                        isAutoPlay = false
                        
                        // Repeat Off - Stop player on Queue First Audio from Playlist Last Audio
                        if DJMusicPlayer.shared.queuedSongs.count > 0 {
                            isPlayingFromQueue = true
                            lastPlayerType = playerType
                            playerType = .queue
                        }
                        let newIndex = 0
                        if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                            // return
                        }
                        playIndex = newIndex
                        self.requestToPlay()
                    }
                }
            }
        }
    }
    
    func playNextFromQueue(isForce : Bool) {
        if repeatPlaylist == .all {
            if playIndex < queuedSongs.count - 1 {
                let newIndex = shufflePlaylist ? getRandomIndex() : playIndex + 1
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
            else {
                if shufflePlaylist {
                    let newIndex = shufflePlaylist ? getRandomIndex() : 0
                    if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = newIndex
                    self.requestToPlay()
                }
                else {
                    // Repeat All - Play Playlist First Audio from Queue Last Audio
                    if DJMusicPlayer.shared.nowPlayingList.count > 0 {
                        isPlayingFromQueue = false
                        if playerType == .queue {
                            playerType = lastPlayerType
                        }
                    }
                    let newIndex = 0
                    if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = newIndex
                    self.requestToPlay()
                }
            }
        }
        else {
            if playIndex < queuedSongs.count - 1 {
                let newIndex = shufflePlaylist ? getRandomIndex() : playIndex + 1
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
            else {
                // if isForce || shufflePlaylist {
                if shufflePlaylist {
                    let newIndex = shufflePlaylist ? getRandomIndex() : 0
                    if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = newIndex
                    self.requestToPlay()
                }
                else {
                    if DJMusicPlayer.shared.nowPlayingList.count > 0 {
                        // Repeat Off - Play Playlist First Audio from Queue Last Audio
                        isPlayingFromQueue = false
                        if playerType == .queue {
                            playerType = lastPlayerType
                        }
                    }
                    else {
                        if isForce == false {
                            stop(shouldTrack: true)
                            isAutoPlay = false
                        }
                        
                        // Repeat Off - Stop player on Queue First Audio from Queue Last Audio if there is no playlist audio
                        if DJMusicPlayer.shared.queuedSongs.count > 0 {
                            isPlayingFromQueue = true
                            lastPlayerType = playerType
                            playerType = .queue
                        }
                    }
                    
                    let newIndex = 0
                    if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = newIndex
                    self.requestToPlay()
                }
            }
        }
    }
    
    // MARK:- Handle Previous Audio
    func playPrevious() {
        if repeatPlaylist == .all {
            self.currentlyPlaying = nil
            if nowPlayingList.count > 0 && !isPlayingFromQueue {
                playPreviousFromNowPlaying()
            }
            else {
                playPreviousFromQueue()
            }
        }
        else {
            if nowPlayingList.count > 0 && !isPlayingFromQueue {
                playPreviousFromNowPlaying()
            }
            else {
                playPreviousFromQueue()
            }
        }
    }
    
    func playPreviousFromNowPlaying() {
        if playIndex > 0 {
            let newIndex = shufflePlaylist ? getRandomIndex() : playIndex - 1
            if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                // return
            }
            playIndex = newIndex
            self.requestToPlay()
        }
        else {
            if queuedSongs.count > 0 && shufflePlaylist == false {
                // Play Queue Last Audio from Playlist First Audio
                isPlayingFromQueue = true
                lastPlayerType = playerType
                playerType = .queue
                
                let newIndex = queuedSongs.count - 1
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
            else {
                let newIndex = shufflePlaylist ? getRandomIndex() : nowPlayingList.count - 1
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
        }
    }
    
    func playPreviousFromQueue() {
        if playIndex > 0 {
            let newIndex = shufflePlaylist ? getRandomIndex() : playIndex - 1
            if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                // return
            }
            playIndex = newIndex
            self.requestToPlay()
        }
        else {
            if nowPlayingList.count > 0 && shufflePlaylist == false {
                // Play Playlist Last Audio from Queue First Audio
                isPlayingFromQueue = false
                if playerType == .queue {
                    playerType = lastPlayerType
                }
                
                let newIndex = nowPlayingList.count - 1
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
            else {
                let newIndex = shufflePlaylist ? getRandomIndex() : queuedSongs.count - 1
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
        }
    }
    
}
