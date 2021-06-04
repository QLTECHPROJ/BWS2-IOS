//
//  CancelSubVC.swift
//  BWS
//
//  Created by Sapu on 24/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import youtube_ios_player_helper


class CancelSubVC: BaseViewController ,YTPlayerViewDelegate{
    
    // MARK:- OUTLETS
    @IBOutlet var buttons : [UIButton]!
    @IBOutlet var txtView : UITextView!
    @IBOutlet var lblPlaceholder : UILabel!
    @IBOutlet var btnCancel : UIButton!
    
    @IBOutlet weak var viewVideo: YTPlayerView!
    
    
    // MARK:- VARIABLES
    var index = 1
    var player: AVPlayer?
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewVideo.delegate = self
        viewVideo.load(withVideoId: "y1rfRW6WX08")
//        video()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewVideo.playVideo()
       // DJMusicPlayer.shared.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //video()
    }
    
    // MARK:- FUNCTIONS
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        viewVideo.playVideo()
    }
    func video() {

           // get the path string for the video from assets
           let videoString:String? = Bundle.main.path(forResource: "Before You Go...", ofType: "mp4")
           guard let unwrappedVideoPath = videoString else {return}

           // convert the path string to a url
           let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)

           // initialize the video player with the url
           self.player = AVPlayer(url: videoUrl)

           // create a video layer for the player
           let layer: AVPlayerLayer = AVPlayerLayer(player: player)

           // make the layer the same size as the container view
           layer.frame = viewVideo.bounds

           // make the video fill the layer as much as possible while keeping its aspect size
           layer.videoGravity = AVLayerVideoGravity.resizeAspectFill

           // add the layer to the container view
           viewVideo.layer.addSublayer(layer)
           player?.play()
       }
    override func setupUI() {
        
//        let url = URL(string:"https://clips.vorwaerts-gmbh.de/big_b.mp4")
//       let player = AVPlayer(url: url!)
//       let avPlayerLayer = AVPlayerLayer(player: player)
//        avPlayerLayer.frame = self.viewVideo.bounds
//        avPlayerLayer.videoGravity = .resizeAspect
//        self.viewVideo.layer.addSublayer(avPlayerLayer)
//        player.play()
        
        
        for btn in buttons {
            if btn.tag == index {
                btn.setImage(UIImage(named: "GreenSelect"), for: .normal)
            }
            else {
                btn.setImage(UIImage(named: "GreenDeselect"), for: .normal)
            }
        }
        
        if index != 4 {
            txtView.text = ""
            txtView.isUserInteractionEnabled = false
            lblPlaceholder.isHidden = false
        }
        else {
            txtView.isUserInteractionEnabled = true
        }
    }
    
    func checkValidation() -> Bool {
        let otherReasonCount = txtView.text.trim.count
        if index == 4 && otherReasonCount == 0 {
            showAlertToast(message: "Cancellation reason is required")
            return false
        }
        
        return true
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reasonClicked(sender : UIButton) {
        self.view.endEditing(true)
        index = sender.tag
        setupUI()
    }
    
    @IBAction func cancelClicked(sender : UIButton) {
        self.view.endEditing(true)
      
        if checkValidation() {
//            let aVC = AppStoryBoard.playlist.viewController(viewControllerClass: AlertPopUpVC.self)
//
//            aVC.titleText = "Cancel subscription"
//            aVC.detailText = "Are you sure you want to cancel your subscription?"
//            aVC.firstButtonTitle = "CONFIRM"
//            aVC.secondButtonTitle = "GO BACK"
//            aVC.firstButtonBackgroundColor = Theme.colors.deselected_tab_icon
//            aVC.modalPresentationStyle = .overFullScreen
//            aVC.delegate = self
//            self.present(aVC, animated: false, completion: nil)
//            viewVideo.pauseVideo()
            
        }
    }
    
}


extension CancelSubVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("Text :- ",textView.text!)
        lblPlaceholder.isHidden = (textView.text.trim.count != 0)
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension CancelSubVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
           
        }
//        else {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
}
