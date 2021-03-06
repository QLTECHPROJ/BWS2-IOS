//
//  PlayerVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlayerVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBackword: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAudioName: UILabel!
    @IBOutlet weak var lblPlayTime : UILabel!
    @IBOutlet weak var lblDuration : UILabel!
    
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var downloadProgressView : KDCircularProgress!
    
    
    // MARK:- VARIABLES
    var audioDetails : AudioDetailsDataModel?
    var isComeFrom = "Audio"
    var sliderEvent : UITouch.Phase = .ended
    var sliderLastValue : Float?
    var shouldCallAPI : Bool = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
        registerForPlayerNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayerData), name: .playerItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadProgress), name: .refreshDownloadProgress, object: nil)
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        playbackSlider.minimumValue = 0.0
        if self.sliderEvent == .ended {
            self.playbackSlider.value = DJMusicPlayer.shared.progress
        }
        playbackSlider.tintColor = Theme.colors.white
        playbackSlider.maximumValue = 1.0
        playbackSlider.isContinuous = true
        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged(playbackSlider:event:)), for: .valueChanged)
        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged(playbackSlider:event:)), for: .touchUpInside)
        
        // Download Progress View
        downloadProgressView.isHidden = true
        downloadProgressView.startAngle = -90
        downloadProgressView.progressThickness = 0.5
        downloadProgressView.trackThickness = 0.5
        downloadProgressView.clockwise = true
        downloadProgressView.gradientRotateSpeed = 2
        downloadProgressView.roundedCorners = false
        downloadProgressView.glowMode = .forward
        downloadProgressView.glowAmount = 0
        downloadProgressView.set(colors: Theme.colors.orange_F1646A)
        downloadProgressView.trackColor = Theme.colors.gray_DDDDDD
        downloadProgressView.backgroundColor = Theme.colors.white.withAlphaComponent(0.20)
        downloadProgressView.cornerRadius = downloadProgressView.frame.size.height / 2
        downloadProgressView.clipsToBounds = true
    }
    
    override func setupData() {
        var data : AudioDetailsDataModel?
        
        if let detail = audioDetails {
            data = detail
        }
        
        if let audioData = DJMusicPlayer.shared.currentlyPlaying {
            if data?.ID == audioData.ID {
                audioData.Like = (data?.Like ?? "0")
            }
            data = audioData
            audioDetails = data
        }
        
        if let details = data {
            if DJMusicPlayer.shared.playerType == .playlist || DJMusicPlayer.shared.playerType == .downloadedPlaylist {
                lblCategory.text = DJMusicPlayer.shared.currentPlaylist?.PlaylistName ?? details.Audiomastercat
                lblAudioName.text = details.Name
            } else {
                lblCategory.text = details.Name
                lblAudioName.isHidden = true
            }
            
            lblDuration.text = details.AudioDuration
            
            lblPlayTime.text = getPlayTime()
            
            switch DJMusicPlayer.shared.playbackState {
            case .playing:
                btnPlay.setImage(UIImage(named: "Pause"), for: UIControl.State.normal)
            case .paused:
                btnPlay.setImage(UIImage(named: "Play"), for: UIControl.State.normal)
            default:
                btnPlay.setImage(UIImage(named: "Play"), for: UIControl.State.normal)
            }
            
            if DJMusicPlayer.shared.state == .loading && DJMusicPlayer.shared.isPlaying {
                if checkInternet() {
                    activityIndicator.startAnimating()
                    btnPlay.alpha = 0
                } else {
                    activityIndicator.stopAnimating()
                    btnPlay.alpha = 1
                    btnPlay.setImage(UIImage(named: "Play"), for: UIControl.State.normal)
                }
            } else {
                activityIndicator.stopAnimating()
                btnPlay.alpha = 1
            }
            
            // For Download
            let isInDatabase = CoreDataHelper.shared.checkAudioInDatabase(audioData: details)
            let isDownloaded = DJDownloadManager.shared.checkFileExists(fileName: details.AudioFile)
            
            if isInDatabase && isDownloaded == false && checkInternet() == false {
                btnDownload.isUserInteractionEnabled = false
                btnDownload.setImage(UIImage(named: "download_gray_round"), for: UIControl.State.normal)
            } else if isInDatabase {
                btnDownload.isUserInteractionEnabled = false
                btnDownload.setImage(UIImage(named: "download_complete_round"), for: UIControl.State.normal)
                self.updateDownloadProgress()
            } else {
                btnDownload.isUserInteractionEnabled = true
                btnDownload.setImage(UIImage(named: "download_white_round"), for: UIControl.State.normal)
            }
        }
        
        var enableOptions = checkInternet()
        if enableOptions == true {
            if lockDownloads == "1" || lockDownloads == "2" {
                enableOptions = false
            }
        }
        
        if audioDetails?.isDisclaimer == true {
            enableOptions = false
            
            playbackSlider.isUserInteractionEnabled = false
            
            btnForward.isEnabled = false
            btnBackword.isEnabled = false
            
            btnDownload.isEnabled = false
        } else {
            playbackSlider.isUserInteractionEnabled = true
            
            btnForward.isEnabled = true
            btnBackword.isEnabled = true
            
            btnDownload.isEnabled = true
        }
        
        btnInfo.isEnabled = enableOptions
    }
    
    @objc override func refreshDownloadData() {
        updateDownloadProgress()
        self.setupData()
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
        
        //        let playTime = String(format: "%02d:%02d", minutes, seconds)
        //        let duration = DJMusicPlayer.shared.currentlyPlaying?.AudioDuration ?? "00:00"
        //        let progress = String(format: "%0.3f",DJMusicPlayer.shared.progress)
        //        print(" - (progress - \(progress)) : (playTime - \(playTime)) : (duration - \(duration))")
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func updateDownloadProgress() {
        if checkInternet() == false {
            return
        }
        
        guard let details = audioDetails else {
            return
        }
        
        let isInDatabase = CoreDataHelper.shared.checkAudioInDatabase(audioData: details)
        let isDownloaded = DJDownloadManager.shared.checkFileExists(fileName: details.AudioFile)
        let isDownloading = DJDownloadManager.shared.isCurrentlyDownloading(audioFile: details.AudioFile)
        
        if isInDatabase && isDownloaded {
            downloadProgressView.isHidden = true
            btnDownload.isUserInteractionEnabled = false
            btnDownload.alpha = 1
            btnDownload.setImage(UIImage(named: "download_complete_round"), for: UIControl.State.normal)
        } else if isInDatabase && isDownloading {
            btnDownload.alpha = 0
            btnDownload.isUserInteractionEnabled = false
            downloadProgressView.isHidden = false
            downloadProgressView.progress = DJDownloadManager.shared.downloadProgress
        } else if isInDatabase && isDownloading == false {
            btnDownload.alpha = 0
            btnDownload.isUserInteractionEnabled = false
            downloadProgressView.isHidden = false
            downloadProgressView.progress = 0
        } else {
            downloadProgressView.isHidden = true
            btnDownload.isUserInteractionEnabled = true
            btnDownload.alpha = 1
            btnDownload.setImage(UIImage(named: "download_white_round"), for: UIControl.State.normal)
        }
    }
    
    @objc func updateProgressView() {
        lblPlayTime.text = getPlayTime()
        if self.sliderEvent == .ended {
            self.playbackSlider.value = DJMusicPlayer.shared.progress
        }
    }
    
    @objc func updatePlayerData() {
        self.setupData()
        if self.sliderEvent == .ended {
            self.playbackSlider.value = DJMusicPlayer.shared.progress
        }
    }
    
    @objc func playbackSliderValueChanged(playbackSlider:UISlider, event: UIEvent) {
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                self.sliderEvent = .began
                self.sliderLastValue = playbackSlider.value
                
                // Segment Tracking
                SegmentTracking.shared.audioPlaybackEvents(name: SegmentTracking.eventNames.Audio_Seek_Started, audioData: self.audioDetails, trackingType: .track)
                break
                
            case .moved:
                self.sliderEvent = .moved
                break
                
            case .ended:
                let value = Double(playbackSlider.value)
                let seconds = value * DJMusicPlayer.shared.duration
                
                // Segment Tracking
                if let oldValue = sliderLastValue {
                    if playbackSlider.value < oldValue {
                        SegmentTracking.shared.audioPlaybackEvents(name: SegmentTracking.eventNames.Audio_Seek_Completed, audioData: self.audioDetails, seekDirection: "Forwarded", seekPosition: seconds, trackingType: .track)
                    } else {
                        SegmentTracking.shared.audioPlaybackEvents(name: SegmentTracking.eventNames.Audio_Seek_Completed, audioData: self.audioDetails, seekDirection: "Backwarded", seekPosition: seconds, trackingType: .track)
                    }
                    
                    sliderLastValue = nil
                }
                
                DJMusicPlayer.shared.seek(toSecond: seconds)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.sliderEvent = .ended
                }
                print("value :- \(value)")
                print("duration :- \(DJMusicPlayer.shared.duration)")
                print("seconds :- \(seconds)")
                break
                
            default:
                break
            }
        }
    }
    
    override func handleDJMusicPlayerNotifications(notification: Notification) {
        switch notification.name {
        case .playbackProgressDidChange:
            self.updateProgressView()
        case .playerItemDidChange:
            playbackSlider.value = 0
            lblPlayTime.text = "00:00"
            self.updatePlayerData()
        case .playerQueueDidUpdate, .playbackStateDidChange, .playerStateDidChange:
            self.updatePlayerData()
        default:
            break
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func infoClicked(sender : UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if  audioDetails?.IsLock == "1" || audioDetails?.IsLock == "2" {
            // Nothing
        } else {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AudioDetailVC.self)
            aVC.audioDetails = self.audioDetails
            aVC.isComeFrom = self.isComeFrom
            aVC.source = "Main Player Screen"
            aVC.didClosePlayerDetail = {
                DispatchQueue.main.async {
                    self.setupData()
                }
            }
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func playClicked(sender : UIButton) {
        DJMusicPlayer.shared.playerScreen = .mainPlayer
        
        if DJMusicPlayer.shared.playbackState == .stopped {
            if DJMusicPlayer.shared.canPlayFromDownloads(playerData: audioDetails!) == false && checkInternet() == false {
                // return
            }
            
            DJMusicPlayer.shared.currentlyPlaying = nil
            DJMusicPlayer.shared.latestPlayRequest = nil
            DJMusicPlayer.shared.resetPlayer()
            DJMusicPlayer.shared.requestToPlay()
        } else if DJMusicPlayer.shared.playbackState == .paused {
            if DJMusicPlayer.shared.canPlayFromDownloads(playerData: audioDetails!) == false && checkInternet() == false {
                // return
            }
            
            DJMusicPlayer.shared.play(isResume: true)
        } else {
            DJMusicPlayer.shared.pause(pauseReason: .userAction)
        }
    }
    
    @IBAction func rewindClicked(sender : UIButton) {
        DJMusicPlayer.shared.playerScreen = .mainPlayer
        
        // Segment Tracking
        let seconds : Double = DJMusicPlayer.shared.currentTime - 30
        SegmentTracking.shared.audioPlaybackEvents(name: SegmentTracking.eventNames.Audio_Backwarded, audioData: self.audioDetails, seekDirection: "Backwarded", seekPosition: seconds, trackingType: .track)
        
        DJMusicPlayer.shared.rewind()
    }
    
    @IBAction func forwardClicked(sender : UIButton) {
        if (DJMusicPlayer.shared.duration - DJMusicPlayer.shared.currentTime) <= 30 {
            showAlertToast(message: Theme.strings.please_wait)
            return
        }
        
        DJMusicPlayer.shared.playerScreen = .mainPlayer
        
        // Segment Tracking
        let seconds : Double = DJMusicPlayer.shared.currentTime + 30
        SegmentTracking.shared.audioPlaybackEvents(name: SegmentTracking.eventNames.Audio_Forwarded, audioData: self.audioDetails, seekDirection: "Forwarded", seekPosition: seconds, trackingType: .track)
        
        DJMusicPlayer.shared.forward()
    }
    
    @IBAction func downloadClicked(sender : UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if lockDownloads == "1" {
            openInactivePopup(controller: self, openWithNavigation: true)
            return
        } else if lockDownloads == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
            return
        }
        
        if let details = self.audioDetails {
            CoreDataHelper.shared.saveAudio(audioData: details, isSingleAudio: true)
            
            // Segment Tracking
            SegmentTracking.shared.audioDetailsEvents(name: SegmentTracking.eventNames.Audio_Download_Started, audioData: self.audioDetails, source: "Main Player", trackingType: .track)
        }
    }
    
}
