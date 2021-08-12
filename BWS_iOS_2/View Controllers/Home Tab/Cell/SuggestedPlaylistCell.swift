//
//  SuggestedPlaylistCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 27/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SuggestedPlaylistCell: UITableViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var btnReminder : UIButton!
    @IBOutlet weak var btnPlay : UIButton!
    
    @IBOutlet weak var imgLock : UIImageView!
    
    @IBOutlet weak var lblPlaylistName : UILabel!
    @IBOutlet weak var lblPlaylistDirection : UILabel!
    @IBOutlet weak var lblPlaylistDuration : UILabel!
    
    @IBOutlet weak var lblSleepTime : UILabel!
    
    
    // MARK:- VARIABLES
    var suggstedPlaylist : PlaylistDetailsModel?
    var setReminderClicked : ( () -> Void )?
    var playClicked : ( () -> Void )?
    
    
    // MARK:- FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    // Configure Cell
    func configureCell(data : PlaylistDetailsModel?) {
        suggstedPlaylist = data
        guard let playlistData = suggstedPlaylist else {
            return
        }
        
        imgLock.isHidden = !(lockDownloads == "1" || lockDownloads == "2")
        
        lblPlaylistName.text = playlistData.PlaylistName
        lblPlaylistDirection.text = playlistData.playlistDirection
        let totalhour = playlistData.Totalhour.trim.count > 0 ? playlistData.Totalhour : "0"
        let totalminute = playlistData.Totalminute.trim.count > 0 ? playlistData.Totalminute : "0"
        lblPlaylistDuration.text = "\(totalhour):\(totalminute)"
        
        if let avgSleepTime = CoUserDataModel.currentUser?.AvgSleepTime, avgSleepTime.trim.count > 0 {
            lblSleepTime.text = "Your average sleep time is \(avgSleepTime)"
        }
        
        let isPlaylistPlaying = isPlayingPlaylist(playlistID: playlistData.PlaylistID)
        
        if isPlaylistPlaying && DJMusicPlayer.shared.isPlaying {
            btnPlay.setImage(UIImage(named: "pause_white"), for: UIControl.State.normal)
        } else {
            btnPlay.setImage(UIImage(named: "play_white"), for: UIControl.State.normal)
        }
        
        if DJMusicPlayer.shared.state == .loading && DJMusicPlayer.shared.isPlaying {
            if checkInternet() {
                btnPlay.setImage(UIImage(named: "pause_white"), for: UIControl.State.normal)
            } else {
                btnPlay.setImage(UIImage(named: "play_white"), for: UIControl.State.normal)
            }
        }
        
        if playlistData.PlaylistSongs.count > 0 {
            btnPlay.isHidden = false
        } else {
            btnPlay.isHidden = true
        }
        
        if playlistData.IsReminder == "1" {
            btnReminder.setTitle(Theme.strings.update_reminder, for: .normal)
            btnReminder.backgroundColor = Theme.colors.gray_313131.withAlphaComponent(0.30)
        } else if playlistData.IsReminder == "2" {
            btnReminder.setTitle(Theme.strings.update_reminder, for: .normal)
            btnReminder.backgroundColor = Theme.colors.white.withAlphaComponent(0.20)
        } else {
            btnReminder.setTitle(Theme.strings.set_reminder, for: .normal)
            btnReminder.backgroundColor = Theme.colors.white.withAlphaComponent(0.20)
        }
    }
    
    @IBAction func setReminderClicked(sender : UIButton) {
        setReminderClicked?()
    }
    
    @IBAction func playClicked(sender : UIButton) {
        playClicked?()
    }
    
    @IBAction func onTappedSleepTime(_ sender: UIButton) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
        aVC.titleText = Theme.strings.sleeptime_alert_title
        aVC.detailText = Theme.strings.sleeptime_alert_Desc
        aVC.firstButtonTitle = Theme.strings.yes
        aVC.secondButtonTitle = Theme.strings.no
        aVC.firstButtonBackgroundColor = Theme.colors.gray_7E7E7E
        aVC.modalPresentationStyle = .overFullScreen
        aVC.delegate = self
        self.parentViewController?.present(aVC, animated: true, completion: nil)
    }
    
}

// MARK:- AlertPopUpVCDelegate
extension SuggestedPlaylistCell : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
            self.parentViewController?.navigationController?.pushViewController(aVC, animated: true)
        } else {
            self.parentViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
}
