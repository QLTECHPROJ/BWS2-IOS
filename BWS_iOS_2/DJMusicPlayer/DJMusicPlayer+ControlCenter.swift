//
//  DJMusicPlayer+ControlCenter.swift
//  BWS
//
//  Created by Dhruvit on 02/12/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation
import MediaPlayer


extension DJMusicPlayer {
    
    // MARK: Display Now Playing Info
    func updateInfoCenter() {
        guard let item = currentlyPlaying else {return}
        
        let title = item.Name
        let currentTime = item.AudioDuration
        let duration = item.AudioDuration
        let trackNumber = playIndex
        let trackCount = nowPlayingList.count
        
        var nowPlayingInfo : [String : AnyObject] = [
            MPMediaItemPropertyPlaybackDuration : duration as AnyObject,
            MPMediaItemPropertyTitle : title as AnyObject,
            MPNowPlayingInfoPropertyElapsedPlaybackTime : currentTime as AnyObject,
            MPNowPlayingInfoPropertyPlaybackQueueCount :trackCount as AnyObject,
            MPNowPlayingInfoPropertyPlaybackQueueIndex : trackNumber as AnyObject,
            MPMediaItemPropertyMediaType : MPMediaType.anyAudio.rawValue as AnyObject
        ]
        
        nowPlayingInfo[MPMediaItemPropertyArtist] = item.Name as AnyObject?
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = item.AudioSubCategory as AnyObject?
        
        if let imgUrl = URL(string: item.ImageFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            UIImageView().sd_setImage(with: imgUrl, placeholderImage: nil, options: .refreshCached) { (audioImage, error, sdImageCacheType, imageUrl) in
                
                if audioImage != nil {
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: audioImage!.size) { size in
                        return audioImage!
                    }
                }
            }
        }
        
        var isAudioPlaying = DJMusicPlayer.shared.isPlaying
        
        if DJMusicPlayer.shared.state == .loading && DJMusicPlayer.shared.isPlaying {
            isAudioPlaying = false
          
        }
        
        if isAudioPlaying {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = DJMusicPlayer.shared.currentTime as AnyObject
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = DJMusicPlayer.shared.duration as AnyObject
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1 as AnyObject
        } else {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = DJMusicPlayer.shared.currentTime as AnyObject
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = DJMusicPlayer.shared.duration as AnyObject
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0 as AnyObject
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func updateNowPlaying() {
        // Define Now Playing Info
        guard var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo else {
            return
        }
        
        var isAudioPlaying = DJMusicPlayer.shared.isPlaying
        
        if DJMusicPlayer.shared.state == .loading && DJMusicPlayer.shared.isPlaying {
            isAudioPlaying = false
        }
        
        if isAudioPlaying {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = DJMusicPlayer.shared.currentTime
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = DJMusicPlayer.shared.duration as AnyObject
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1 as AnyObject
        } else {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = DJMusicPlayer.shared.currentTime
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = DJMusicPlayer.shared.duration as AnyObject
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0 as AnyObject
        }
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    // MARK:- Setup Remote Transport Controls
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        guard let item = currentlyPlaying else {return}
        
        // Add handler for Play Command
        if item.isDisclaimer == true {
            commandCenter.playCommand.removeTarget(self)
            commandCenter.pauseCommand.removeTarget(self)
            commandCenter.changePlaybackPositionCommand.removeTarget(self)
            
            // Add Play Command
            commandCenter.playCommand.addTarget(self, action: #selector(handlePlayCommand(event:)))
            
            // Add Pause Command
            commandCenter.pauseCommand.addTarget(self, action: #selector(handlePauseCommand(event:)))
            
            commandCenter.previousTrackCommand.isEnabled = false
            commandCenter.nextTrackCommand.isEnabled = false
            commandCenter.changePlaybackPositionCommand.isEnabled = false
        } else {
            commandCenter.previousTrackCommand.removeTarget(self)
            commandCenter.nextTrackCommand.removeTarget(self)
            commandCenter.playCommand.removeTarget(self)
            commandCenter.pauseCommand.removeTarget(self)
            commandCenter.changePlaybackPositionCommand.removeTarget(self)
            
            commandCenter.previousTrackCommand.isEnabled = false // !DJMusicPlayer.shared.isPlayingFirst
            commandCenter.nextTrackCommand.isEnabled = false // !DJMusicPlayer.shared.isPlayingLast
            commandCenter.changePlaybackPositionCommand.isEnabled = true
            
            // Add Play Command
            commandCenter.playCommand.addTarget(self, action: #selector(handlePlayCommand(event:)))
            
            // Add Pause Command
            commandCenter.pauseCommand.addTarget(self, action: #selector(handlePauseCommand(event:)))
            
            // Add Next Command
            // commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextCommand(event:)))
            
            // Add Previous Command
            // commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePreviousCommand(event:)))
            
            // Add Change Playback Position Command
            commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(handleChangePlaybackPositionCommand(event:)))
        }
    }
    
    @objc func handlePlayCommand(event : MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        DJMusicPlayer.shared.playerScreen = .notificationPlayer
        
        if DJMusicPlayer.shared.playbackState == .stopped {
            DJMusicPlayer.shared.currentlyPlaying = nil
            DJMusicPlayer.shared.latestPlayRequest = nil
            DJMusicPlayer.shared.resetPlayer()
            DJMusicPlayer.shared.requestToPlay()
        } else {
            DJMusicPlayer.shared.togglePlaying()
        }
        
        return .success
    }

    @objc func handlePauseCommand(event : MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        DJMusicPlayer.shared.playerScreen = .notificationPlayer
        
        DJMusicPlayer.shared.pause(pauseReason: .userAction)
        return .success
    }
    
    @objc func handleNextCommand(event : MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        DJMusicPlayer.shared.playerScreen = .notificationPlayer
        
        DJMusicPlayer.shared.playNext()
        return .success
    }
    
    @objc func handlePreviousCommand(event : MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        DJMusicPlayer.shared.playerScreen = .notificationPlayer

        DJMusicPlayer.shared.playPrevious()
        return .success
    }
    
    @objc func handleChangePlaybackPositionCommand(event : MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        DJMusicPlayer.shared.seek(toSecond: event.positionTime)
        
        return .success
    }
    
}
