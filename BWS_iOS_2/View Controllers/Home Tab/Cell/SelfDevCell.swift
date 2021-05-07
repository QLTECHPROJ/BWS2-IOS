//
//  SelfDevCell.swift
//  BWS
//
//  Created by Sapu on 17/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class SelfDevCell: UITableViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var viewCard: CardView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnChangePosition: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgLeading: NSLayoutConstraint!
    
    @IBOutlet weak var downloadProgressView : KDCircularProgress!
    
    @IBOutlet weak var nowPlayingAnimationImageView: UIImageView!
    
    
    // MARK:- VARIABLES
    var buttonClicked : ((Int) -> Void)?
    var audioDetails : AudioDetailsDataModel?
    var hideDownloadProgress = true
    
    
    // MARK:- FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadProgress), name: .refreshDownloadProgress, object: nil)
        
        downloadProgressView.isHidden = true
        imgView.contentMode = .scaleAspectFill
        
        lblTitle.textColor = Theme.colors.textColor
        lblDuration.textColor = Theme.colors.greenColor
        
        nowPlayingAnimationImageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        nowPlayingAnimationImageView.startNowPlayingAnimation(false)
        nowPlayingAnimationImageView.isHidden = true
        nowPlayingAnimationImageView.image = UIImage(named: "NewNowPlayingBars")
    }
    
    // Configure Cell
    func generalConfigure(data : AudioDetailsDataModel) {
        
        if data.IsLock == "1" || data.IsLock == "2"{
            if data.IsPlay == "1" {
                imgPlay.isHidden = true
            } else {
                imgPlay.isHidden = false
                imgPlay.image = UIImage(named:"newLock")
                imgPlay.backgroundColor = .clear
                imgPlay.contentMode = .scaleToFill
                imgView.backgroundColor = .lightGray
            }
        } else {
            imgPlay.isHidden = true
        }
        
        self.audioDetails = data
        if let imgUrl = URL(string: data.ImageFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        lblTitle.text = data.Name
        lblDuration.text = data.AudioDuration
    }
    
    func generalPlaylistConfigure(data : PlaylistDetailsModel) {
        
        if data.IsLock == "1" || data.IsLock == "2" {
            imgPlay.isHidden = false
            imgPlay.image = UIImage(named:"newLock")
            imgPlay.backgroundColor = .clear
            imgPlay.contentMode = .scaleToFill
            imgView.backgroundColor = .lightGray
        } else {
            imgPlay.isHidden = true
        }
        
        if let imgUrl = URL(string: data.PlaylistImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        let totalAudios = data.TotalAudio.trim.count > 0 ? data.TotalAudio : "0"
        let totalhour = data.Totalhour.trim.count > 0 ? data.Totalhour : "0"
        let totalminute = data.Totalminute.trim.count > 0 ? data.Totalminute : "0"
        
        lblTitle.text = data.PlaylistName
        lblDuration.text = "\(totalAudios) Audios | \(totalhour)h \(totalminute)m"
    }
    
    // Audio In Playlist Cell
    func configureAudioInPlaylistCell(data : AudioDetailsDataModel) {
        self.hideDownloadProgress = true
        self.generalConfigure(data: data)
        self.configureCell(backgroundColor: .white, buttonColor: .black, hideDownload: true, hideDelete: false, hideChangePosition: false)
        
        btnChangePosition.setImage(UIImage(named: "Sorting"), for: UIControl.State.normal)
    }
    
    func configureOptionCell(data : AudioDetailsDataModel) {
        self.hideDownloadProgress = true
        self.generalConfigure(data: data)
        self.configureCell(backgroundColor: .white, buttonColor: .black, hideDownload: true, hideDelete: true, hideChangePosition: false)
        
        btnChangePosition.setImage(UIImage(named: "threeDot_Vertical_green"), for: UIControl.State.normal)
    }
    
    func configureDownloadAudioPlaylistCell(data : AudioDetailsDataModel) {
        self.hideDownloadProgress = true
        self.generalConfigure(data: data)
        self.configureCell(backgroundColor: .white, buttonColor: UIColor.black, hideDownload: true, hideDelete: true, hideChangePosition: false)
        
        lblTitle.textColor = Theme.colors.textColor
        lblDuration.textColor = Theme.colors.gray_DDDDDD
        
        btnDownload.setImage(nil, for: UIControl.State.normal)
        btnChangePosition.setImage(UIImage(named: "threeDot_Vertical_green"), for: UIControl.State.normal)
    }
    
    // Add Audio Cell
    func configureAddAudioCell(data : AudioDetailsDataModel) {
        self.hideDownloadProgress = true
        self.generalConfigure(data: data)
        self.configureCell(backgroundColor: .white, buttonColor: UIColor.black, hideDownload: true, hideDelete: true, hideChangePosition: false)
        
        btnChangePosition.setImage(UIImage(named: "Add"), for: UIControl.State.normal)
    }
    
    // Add Playlist Cell
    func configureAddPlaylistCell(data : PlaylistDetailsModel) {
        self.hideDownloadProgress = true
        self.generalPlaylistConfigure(data: data)
        self.configureCell(backgroundColor: .white, buttonColor: UIColor.black, hideDownload: true, hideDelete: true, hideChangePosition: false)
        
        btnChangePosition.setImage(UIImage(named: "Add"), for: UIControl.State.normal)
    }
    
    func configureRemoveAudioCell(data : AudioDetailsDataModel) {
        self.hideDownloadProgress = false
        self.generalConfigure(data: data)
        self.configureCell()
        btnDownload.setImage(nil, for: UIControl.State.normal)
    }
    
    func configureRemovePlaylistCell(data : PlaylistDetailsModel) {
        self.hideDownloadProgress = false
        self.configureCell()
        
        let playlistDownloadProgress = CoreDataHelper.shared.updatePlaylistDownloadProgress(playlistID: data.PlaylistID)
        
        if  playlistDownloadProgress < 1 {
            downloadProgressView.isHidden = false
            self.downloadProgressView.progress = playlistDownloadProgress
        }
        else {
            downloadProgressView.isHidden = true
        }
        
        if checkInternet() == false {
            downloadProgressView.isHidden = true
        }
        
        btnDownload.setImage(nil, for: UIControl.State.normal)
        
        if data.IsLock == "1" || data.IsLock == "2" {
            imgPlay.isHidden = false
            imgPlay.image = UIImage(named:"newLock")
            imgPlay.backgroundColor = .clear
            imgPlay.contentMode = .scaleToFill
            imgView.backgroundColor = .lightGray
        }
        else {
            imgPlay.isHidden = true
        }
        
        if let imgUrl = URL(string: data.PlaylistImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        lblTitle.text = data.PlaylistName
        lblDuration.text = "\(data.TotalAudio) Audios | \(data.Totalhour)h \(data.Totalminute)m"
    }
    
    // MARK:- UI Related Configurations
    func configureCell(backgroundColor: UIColor = UIColor.white ,buttonColor : UIColor = UIColor.black, hideDownload : Bool = true, hideDelete : Bool = false, hideChangePosition : Bool = true) {
        self.backgroundColor = backgroundColor
        
        lblTitle.textColor = Theme.colors.textColor
        lblDuration.textColor = Theme.colors.greenColor
        
        btnDownload.tintColor = buttonColor
        btnDelete.tintColor = buttonColor
        btnChangePosition.tintColor = buttonColor
        
        btnDownload.alpha = hideDownload ? 0 : 1
        btnDelete.isHidden = hideDelete
        btnChangePosition.isHidden = hideChangePosition
        
        // Download Progress View
        downloadProgressView.isHidden = true
        downloadProgressView.startAngle = -90
        downloadProgressView.progressThickness = 1
        downloadProgressView.trackThickness = 1
        downloadProgressView.clockwise = true
        downloadProgressView.gradientRotateSpeed = 2
        downloadProgressView.roundedCorners = false
        downloadProgressView.glowMode = .forward
        downloadProgressView.glowAmount = 0
        downloadProgressView.set(colors: Theme.colors.greenColor)
        downloadProgressView.trackColor = Theme.colors.gray_DDDDDD
        downloadProgressView.backgroundColor = UIColor.clear
    }
    
    // MARK:- Handle Download Progress
    @objc func refreshDownloadData() {
        updateDownloadProgress()
    }
    
    @objc func updateDownloadProgress() {
        if checkInternet() == false {
            return
        }
        
        if hideDownloadProgress {
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
        }
        else if isInDatabase && isDownloading {
            btnDownload.alpha = 0
            btnDownload.isUserInteractionEnabled = false
            downloadProgressView.isHidden = false
            downloadProgressView.progress = DJDownloadManager.shared.downloadProgress
        }
        else if isInDatabase && isDownloading == false {
            btnDownload.alpha = 0
            btnDownload.isUserInteractionEnabled = false
            downloadProgressView.isHidden = false
            downloadProgressView.progress = 0
        }
        else {
            downloadProgressView.isHidden = true
            btnDownload.isUserInteractionEnabled = true
            btnDownload.alpha = 1
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func clickActions(sender : UIButton) {
        self.buttonClicked?(sender.tag)
    }
    
}
