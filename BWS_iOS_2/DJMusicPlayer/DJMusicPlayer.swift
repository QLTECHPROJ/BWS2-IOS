//
//  DJMusicPlayer.swift
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
import MediaPlayer

// MARK: - DJMusicPlayer
open class DJMusicPlayer: NSObject {
    
    // MARK: - Properties
    public static let shared = DJMusicPlayer()
    fileprivate var backgroundIdentifier = UIBackgroundTaskIdentifier.invalid
    
    open var isAutoPlay = true
    
    open var rate: Float {
        return audioPlayer.rate
    }
    
    var isFirstPlaybackAudio : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isFirstPlaybackAudio")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFirstPlaybackAudio")
            UserDefaults.standard.synchronize()
        }
    }
    
    var shouldPlayDisclaimer : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "shouldPlayDisclaimer")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldPlayDisclaimer")
            UserDefaults.standard.synchronize()
        }
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
            NotificationCenter.default.post(name: NSNotification.Name.playerStateDidChange, object: nil)
        }
    }
    
    open private(set) var playbackState = DJMusicPlayerPlaybackState.stopped {
        didSet {
            guard oldValue != playbackState else { return }
            NotificationCenter.default.post(name: NSNotification.Name.playbackStateDidChange, object: nil)
        }
    }
    
    // MARK: - Private properties
    private var headphonesConnected: Bool = false
    
    var lastPlayerItem: AVPlayerItem?
    private var playerItem: AVPlayerItem? {
        didSet {
            playerItemDidChange()
        }
    }
    
    var audioPlayer = AVPlayer()
    
    var timeObserverToken : Any?
    
    var latestPlayRequest: AudioDetailsDataModel?
    var currentlyPlaying: AudioDetailsDataModel? {
        didSet {
            saveNowPlayingSongs()
            audioDataDidChange(with: currentlyPlaying)
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
    
    var currentPlaylist : PlaylistDetailsModel? {
        get {
            if let playlistData = UserDefaults.standard.data(forKey: "currentPlaylist") {
                return PlaylistDetailsModel(data: playlistData)
            }
            return nil
        }
        set {
            if let newData = newValue {
                UserDefaults.standard.setValue(newData.toJsonData(), forKey: "currentPlaylist")
            } else {
                UserDefaults.standard.setValue(nil, forKey: "currentPlaylist")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    var playingFrom : String {
        get {
            return UserDefaults.standard.string(forKey: "playingFrom") ?? "Audios"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playingFrom")
            UserDefaults.standard.synchronize()
        }
    }
    
    var playerScreen : PlayerScreen {
        get {
            guard let screen = UserDefaults.standard.string(forKey: "playerScreen") else {
                return .miniPlayer
            }
            return PlayerScreen(rawValue: screen) ?? PlayerScreen.miniPlayer
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "playerScreen")
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
    
    var lastPlayerType : PlayerType {
        get {
            return PlayerType(rawValue: UserDefaults.standard.integer(forKey: "lastPlayerType")) ?? PlayerType.audio
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "lastPlayerType")
            UserDefaults.standard.synchronize()
        }
    }
    
    var nowPlayingList : [AudioDetailsDataModel] = [AudioDetailsDataModel]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.playerQueueDidUpdate, object: nil)
        }
    }
    
    var isStoppedBecauseOfNetwork : Bool = false
    
    var isPlayingFirst : Bool {
        return false
    }
    
    var isPlayingLast : Bool {
        return false
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
        // setupNotifications()
        
        // Check for headphones
        checkHeadphonesConnection(outputs: AVAudioSession.sharedInstance().currentRoute.outputs)
        
        // Reachability config
        try? reachability.startNotifier()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        isConnected = reachability.connection != .none
    }
    
    // MARK: - Control Methods
    open func play(isResume : Bool) {
        configureBackgroundAudioTask()
        if audioPlayer.currentItem == nil, playerItem != nil {
            audioPlayer.replaceCurrentItem(with: playerItem)
        }
        
        audioPlayer.play()
        playbackState = .playing
        self.addPeriodicTimeObserver()
        
        if playbackState == .stopped {
            self.requestToPlay()
        }
        
        if isResume && isFirstPlaybackAudio == false {
            // Segment Tracking
            if currentlyPlaying?.isDisclaimer == true {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Disclaimer Resumed", audioData: nil, trackingType: .track)
            } else {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Resumed", audioData: nil, trackingType: .track)
            }
        } else {
            // Segment Tracking
            if isFirstPlaybackAudio {
                isFirstPlaybackAudio = false
                if playerType == .playlist || playerType == .downloadedPlaylist {
                    // SegmentTracking.shared.playlistEvents(name: "Playlist Started", objPlaylist: self.currentPlaylist, passPlaybackDetails: true, passPlayerType: true, audioData: nil, trackingType: .track)
                } else {
                    // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Playback Started", audioData: nil, trackingType: .track)
                }
            }
            
            if currentlyPlaying?.isDisclaimer == true {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Disclaimer Started", audioData: nil, trackingType: .track)
            } else {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Started", audioData: nil, trackingType: .track)
            }
        }
        
        // update control center
        updateInfoCenter()
        setupRemoteTransportControls()
        
        // setup Notifications
        setupNotifications()
    }
    
    func pause(pauseReason : PlayerPauseReason, interruptionMethod : String? = nil) {
        audioPlayer.pause()
        playbackState = .paused
        
        // Segment Tracking
        switch pauseReason {
        case .interruption:
            if currentlyPlaying?.isDisclaimer == true {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Disclaimer Interrupted", audioData: nil, interruptionMethod: interruptionMethod, trackingType: .track)
            } else {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Interrupted", audioData: nil, interruptionMethod: interruptionMethod, trackingType: .track)
            }
            break
        case .userAction:
            if currentlyPlaying?.isDisclaimer == true {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Disclaimer Paused", audioData: nil, trackingType: .track)
            } else {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Paused", audioData: nil, trackingType: .track)
            }
            break
        default:
            break
        }
    }
    
    open func stop(shouldTrack : Bool = false) {
        audioPlayer.replaceCurrentItem(with: nil)
        timedMetadataDidChange(rawValue: nil)
        playbackState = .stopped
        
        // Segment Tracking
        if shouldTrack == true {
            isFirstPlaybackAudio = true
            if playerType == .playlist || playerType == .downloadedPlaylist {
                // SegmentTracking.shared.playlistEvents(name: "Playlist Completed", objPlaylist: self.currentPlaylist, passPlaybackDetails: true, passPlayerType: true, audioData: nil, trackingType: .track)
            } else {
                // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Playback Completed", audioData: nil, trackingType: .track)
            }
        }
    }
    
    open func togglePlaying() {
        isPlaying ? pause(pauseReason: .userAction) : play(isResume: true)
    }
    
    func forward() {
        self.seek(toSecond: self.currentTime + 30)
    }
    
    func rewind() {
        self.seek(toSecond: self.currentTime - 30)
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)
        
        // Segment Tracking
        if currentlyPlaying?.isDisclaimer == true {
            // SegmentTracking.shared.audioPlaybackEvents(name: "Disclaimer Completed", audioData: nil, trackingType: .track)
        } else {
            // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Completed", audioData: nil, trackingType: .track)
        }
        
        if self.currentlyPlaying?.isDisclaimer == true {
            DJMusicPlayer.shared.shouldPlayDisclaimer = false
            self.currentlyPlaying = nil
            if nowPlayingList.count > playIndex {
                nowPlayingList.remove(at: playIndex)
                saveNowPlayingSongs()
                requestToPlay()
                return
            }
        }
        
        playNext(isForce: false)
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
        } else if isLocal == false && checkInternet() == false {
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
        } else if isLocal == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            return false
        }
        
        return true
    }
    
    func requestToPlay() {
        self.isNowPresenting = true
        canPlayFirstTime = false
        if nowPlayingList.count > playIndex {
            if  self.canPlayFromDownloads(playerData: self.nowPlayingList[playIndex]) == false && checkInternet() == false {
                //                showAlertToast(message: Theme.strings.alert_check_internet)
                //                return
            }
            
            /*
            if self.currentlyPlaying?.ID == self.nowPlayingList[playIndex].ID {
                if self.currentlyPlaying?.isDisclaimer == false {
                    isAutoPlay = true
                    return
                }
            }*/
            
            self.latestPlayRequest = self.currentlyPlaying
            
            let newAudio = self.nowPlayingList[playIndex]
            self.currentlyPlaying = newAudio
        }
    }
    
    private func audioDataDidChange(with playerItem: AudioDetailsDataModel?) {
        //        resetPlayer()
        self.stop()
        self.progress = 0
        
        if self.latestPlayRequest?.ID != self.currentlyPlaying?.ID {
            NotificationCenter.default.post(name: .playerItemDidChange, object: nil)
            if currentlyPlaying?.ID != nil && checkInternet() != false {
                UIViewController().callRecentlyPlayedAPI(audioID: (self.currentlyPlaying?.ID ?? ""), complitionBlock: nil)
            }
        } else if self.latestPlayRequest?.isDisclaimer == true {
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
            self.isStoppedBecauseOfNetwork = true
            return
        } else if isLocal == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            self.isStoppedBecauseOfNetwork = true
            return
        }
        
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
        
        // Segment Tracking
        if currentlyPlaying?.isDisclaimer == false {
            // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Buffer Started", audioData: nil, trackingType: .track)
        }
    }
    
    /** Reset all player item observers and create new ones
     
     */
    private func playerItemDidChange() {
        
        guard lastPlayerItem != playerItem else { return }
        
        if let item = lastPlayerItem {
            pause(pauseReason: .audioChange)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
            item.removeObserver(self, forKeyPath: "status")
            item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            item.removeObserver(self, forKeyPath: "timedMetadata")
            
            item.removeObserver(self, forKeyPath: "playbackBufferFull")
            item.removeObserver(self, forKeyPath: "timeControlStatus")
        }
        
        lastPlayerItem = playerItem
        timedMetadataDidChange(rawValue: nil)
        
        if let item = playerItem {
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.new, context: nil)
            
            item.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "timeControlStatus", options: NSKeyValueObservingOptions.new, context: nil)
            
            audioPlayer.replaceCurrentItem(with: item)
            if isAutoPlay { play(isResume: false) }
            isAutoPlay = true
        }
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
        print("artistName :- ",parts?.first ?? "")
        print("trackName :- ",parts?.last ?? "")
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
    
    func getPlayTime() -> String {
        if DJMusicPlayer.shared.currentTime.isNaN || DJMusicPlayer.shared.currentTime.isInfinite {
            return "00:00"
        }
        
        let currentTime = DJMusicPlayer.shared.currentTime
        let hours = Int((currentTime / 60) / 60)
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        let playTime = String(format: "%02d:%02d", minutes, seconds)
        let duration = DJMusicPlayer.shared.currentlyPlaying?.AudioDuration ?? "00:00"
        let progress = String(format: "%0.3f",DJMusicPlayer.shared.progress)
        print(" - (progress - \(progress)) : (playTime - \(playTime)) : (duration - \(duration))")
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func addPeriodicTimeObserver() {
        // Invoke callback every half second
        // let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        
        // Remove time observer
        if timeObserverToken != nil {
            self.audioPlayer.removeTimeObserver(timeObserverToken!)
            timeObserverToken = nil
        }
        
        // Add time observer
        timeObserverToken = self.audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { time in
            
            let playbackLikelyToKeepUp = self.audioPlayer.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false {
                //Here start the activity indicator inorder to show buffering
                // self.state = .loading
            } else {
                //stop the activity indicator
                // self.state = .loadingFinished
            }
            
            if self.playbackState == .playing || self.playbackState == .paused {
                let currentSeconds = time.seconds
                let totalSeconds = self.duration
                self.progress = Float(currentSeconds/totalSeconds)
                _ = self.getPlayTime()
                //                print("DJMusicPlayer.shared.progress :- ",self.progress)
                NotificationCenter.default.post(name: .playbackProgressDidChange, object: nil)
                
                // Segment Tracking
                if Int(self.currentTime) > 0 && Int(self.currentTime) % 300 == 0 {
                    if self.currentlyPlaying?.isDisclaimer == true {
                        // SegmentTracking.shared.audioPlaybackEvents(name: "Disclaimer Playing", audioData: nil, trackingType: .track)
                    } else {
                        // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Playing", audioData: nil, trackingType: .track)
                    }
                }
            }
        }
    }
    
    // MARK: - Notifications
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        notificationCenter.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
        
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
                self.pause(pauseReason: .interruption)
                print("handleInterruption :- Pause")
            }
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // Interruption ended. Playback should resume.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.play(isResume: true)
                    print("handleInterruption :- Play")
                }
            } else {
                // Interruption ended. Playback should not resume.
                self.pause(pauseReason: .interruption)
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
            self.isPlaying ? self.play(isResume: true) : self.pause(pauseReason: .interruption, interruptionMethod: "Network Interruption")
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
            DispatchQueue.main.async { self.headphonesConnected ? () : self.pause(pauseReason: .userAction) }
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
                    
                    // Segment Tracking
                    if currentlyPlaying?.isDisclaimer == false {
                        // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Buffer Started", audioData: nil, trackingType: .track)
                    }
                }
                break
                
            case "playbackLikelyToKeepUp":
                self.state = item.isPlaybackLikelyToKeepUp ? .loadingFinished : .loading
                
                if item.isPlaybackLikelyToKeepUp {
                    // Segment Tracking
                    if currentlyPlaying?.isDisclaimer == false {
                        // SegmentTracking.shared.audioPlaybackEvents(name: "Audio Buffer Completed", audioData: nil, trackingType: .track)
                    }
                }
                break
                
            case "playbackBufferFull":
                self.state = item.isPlaybackBufferFull ? .loadingFinished : .loading
                break
                
            case "timedMetadata":
                let rawValue = item.timedMetadata?.first?.value as? String
                timedMetadataDidChange(rawValue: rawValue)
                break
                
            case "timeControlStatus":
                if audioPlayer.timeControlStatus == .playing || audioPlayer.timeControlStatus == .paused {
                    // self.state = (item.isPlaybackLikelyToKeepUp || item.isPlaybackBufferFull) ? .loadingFinished : .loading
                }
                break
                
            default:
                break
            }
        }
    }
    
    // MARK: Configure Background Audio Task
     func configureBackgroundAudioTask() {
        backgroundIdentifier =  UIApplication.shared.beginBackgroundTask (expirationHandler: { () -> Void in
//            UIApplication.shared.endBackgroundTask(self.backgroundIdentifier)
            self.backgroundIdentifier = UIBackgroundTaskIdentifier.invalid
        })
    }
    
}
