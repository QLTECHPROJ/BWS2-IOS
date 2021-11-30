//
//  DJMusicPlayer+Common.swift
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


// MARK:- PlayerScreen
enum PlayerScreen: String {
    case miniPlayer = "Mini Player"
    case mainPlayer = "Main Player"
    case notificationPlayer = "Notification Player"
}


// MARK:- PlayerType

/**
 1. audio = 0
 2. playlist
 3. downloadedPlaylist
 4. topCategories
 5. downloadedAudios
 6. likedAudios
 7. recentlyPlayed
 8. library
 9. getInspired
 10. popular
 11. searchAudio
 */

enum PlayerType: Int {
    case audio = 0
    case playlist
    case downloadedPlaylist
    case topCategories
    case downloadedAudios
    case likedAudios
    case recentlyPlayed
    case library
    case getInspired
    case popular
    case searchAudio
    case sessionAudio
}

// MARK:- PlayerPauseReason
enum PlayerPauseReason : Int {
    case userAction
    case audioChange
    case interruption
}

// MARK:- Volume
enum Volume: Float {
    case normal = 1.0
    case boosted = 2.0
}


// MARK:- RepeatType
enum RepeatType: Int {
    case none = 1
    case all = 2
    case single = 3
}


// MARK: - DJMusicPlayerPlaybackState
@objc public enum DJMusicPlayerPlaybackState: Int {
    
    /// Player is playing
    case playing
    
    /// Player is paused
    case paused
    
    /// Player is stopped
    case stopped
    
    /// Return a readable description
    public var description: String {
        switch self {
        case .playing: return "Player is playing"
        case .paused: return "Player is paused"
        case .stopped: return "Player is stopped"
        }
    }
}


// MARK: - DJMusicPlayerState
@objc public enum DJMusicPlayerState: Int {
    
    /// URL not set
    case urlNotSet
    
    /// Player is ready to play
    case readyToPlay
    
    /// Player is loading
    case loading
    
    /// The loading has finished
    case loadingFinished
    
    /// Error with playing
    case error
    
    /// Return a readable description
    public var description: String {
        switch self {
        case .urlNotSet: return "URL is not set"
        case .readyToPlay: return "Ready to play"
        case .loading: return "Loading"
        case .loadingFinished: return "Loading finished"
        case .error: return "Error"
        }
    }
}


// MARK: - DJMusicPlayer Notifications
extension Notification.Name {
    static let playerQueueDidUpdate = Notification.Name("playerQueueDidUpdate")
    static let playerStateDidChange = Notification.Name("playerStateDidChange")
    static let playbackStateDidChange = Notification.Name("playbackStateDidChange")
    static let playbackProgressDidChange = Notification.Name("playbackProgressDidChange")
    static let playerItemDidChange = Notification.Name("playerItemDidChange")
    static let metadataDidChange = Notification.Name("metadataDidChange")
    
    static let audioDidFinishPlaying = Notification.Name("audioDidFinishPlaying")
}


extension BaseViewController {
    
    func registerForPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playerQueueDidUpdate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playerStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playbackStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playbackProgressDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playerItemDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.metadataDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.audioDidFinishPlaying, object: nil)
    }
    
}

