//
//  SessionStartVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 20/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionStartVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblDesc: UILabel!
    
    
    // MARK:- VARIABLES
    var sessionStepData : SessionListDataMainModel?
    var sessionDescriptionData : SessionDescriptionDataModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = 1
        
        setupUI()
        setupData()
        registerForPlayerNotifications()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        
    }
    
    override func setupData() {
        lblDesc.text = sessionDescriptionData?.step_long_description ?? ""
    }
    
    override func handleDJMusicPlayerNotifications(notification: Notification) {
        switch notification.name {
        case .audioDidFinishPlaying:
            self.handleNavigationForSession()
        default:
            break
        }
    }
    
    // Play Audio
    func playAudio(audioData : AudioDetailsDataModel) {
        if audioData.AudioFile.trim.count > 0 {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                return
            }
            
            if isPlayingAudioFrom(playerType: .sessionAudio) && isPlayingAudio(audioID: audioData.ID) {
                if DJMusicPlayer.shared.isPlaying == false {
                    DJMusicPlayer.shared.play(isResume: true)
                }
                
                let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlayerVC.self)
                aVC.audioDetails = audioData
                aVC.modalPresentationStyle = .overFullScreen
                self.present(aVC, animated: true, completion: nil)
                return
            }
            
            self.presentAudioPlayer(playerData: audioData)
            DJMusicPlayer.shared.playerType = .sessionAudio
            DJMusicPlayer.shared.playingFrom = "Session Audio"
        }
    }
    
    func handleNavigationForSession() {
        guard let audioData = DJMusicPlayer.shared.currentlyPlaying else {
            return
        }
        
        if audioData.sessionId != sessionStepData?.session_id && audioData.sessionStepId != sessionStepData?.step_id {
            return
        }
        
        if self.navigationController?.presentedViewController == nil {
            return
        }
        
        guard let controllers = self.navigationController?.viewControllers else {
            return
        }
        
        for controller in controllers {
            if controller.isKind(of: SessionDetailVC.self) {
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedStart(_ sender: UIButton) {
        if let audioData = sessionDescriptionData?.step_audio {
            audioData.sessionId = self.sessionStepData?.session_id ?? ""
            audioData.sessionStepId = self.sessionStepData?.step_id ?? ""
            playAudio(audioData: audioData)
        }
    }
    
}

