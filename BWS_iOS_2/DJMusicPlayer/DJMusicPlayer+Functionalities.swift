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
        if nowPlayingList.count > 1 {
            let randomm = Int.random(in: 0..<nowPlayingList.count)
            if playIndex == randomm {
                return getRandomIndex()
            } else {
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
        
        if nowPlayingList.count > 0 {
            playNextFromNowPlaying(isForce: isForce)
        }
    }
    
    func playNextFromNowPlaying(isForce : Bool) {
        if playIndex < nowPlayingList.count - 1 {
            let newIndex = playIndex + 1
            if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                // return
            }
            playIndex = newIndex
            self.requestToPlay()
        } else {
            if isForce {
                let newIndex = 0
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            } else {
                stop(shouldTrack: true)
                isAutoPlay = false
                
                let newIndex = 0
                if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                    // return
                }
                playIndex = newIndex
                self.requestToPlay()
            }
        }
    }
    
    // MARK:- Handle Previous Audio
    func playPrevious() {
        // self.currentlyPlaying = nil
        // self.latestPlayRequest = nil
        
        if nowPlayingList.count > 0 {
            playPreviousFromNowPlaying()
        }
    }
    
    func playPreviousFromNowPlaying() {
        if playIndex > 0 {
            let newIndex = playIndex - 1
            if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                // return
            }
            playIndex = newIndex
            self.requestToPlay()
        } else {
            let newIndex = nowPlayingList.count - 1
            if self.canPlayFromDownloads(index: newIndex) == false && checkInternet() == false {
                // return
            }
            playIndex = newIndex
            self.requestToPlay()
        }
    }
    
}
