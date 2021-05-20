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
    @IBOutlet weak var progressView : UIProgressView!
    
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
        
        progressView.isHidden = true
    }
    
    // Configure Cell
    func configureCell(data : PlaylistDetailsModel?) {
        suggstedPlaylist = data
        guard let playlistData = suggstedPlaylist else {
            return
        }
        
        lblPlaylistName.text = playlistData.PlaylistName
        
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
            btnReminder.setTitle("     Update reminder     ", for: .normal)
            btnReminder.backgroundColor = Theme.colors.gray_313131.withAlphaComponent(0.30)
        } else {
            btnReminder.setTitle("     Set reminder     ", for: .normal)
            btnReminder.backgroundColor = Theme.colors.white.withAlphaComponent(0.20)
        }
    }
    
    @IBAction func setReminderClicked(sender : UIButton) {
        setReminderClicked?()
    }
    
    @IBAction func playClicked(sender : UIButton) {
        playClicked?()
    }
    
}
