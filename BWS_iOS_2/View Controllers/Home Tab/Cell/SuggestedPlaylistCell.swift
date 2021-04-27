//
//  SuggestedPlaylistCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 27/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SuggestedPlaylistCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var btnReminder : UIButton!
    @IBOutlet weak var btnPlay : UIButton!
    @IBOutlet weak var progressView : UIProgressView!
    
    @IBOutlet weak var lblPlaylistName : UILabel!
    @IBOutlet weak var lblPlaylistDirection : UILabel!
    @IBOutlet weak var lblPlaylistDuration : UILabel!
    
    @IBOutlet weak var lblSleepTime : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : PlaylistDetailsModel?) {
        guard let objPlaylist = data else {
            return
        }
        
        lblPlaylistName.text = objPlaylist.PlaylistName
        
        let totalhour = objPlaylist.Totalhour.trim.count > 0 ? objPlaylist.Totalhour : "0"
        let totalminute = objPlaylist.Totalminute.trim.count > 0 ? objPlaylist.Totalminute : "0"
        lblPlaylistDuration.text = "\(totalhour):\(totalminute)"
        
        if let avgSleepTime = CoUserDataModel.currentUser?.AvgSleepTime, avgSleepTime.trim.count > 0 {
            lblSleepTime.text = "Your average sleep time is \(avgSleepTime)"
        }
        
        if objPlaylist.IsReminder == "1" {
            btnReminder.setTitle("     Turn off reminder     ", for: .normal)
        } else {
            btnReminder.setTitle("     Set reminder     ", for: .normal)
        }
    }
    
    @IBAction func setReminderClicked(sender : UIButton) {
        // Set Reminder
    }
    
    @IBAction func playClicked(sender : UIButton) {
        // Play Playlist
    }
    
}
