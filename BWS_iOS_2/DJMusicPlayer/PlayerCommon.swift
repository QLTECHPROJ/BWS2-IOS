//
//  PlayerCommon.swift
//  BWS
//
//  Created by Dhruvit on 01/09/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

/*
 
import Foundation
import UIKit
import AVFoundation
import os.log
import EVReflection

class QueuedSongsData: EVObject {
    var arraySongs = [AudioDetailsDataModel]()
}

enum PlayerType: Int {
    case audio = 0
    case playlist
    case downloadedPlaylist
    case topCategories
    case queue
    case downloadedAudios
    case likedAudios
}

enum Volume: Float {
    case normal = 1.0
    case boosted = 2.0
}

enum RepeatType: Int {
    case none = 1
    case all = 2
    case single = 3
}

func fetchNowPlayingSongs() {
    if let userData = UserDefaults.standard.data(forKey: "NowPlayingSongs") {
        DJMusicPlayer.shared.nowPlayingList = QueuedSongsData(data: userData).arraySongs
    }
    else {
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

func fetchAllQueuedSongs() {
    if let userData = UserDefaults.standard.data(forKey: "QueuedSongs") {
        DJMusicPlayer.shared.queuedSongs = QueuedSongsData(data: userData).arraySongs
    }
    else {
        DJMusicPlayer.shared.queuedSongs = [AudioDetailsDataModel]()
    }
}

func saveQueuedSongs() {
    let queueData = QueuedSongsData()
    queueData.arraySongs = DJMusicPlayer.shared.queuedSongs
    UserDefaults.standard.setValue(queueData.toJsonData(), forKey: "QueuedSongs")
    UserDefaults.standard.synchronize()
    fetchAllQueuedSongs()
}

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
                && DJMusicPlayer.shared.currentlyPlaying?.Download == ""
                && DJMusicPlayer.shared.currentlyPlaying?.isSingleAudio != "1" {
                return true
            }
        }
    }
    
    return false
}

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
                && DJMusicPlayer.shared.currentlyPlaying?.Download == ""
                && DJMusicPlayer.shared.currentlyPlaying?.isSingleAudio != "1" {
                return true
            }
        }
    }
    
    return false
}

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
        else if DJMusicPlayer.shared.nowPlayingList[0].PlaylistID.trim.count > 0 {
            if DJMusicPlayer.shared.nowPlayingList[0].CategoryName == categoryName
                && DJMusicPlayer.shared.currentlyPlaying?.Download == ""
                && DJMusicPlayer.shared.currentlyPlaying?.isSingleAudio != "1" {
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
    }
    else {
        if DJMusicPlayer.shared.nowPlayingList.count > currentIndex {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                let disclaimer = DisclaimerAudio.shared.fetchDisclaimerAudio(data: DJMusicPlayer.shared.currentlyPlaying!)
                DJMusicPlayer.shared.nowPlayingList.insert(disclaimer, at: currentIndex)
                saveNowPlayingSongs()
            }
            if DJMusicPlayer.shared.isPlaying && DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == false {
                DJMusicPlayer.shared.requestToPlay()
            }
        }
        else {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                let disclaimer = DisclaimerAudio.shared.fetchDisclaimerAudio(data: DJMusicPlayer.shared.currentlyPlaying!)
                DJMusicPlayer.shared.nowPlayingList.insert(disclaimer, at: 0)
                saveNowPlayingSongs()
            }
            DJMusicPlayer.shared.playIndex = 0
            if DJMusicPlayer.shared.isPlaying && DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == false {
                DJMusicPlayer.shared.requestToPlay()
            }
        }
    }

//    if DJMusicPlayer.shared.isPlaying {
//        DJMusicPlayer.shared.requestToPlay()
//    }
    
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
}


extension BaseViewController {
    
    func registerForPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playerQueueDidUpdate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playerStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playbackStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playbackProgressDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.playerItemDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDJMusicPlayerNotifications(notification:)), name: NSNotification.Name.metadataDidChange, object: nil)
    }
    
}


// MARK: - DJMusicPlayer
open class DJMusicPlayer: NSObject {
    
    // MARK: - Properties
    public static let shared = DJMusicPlayer()
    
    //    open weak var delegate: DJMusicPlayerDelegate?
    
    open var isAutoPlay = true
    
    open var rate: Float {
        return audioPlayer.rate
    }
    
    var isNowPresenting = false
    
    open var isPlaying: Bool {
        switch playbackState {
        case .playing:
            return true
        case .stopped, .paused:
            return false
        }
    }
    
    open private(set) var state = DJMusicPlayerState.urlNotSet {
        didSet {
            guard oldValue != state else { return }
            //            delegate?.radioPlayer(self, playerStateDidChange: state)
            NotificationCenter.default.post(name: NSNotification.Name.playerStateDidChange, object: nil)
        }
    }
    
    open private(set) var playbackState = DJMusicPlayerPlaybackState.stopped {
        didSet {
            guard oldValue != playbackState else { return }
            //            delegate?.radioPlayer(self, playbackStateDidChange: playbackState)
            NotificationCenter.default.post(name: NSNotification.Name.playbackStateDidChange, object: nil)
        }
    }
    
    // MARK: - Private properties
    private var headphonesConnected: Bool = false
    
    private var lastPlayerItem: AVPlayerItem?
    private var playerItem: AVPlayerItem? {
        didSet {
            playerItemDidChange()
        }
    }
    
    private var audioPlayer = AVPlayer()
    private let updateElapsedTimeInterval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    private let semaphore = DispatchSemaphore(value: 1)
    
    var timeObserverToken : Any?
    
    var latestPlayRequest: AudioDetailsDataModel?
    var currentlyPlaying: AudioDetailsDataModel? {
        didSet {
            saveNowPlayingSongs()
            audioDataDidChange(with: currentlyPlaying)
//            AudioRemoteManager.shared.playBrodcastChannel()
        }
    }
    
    var playIndex : Int {
        get {
            return UserDefaults.standard.integer(forKey: "playIndex")
        }
        set {
            var index = newValue
            if index < 0 {
                index = 0
            }
            UserDefaults.standard.set(index, forKey: "playIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    var playerType : PlayerType {
        get {
            return PlayerType(rawValue: UserDefaults.standard.integer(forKey: "playerType")) ?? PlayerType.audio
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "playerType")
            UserDefaults.standard.synchronize()
        }
    }
    
    var queuedSongs : [AudioDetailsDataModel] = [AudioDetailsDataModel]() {
        didSet {
//            if queuedSongs.count == 0 {
//                playIndex = 0
//            }
//            playIndex = 0
            NotificationCenter.default.post(name: NSNotification.Name.playerQueueDidUpdate, object: nil)
        }
    }
    
    var nowPlayingList : [AudioDetailsDataModel] = [AudioDetailsDataModel]() {
        didSet {
//            if nowPlayingList.count == 0 {
//                playIndex = 0
//            }
//            playIndex = 0
            NotificationCenter.default.post(name: NSNotification.Name.playerQueueDidUpdate, object: nil)
        }
    }
    
    var isStoppedBecauseOfNetwork : Bool = false
    
    var repeatPlaylist : RepeatType {
        get {
            let raw = UserDefaults.standard.integer(forKey: "repeatPlaylist")
            if let typeValue = RepeatType(rawValue: raw) {
                return typeValue
            }
            return RepeatType.none
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "repeatPlaylist")
            UserDefaults.standard.synchronize()
        }
    }
    
    var canShuffle : Bool {
        if nowPlayingList.count > 0 {
            if nowPlayingList.count > 1 {
                return true
            }
            return false
        }
        else if queuedSongs.count > 0 {
            if queuedSongs.count > 1 {
                return true
            }
            return false
        }
        return false
    }
    
    var isPlayingFirst : Bool {
        if repeatPlaylist != .none {
            return false
        }
        return playIndex == 0
    }
    
    var isPlayingLast : Bool {
        if repeatPlaylist != .none {
            return false
        }
        if nowPlayingList.count > 0 {
            return playIndex == nowPlayingList.count - 1
        }
        return playIndex == queuedSongs.count - 1
    }
    
    var shufflePlaylist : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "shufflePlaylist")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shufflePlaylist")
            UserDefaults.standard.synchronize()
            shuffleAllSongs()
        }
    }
    
    var elapsedTime: Double {
        if !audioPlayer.currentTime().seconds.isFinite {
            return 0.0
        }
        return audioPlayer.currentTime().seconds
    }
    
    var duration: Double {
        guard let duration = audioPlayer.currentItem?.asset.duration.seconds else {
            return 0.0
        }
        if !duration.isFinite {
            return 0.0
        }
        return duration
    }
    
    var progress : Float = 0.0
    
    //    var progress : Float {
    //        return Float(currentTime / duration)
    //    }
    
    var canBeContinued: Bool {
        return audioPlayer.currentItem != nil
    }
    
    var boostVolume: Bool = false {
        didSet {
            self.audioPlayer.volume = self.boostVolume
                ? Volume.boosted.rawValue
                : Volume.normal.rawValue
        }
    }
    
    var currentTime: TimeInterval {
        get {
            return CMTimeGetSeconds(self.audioPlayer.currentTime())
        }
        set {
            self.audioPlayer.seek(to: CMTime(seconds: newValue, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        }
    }
    
    func seek(toSecond: Double) {
//        audioPlayer.seek(to: CMTime(seconds: toSecond, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        let seekTime = CMTime(seconds: toSecond, preferredTimescale: Int32(NSEC_PER_SEC))
        audioPlayer.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    private let reachability = DJMusicPlayerReachability()!
    private var isConnected = false
    
    // MARK: - Initialization
    private override init() {
        super.init()
        
        // Enable bluetooth playback
        //        let audioSession = AVAudioSession.sharedInstance()
        //        try? audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.defaultToSpeaker, .allowBluetooth, .allowAirPlay, .mixWithOthers])
        //        try? audioSession.setActive(true)
        
        // Notifications
        setupNotifications()
        
        // Check for headphones
        checkHeadphonesConnection(outputs: AVAudioSession.sharedInstance().currentRoute.outputs)
        
        // Reachability config
        try? reachability.startNotifier()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        isConnected = reachability.connection != .none
    }
    
    // MARK: - Control Methods
    open func play() {
        if audioPlayer.currentItem == nil, playerItem != nil {
            audioPlayer.replaceCurrentItem(with: playerItem)
        }
        
        // Enable bluetooth playback
//        let audioSession = AVAudioSession.sharedInstance()
//        try? audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [.defaultToSpeaker, .allowBluetooth, .allowAirPlay, .mixWithOthers])
//        try? audioSession.setActive(true)
        
//        let audioSession = AVAudioSession.sharedInstance()
//        try? audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.defaultToSpeaker, .allowBluetooth, .allowAirPlay, .mixWithOthers])
//        try? audioSession.setActive(true)
        
        audioPlayer.play()
        playbackState = .playing
        self.addPeriodicTimeObserver()
        
        if playbackState == .stopped {
            self.requestToPlay()
        }
    }
    
    open func pause() {
        audioPlayer.pause()
        playbackState = .paused
    }
    
    open func stop() {
        audioPlayer.replaceCurrentItem(with: nil)
        timedMetadataDidChange(rawValue: nil)
        playbackState = .stopped
    }
    
    open func togglePlaying() {
        isPlaying ? pause() : play()
    }
    
    func playNext() {
        if let item = lastPlayerItem {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        }
//        self.currentlyPlaying = nil
        self.latestPlayRequest = nil
        
        if repeatPlaylist == .all {
            self.currentlyPlaying = nil
            if nowPlayingList.count > 0 {
                if playIndex < nowPlayingList.count - 1 {
                    if self.canPlayFromDownloads(index: playIndex + 1) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = playIndex + 1
                    self.requestToPlay()
                }
                else {
                    if self.canPlayFromDownloads(index: 0) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = 0
                    self.requestToPlay()
                    DJMusicPlayer.shared.shuffleAllSongs()
                }
            }
            else {
                if playIndex < queuedSongs.count - 1 {
                    if self.canPlayFromDownloads(index: playIndex + 1) == false && checkInternet() == false {
                        return
                    }
                    playIndex = playIndex + 1
                    self.requestToPlay()
                }
                else {
                    if self.canPlayFromDownloads(index: 0) == false && checkInternet() == false {
                        return
                    }
                    playIndex = 0
                    self.requestToPlay()
                }
            }
        }
        else if repeatPlaylist == .single {
            self.stop()
            //            self.currentlyPlaying = nil
            self.currentlyPlaying = nil
            self.latestPlayRequest = nil
            self.requestToPlay()
        }
        else {
            if nowPlayingList.count > playIndex {
//                nowPlayingList.remove(at: playIndex)
//                if nowPlayingList.count > playIndex {
//                    self.requestToPlay()
//                }
//                else {
//                    playIndex = 0
//                    self.requestToPlay()
//                }
                if playIndex < nowPlayingList.count - 1 {
                    if self.canPlayFromDownloads(index: playIndex + 1) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = playIndex + 1
                    self.requestToPlay()
                }
                else {
                    DJMusicPlayer.shared.shuffleAllSongs()
                    stop()
                }
            }
            else if queuedSongs.count > playIndex {
                if checkInternet() == false {
                    showAlertToast(message: Theme.strings.alert_check_internet)
                    return
                }
                
                if queuedSongs.count > 1 {
                    queuedSongs.remove(at: playIndex)
                    saveQueuedSongs()
                }
                else {
                    if self.canPlayFromDownloads(index: 0) == false && checkInternet() == false {
                        return
                    }
                    playIndex = 0
                    nowPlayingList = queuedSongs
                    self.requestToPlay()
                    queuedSongs.remove(at: playIndex)
                    saveQueuedSongs()
                    saveNowPlayingSongs()
                }
                
                if queuedSongs.count > playIndex {
                    if self.canPlayFromDownloads(index: playIndex) == false && checkInternet() == false {
                        return
                    }
                    self.requestToPlay()
                }
                else {
                    if currentlyPlaying != nil {
                        stop()
                        playIndex = 0
                        nowPlayingList = [currentlyPlaying!]
                        saveNowPlayingSongs()
                    }
                }
//                else {
//                    playIndex = 0
//                    self.requestToPlay()
//                }
                //                if playIndex < queuedSongs.count - 1 {
                //                    playIndex = playIndex + 1
                //                    self.requestToPlay()
                //                }
            }
            else {
                if currentlyPlaying != nil {
                    self.stop()
                    playIndex = 0
                    nowPlayingList.append(currentlyPlaying!)
                    self.latestPlayRequest = nil
                    saveNowPlayingSongs()
                }
                else {
                    playIndex = 0
                    self.stop()
                }
            }
        }
    }
    
    func playPrevious() {
        if repeatPlaylist == .all {
            self.currentlyPlaying = nil
            if playIndex > 0 {
                if self.canPlayFromDownloads(index: playIndex - 1) == false && checkInternet() == false {
                    if nowPlayingList.count > 0 {
                        // return
                    }
                    else {
                        return
                    }
                }
                playIndex = playIndex - 1
                self.requestToPlay()
            }
            else {
                if nowPlayingList.count > 0 {
                    if self.canPlayFromDownloads(index: nowPlayingList.count - 1) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = nowPlayingList.count - 1
                    self.requestToPlay()
                }
                else {
                    if self.canPlayFromDownloads(index: queuedSongs.count - 1) == false && checkInternet() == false {
                        return
                    }
                    playIndex = queuedSongs.count - 1
                    self.requestToPlay()
                }
            }
        }
        else if repeatPlaylist == .single {
            self.stop()
            //            self.currentlyPlaying = nil
            self.currentlyPlaying = nil
            self.latestPlayRequest = nil
            self.requestToPlay()
        }
        else {
            if playIndex > 0 {
                if nowPlayingList.count > 0{
                    if self.canPlayFromDownloads(index: playIndex - 1) == false && checkInternet() == false {
                        // return
                    }
                    playIndex = playIndex - 1
                    self.requestToPlay()
                }
                else {
                    if checkInternet() == false {
                        showAlertToast(message: Theme.strings.alert_check_internet)
                        return
                    }
                    if queuedSongs.count > playIndex {
                        queuedSongs.remove(at: playIndex)
                        saveQueuedSongs()
                    }
                    if self.canPlayFromDownloads(index: playIndex - 1) == false && checkInternet() == false {
                        return
                    }
                    playIndex = playIndex - 1
                    self.requestToPlay()
                }
                
//                General Condition
//                if self.canPlayFromDownloads(index: playIndex - 1) == false && checkInternet() == false {
//                    return
//                }
//                playIndex = playIndex - 1
//                self.requestToPlay()
            }
        }
    }
    
    func forward() {
        self.seek(toSecond: self.currentTime + 30)
    }
    
    func rewind() {
        self.seek(toSecond: self.currentTime - 30)
    }
    
    func shuffleAllSongs() {
        if shufflePlaylist == false {
            return
        }
        
        if nowPlayingList.count > 1 {
            let currentAudio = nowPlayingList[playIndex]
            
            if currentAudio.isDisclaimer {
                if nowPlayingList.count > playIndex {
                    nowPlayingList.remove(at: playIndex)
                }
                
                var audioToRearrange : AudioDetailsDataModel?
                if let sameAudio = nowPlayingList.filter({ $0.ID == currentAudio.ID }).first, let sameAudioIndex = nowPlayingList.firstIndex(of: sameAudio) {
                    audioToRearrange = sameAudio
                    nowPlayingList.remove(at: sameAudioIndex)
                }
                
                nowPlayingList.shuffle()
                playIndex = 0
                
                if audioToRearrange != nil {
                    nowPlayingList.insert(audioToRearrange!, at: 0)
                }
                
                nowPlayingList.insert(currentAudio, at: 0)
                //            requestToPlay()
                saveNowPlayingSongs()
            }
            else {
                if nowPlayingList.count > playIndex {
                    nowPlayingList.remove(at: playIndex)
                }
                
                nowPlayingList.shuffle()
                playIndex = 0
                nowPlayingList.insert(currentAudio, at: 0)
                //            requestToPlay()
                saveNowPlayingSongs()
            }
            
            return
        }
        
        if queuedSongs.count > 1 {
            let currentAudio = queuedSongs[playIndex]
            
            if queuedSongs.count > playIndex {
                queuedSongs.remove(at: playIndex)
            }
            
            queuedSongs.shuffle()
            playIndex = 0
            queuedSongs.insert(currentAudio, at: 0)
//            requestToPlay()
            saveQueuedSongs()
        }
    }
    
    func repeatSongs() {
        if self.repeatPlaylist == .none {
            if nowPlayingList.count > 1 {
                self.repeatPlaylist = .all
            }
            else {
                self.repeatPlaylist = .single
            }
        }
        else if self.repeatPlaylist == .all {
            self.repeatPlaylist = .single
        }
        else {
            self.repeatPlaylist = .none
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)
        
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
            DJMusicPlayer.shared.currentlyPlaying = nil
            if nowPlayingList.count > playIndex {
                nowPlayingList.remove(at: playIndex)
                saveNowPlayingSongs()
                requestToPlay()
                return
            }
            if queuedSongs.count > playIndex {
                queuedSongs.remove(at: playIndex)
                saveQueuedSongs()
                requestToPlay()
                return
            }
        }
        
        switch repeatPlaylist {
        case .all:
            playNext()
        case .single:
            self.stop()
//            self.currentlyPlaying = nil
            self.currentlyPlaying = nil
            self.latestPlayRequest = nil
            self.requestToPlay()
        default:
            playNext()
        }
    }
    
    // MARK: - Private helpers
    func canPlayFromDownloads(playerData : AudioDetailsDataModel?) -> Bool {
        guard let details = playerData else {
            return false
        }
        
        guard let strUrl = details.AudioFile.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            var url = URL(string: strUrl) else {
                return false
        }
        
        var isLocal = false
        var isInDatabase = false
        
        if CoreDataHelper.shared.checkAudioFileInDatabase(filePath: details.AudioFile) {
            isInDatabase = true
        }
        
        if let localUrl = DJDownloadManager.shared.getFileFromDirectory(fileName: url.lastPathComponent) {
            url = localUrl
            isLocal = true
        }
        
        if isInDatabase == true && isLocal == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_redownload)
            return false
        }
        else if isLocal == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            return false
        }
        
        return true
    }
    
    func canPlayFromDownloads(index : Int) -> Bool {
        var playerData : AudioDetailsDataModel?
        
        if nowPlayingList.count > index {
            playerData = nowPlayingList[index]
        }
        else if queuedSongs.count > index {
            playerData = queuedSongs[index]
        }
        
        guard let details = playerData else {
            return false
        }
        
        guard let strUrl = details.AudioFile.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            var url = URL(string: strUrl) else {
                return false
        }
        
        var isLocal = false
        var isInDatabase = false
        
        if CoreDataHelper.shared.checkAudioFileInDatabase(filePath: details.AudioFile) {
            isInDatabase = true
        }
        
        if let localUrl = DJDownloadManager.shared.getFileFromDirectory(fileName: url.lastPathComponent) {
            url = localUrl
            isLocal = true
        }
        
        if isInDatabase == true && isLocal == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_redownload)
            return false
        }
        else if isLocal == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            return false
        }
        
        return true
    }
    
    func requestToPlay() {
        DJMusicPlayer.shared.isNowPresenting = true
        canPlayFirstTime = false
        if nowPlayingList.count > playIndex {
            if  self.canPlayFromDownloads(playerData: self.nowPlayingList[playIndex]) == false && checkInternet() == false {
//                showAlertToast(message: Theme.strings.alert_check_internet)
                // return
            }
            
            if self.currentlyPlaying?.ID == self.nowPlayingList[playIndex].ID {
                if self.currentlyPlaying?.isDisclaimer == false {
                    return
                }
            }
            
            self.latestPlayRequest = self.currentlyPlaying
            
            let newAudio = self.nowPlayingList[playIndex]
            self.currentlyPlaying = newAudio
        }
        else {
            if self.queuedSongs.count > playIndex {
                if  self.canPlayFromDownloads(playerData: self.queuedSongs[playIndex]) == false && checkInternet() == false {
//                    showAlertToast(message: Theme.strings.alert_check_internet)
                    return
                }
                
                if self.currentlyPlaying?.ID == self.queuedSongs[playIndex].ID {
                    if self.currentlyPlaying?.isDisclaimer == false {
                        return
                    }
                }
                
                self.latestPlayRequest = self.currentlyPlaying
                
                let newAudio = self.queuedSongs[playIndex]
                self.currentlyPlaying = newAudio
            }
        }
    }
    
    private func audioDataDidChange(with playerItem: AudioDetailsDataModel?) {
//        resetPlayer()
        DJMusicPlayer.shared.stop()
        DJMusicPlayer.shared.progress = 0
        
        if self.latestPlayRequest?.ID != self.currentlyPlaying?.ID {
            NotificationCenter.default.post(name: .playerItemDidChange, object: nil)
            if currentlyPlaying?.ID != nil && checkInternet() != false {
                UIViewController().callRecentlyPlayedAPI(audioID: (self.currentlyPlaying?.ID ?? ""), complitionBlock: nil)
            }
        }
        else if self.latestPlayRequest?.isDisclaimer == true {
            NotificationCenter.default.post(name: .playerItemDidChange, object: nil)
            if currentlyPlaying?.ID != nil && checkInternet() != false {
                UIViewController().callRecentlyPlayedAPI(audioID: (self.currentlyPlaying?.ID ?? ""), complitionBlock: nil)
            }
        }
        
        guard let strUrl = playerItem?.AudioFile.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            var url = URL(string: strUrl) else {
                state = .urlNotSet; return
        }
        
        var isLocal = false
        var isInDatabase = false
        
        
        if CoreDataHelper.shared.checkAudioFileInDatabase(filePath: playerItem!.AudioFile) {
            isInDatabase = true
        }
        
        if let localUrl = DJDownloadManager.shared.getFileFromDirectory(fileName: url.lastPathComponent) {
            url = localUrl
            isLocal = true
        }
        
        if isInDatabase == true && isLocal == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_redownload)
            DJMusicPlayer.shared.isStoppedBecauseOfNetwork = true
            return
        }
        else if isLocal == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            DJMusicPlayer.shared.isStoppedBecauseOfNetwork = true
            return
        }
        
//        if let strLocation = playerItem?.downloadLocation.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), strLocation.trim.count > 0 {
//            url = URL(fileURLWithPath: strLocation)
//        }
        
        state = .loading
        
        preparePlayer(with: AVAsset(url: url)) { (success, asset) in
            guard success, let asset = asset else {
                self.resetPlayer()
                self.state = .error
                return
            }
            self.setupPlayer(with: asset)
        }
    }
    
    private func setupPlayer(with asset: AVAsset) {
//        audioPlayer = AVPlayer()
        audioPlayer.volume = 1.0
        audioPlayer.allowsExternalPlayback = false
        playerItem = AVPlayerItem(asset: asset)
    }
    
    /** Reset all player item observers and create new ones
     
     */
    private func playerItemDidChange() {
        
        guard lastPlayerItem != playerItem else { return }
        
        if let item = lastPlayerItem {
            pause()
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
            item.removeObserver(self, forKeyPath: "status")
            item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            item.removeObserver(self, forKeyPath: "timedMetadata")
        }
        
        lastPlayerItem = playerItem
        timedMetadataDidChange(rawValue: nil)
        
        if let item = playerItem {
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.new, context: nil)
            
            audioPlayer.replaceCurrentItem(with: item)
            if isAutoPlay { play() }
        }
        
        //        delegate?.radioPlayer(self, itemDidChange: currentlyPlaying)
        //        NotificationCenter.default.post(name: .playerItemDidChange, object: nil)
    }
    
    private func preparePlayer(with asset: AVAsset?, completionHandler: @escaping (_ isPlayable: Bool, _ asset: AVAsset?)->()) {
        guard let asset = asset else {
            completionHandler(false, nil)
            return
        }
        
        let requestedKey = ["playable"]
        
        asset.loadValuesAsynchronously(forKeys: requestedKey) {
            
            DispatchQueue.main.async {
                var error: NSError?
                
                let keyStatus = asset.statusOfValue(forKey: "playable", error: &error)
                if keyStatus == AVKeyValueStatus.failed || !asset.isPlayable {
                    completionHandler(false, nil)
                    return
                }
                
                completionHandler(true, asset)
            }
        }
    }
    
    private func timedMetadataDidChange(rawValue: String?) {
        let parts = rawValue?.components(separatedBy: " - ")
        let artistName = parts?.first
        let trackName = parts?.last
        //        delegate?.radioPlayer?(self, metadataDidChange: parts?.first, trackName: parts?.last)
        //        delegate?.radioPlayer?(self, metadataDidChange: rawValue)
        NotificationCenter.default.post(name: .metadataDidChange, object: nil)
    }
    
    private func reloadItem() {
        audioPlayer.replaceCurrentItem(with: nil)
        audioPlayer.replaceCurrentItem(with: playerItem)
    }
    
    func resetPlayer() {
        stop()
        playerItem = nil
        lastPlayerItem = nil
//        audioPlayer = AVPlayer()
    }
    
    deinit {
        resetPlayer()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        
        // Remove time observer
        if timeObserverToken != nil {
            self.audioPlayer.removeTimeObserver(timeObserverToken!)
            timeObserverToken = nil
        }
        
        // Add time observer
        timeObserverToken = self.audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { time in
            
            if self.playbackState == .playing || self.playbackState == .paused {
                let currentSeconds = time.seconds
                let totalSeconds = self.duration
                DJMusicPlayer.shared.progress = Float(currentSeconds/totalSeconds)
                print("DJMusicPlayer.shared.progress :- ",DJMusicPlayer.shared.progress)
                //            self.delegate?.radioPlayer(self, playbackProgressDidChange: DJMusicPlayer.shared.progress)
                NotificationCenter.default.post(name: .playbackProgressDidChange, object: nil)
//                AudioRemoteManager.shared.playBrodcastChannel()
            }
        }
    }
    
    // MARK: - Notifications
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    // MARK: - Responding to Interruptions
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        switch type {
        case .began:
            DispatchQueue.main.async {
                self.pause()
                print("handleInterruption :- Pause")
            }
        case .ended:
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //                self.play()
            //                print("handleInterruption :- Play")
            //            }
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // Interruption ended. Playback should resume.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.play()
                    print("handleInterruption :- Play")
                }
            }
            else {
                // Interruption ended. Playback should not resume.
                self.pause()
                print("handleInterruption :- Pause")
            }
        @unknown default:
            break
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? DJMusicPlayerReachability else { return }
        
        // Check if the internet connection was lost
        if reachability.connection != .none, !isConnected {
            checkNetworkInterruption()
        }
        
        isConnected = reachability.connection != .none
    }
    
    // Check if the playback could keep up after a network interruption
    private func checkNetworkInterruption() {
        guard
            let item = playerItem,
            !item.isPlaybackLikelyToKeepUp,
            reachability.connection != .none else { return }
        
//        self.pause()
        
        // Wait 1 sec to recheck and make sure the reload is needed
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if !item.isPlaybackLikelyToKeepUp { self.reloadItem() }
            self.isPlaying ? self.play() : self.pause()
        }
    }
    
    // MARK: - Responding to Route Changes
    
    private func checkHeadphonesConnection(outputs: [AVAudioSessionPortDescription]) {
        for output in outputs where output.portType == .headphones {
            headphonesConnected = true
            break
        }
        headphonesConnected = false
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else { return }
        
        switch reason {
        case .newDeviceAvailable:
            checkHeadphonesConnection(outputs: AVAudioSession.sharedInstance().currentRoute.outputs)
        case .oldDeviceUnavailable:
            guard let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription else { return }
            checkHeadphonesConnection(outputs: previousRoute.outputs);
            DispatchQueue.main.async { self.headphonesConnected ? () : self.pause() }
        default: break
        }
    }
    
    // MARK: - KVO
    
    /// :nodoc:
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let item = object as? AVPlayerItem, let keyPath = keyPath, item == self.playerItem {
            
            switch keyPath {
                
            case "status":
                
//                if audioPlayer.status == AVPlayer.Status.readyToPlay {
//                    self.state = .readyToPlay
//                } else if audioPlayer.status == AVPlayer.Status.failed {
//                    self.state = .error
//                }
                break
                
            case "playbackBufferEmpty":
                
                if item.isPlaybackBufferEmpty {
                    self.state = .loading
                    self.checkNetworkInterruption()
                }
                
            case "playbackLikelyToKeepUp":
                
                self.state = item.isPlaybackLikelyToKeepUp ? .loadingFinished : .loading
                
            case "timedMetadata":
                let rawValue = item.timedMetadata?.first?.value as? String
                timedMetadataDidChange(rawValue: rawValue)
                
            default:
                break
            }
        }
    }
}

 */
