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


class CancelSubVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet var buttons : [UIButton]!
    @IBOutlet weak var txtView : UITextView!
    @IBOutlet weak var lblPlaceholder : UILabel!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var viewVideo: YTPlayerView!
    
    
    // MARK:- VARIABLES
    var selectedOption = 1
    var player: AVPlayer?
    var isFromDelete = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        let name = isFromDelete ? SegmentTracking.screenNames.delete_account : SegmentTracking.screenNames.cancel_subscription
        SegmentTracking.shared.trackGeneralScreen(name: name)
        
        // viewVideo.playVideo()
        DJMusicPlayer.shared.pause(pauseReason: .userAction)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        if isFromDelete {
            lblTitle.text = "Delete Account"
            imageView.image = UIImage(named: "delete_account_top")
            btnCancel.setTitle("DELETE ACCOUNT", for: .normal)
            viewVideo.isHidden = true
        } else {
            imageView.isHidden = true
            viewVideo.delegate = self
            // viewVideo.load(withVideoId: "y1rfRW6WX08")
            viewVideo.load(withVideoId: "y1rfRW6WX08", playerVars: ["playsinline": "1"])
        }
    }
    
    override func setupData() {
        for btn in buttons {
            if btn.tag == selectedOption {
                btn.setImage(UIImage(named: "GreenSelect"), for: .normal)
            } else {
                btn.setImage(UIImage(named: "GreenDeselect"), for: .normal)
            }
        }
        
        if selectedOption != 4 {
            txtView.text = ""
            txtView.isUserInteractionEnabled = false
            lblPlaceholder.isHidden = false
        } else {
            txtView.isUserInteractionEnabled = true
        }
        
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        if selectedOption == 4 && txtView.text.trim.count == 0 {
            btnCancel.isUserInteractionEnabled = false
            btnCancel.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnCancel.isUserInteractionEnabled = true
            btnCancel.backgroundColor = Theme.colors.green_008892
        }
    }
    
    func checkValidation() -> Bool {
        let otherReasonCount = txtView.text.trim.count
        if selectedOption == 4 && otherReasonCount == 0 {
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
        selectedOption = sender.tag
        setupData()
    }
    
    @IBAction func cancelClicked(sender : UIButton) {
        self.view.endEditing(true)
        
        if checkValidation() {
            viewVideo.pauseVideo()
            
            var titleText = Theme.strings.cancel_manage_alert_title
            var detailText = Theme.strings.cancel_manage_alert_subtitle
            
            if isFromDelete {
                titleText = Theme.strings.delete_account_alert_title
                detailText = Theme.strings.delete_account_alert_subtitle
            }
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = titleText
            aVC.detailText = detailText
            aVC.firstButtonTitle = Theme.strings.confirm
            aVC.secondButtonTitle = Theme.strings.goBack
            aVC.firstButtonBackgroundColor = Theme.colors.gray_7E7E7E
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
        }
    }
    
}


// MARK:- YTPlayerViewDelegate
extension CancelSubVC : YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        viewVideo.playVideo()
    }
    
}


// MARK:- UITextViewDelegate
extension CancelSubVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("Text :- ",textView.text!)
        lblPlaceholder.isHidden = (textView.text.trim.count != 0)
        setupData()
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension CancelSubVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if isFromDelete {
                callDeleteAccountAPI()
            } else {
                callCancelPlanAPI()
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
