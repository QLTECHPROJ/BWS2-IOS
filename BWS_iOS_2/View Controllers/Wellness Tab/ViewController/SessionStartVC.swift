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
    var sessionDescriptionData : SessionDescriptionDataModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = 1
        
        setupUI()
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        
    }
    
    override func setupData() {
        lblDesc.text = sessionDescriptionData?.step_long_description ?? ""
    }
    
    // Play Audio
    func playAudio(audioData : AudioDetailsDataModel) {
        if audioData.AudioFile.trim.count > 0 {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                return
            }
            
            if isPlayingSingleAudio() && isPlayingAudio(audioID: audioData.ID) {
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
            DJMusicPlayer.shared.playerType = .audio
            DJMusicPlayer.shared.playingFrom = "Session Audio"
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedStart(_ sender: UIButton) {
        if let audioData = sessionDescriptionData?.step_audio {
            playAudio(audioData: audioData)
        }
    }
    
}

