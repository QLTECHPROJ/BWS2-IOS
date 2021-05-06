//
//  AudioDetailVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 31/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}


class AudioDetailVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblDirectionsTitle : UILabel!
    @IBOutlet weak var lblDirections : UILabel!
    @IBOutlet weak var lblDescriptionTitle : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var lblDuration : UILabel!
    @IBOutlet weak var lblAudioName : UILabel!
    @IBOutlet weak var lblSubCategory : UILabel!
    
    @IBOutlet weak var imgView : UIImageView!
    
    @IBOutlet weak var objCollection : UICollectionView!
    @IBOutlet weak var collectionTopConst : NSLayoutConstraint!
    @IBOutlet weak var collectionHeightConst : NSLayoutConstraint!
    
    @IBOutlet weak var stackViewDescription : UIStackView!
    @IBOutlet weak var stackViewDirection : UIStackView!
    
    @IBOutlet weak var btnAddToPlaylist : UIButton!
    @IBOutlet weak var btnRemoveFromPlaylist : UIButton!
    @IBOutlet weak var btnDownload : UIButton!
    
    
    // MARK:- VARIABLES
    var audioDetails : AudioDetailsDataModel?
    var isComeFrom = "Audio"
    var selfCreated = true
    var arrayCategory = [String]()
    var source = ""
    
    var didClosePlayerDetail : (() -> Void)?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        objCollection.register(nibWithCellClass: AudioCategoryCell.self)
        setupData()
        
        callAudioDetailsAPI()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
    }
    
    override func setupData() {
        guard let details = audioDetails else {
            return
        }
        
        lblDirections.text = details.AudioDirection
        lblDescription.text = details.AudioDescription
        lblDuration.text = details.AudioDuration
        lblAudioName.text = details.Name
        lblSubCategory.text = details.Audiomastercat
        
        lblDescription.textColor = UIColor.white
        
        if lblDescription.calculateMaxLines() > 4 {
            // Add "Read More" text at trailing in UILabel
            DispatchQueue.main.async {
                self.lblDescription.addTrailing(with: " ", moreText: "Read More...", moreTextFont: UIFont.systemFont(ofSize: 13), moreTextColor: .orange)
            }
            
            // Add Tap Gesture for checking Tap event on "Read More" text
            lblDescription.isUserInteractionEnabled = true
            lblDescription.lineBreakMode = .byWordWrapping
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
            tapGesture.numberOfTouchesRequired = 1
            lblDescription.addGestureRecognizer(tapGesture)
        }
        
        stackViewDescription.isHidden = details.AudioDescription.trim.count == 0
        stackViewDirection.isHidden = details.AudioDirection.trim.count == 0
        
        arrayCategory = details.AudioSubCategory.components(separatedBy: ",").filter { $0.trim.count > 0 }
        
        objCollection.reloadData()
        collectionTopConst.constant = arrayCategory.count > 0 ? 16 : 0
        collectionHeightConst.constant = arrayCategory.count > 0 ? 50 : 0
        objCollection.isHidden = arrayCategory.count == 0
        self.view.layoutIfNeeded()
        
        if details.PlaylistID != "" && details.selfCreated != "" {
            btnRemoveFromPlaylist.isHidden = false
        } else {
            btnRemoveFromPlaylist.isHidden = true
        }
        
        if let imgUrl = URL(string: details.ImageFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        // For Download
        if CoreDataHelper.shared.checkAudioInDatabase(audioData: details) {
            btnDownload.isUserInteractionEnabled = false
            btnDownload.setImage(UIImage(named: "download_orange"), for: UIControl.State.normal)
            btnDownload.setTitleColor(Theme.colors.orange_F89552, for: UIControl.State.normal)
        } else {
            btnDownload.isUserInteractionEnabled = true
            btnDownload.setImage(UIImage(named: "download_white"), for: UIControl.State.normal)
            btnDownload.setTitleColor(Theme.colors.white, for: UIControl.State.normal)
        }
    }
    
    @objc override func refreshDownloadData() {
        self.setupData()
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = lblDescription.text else { return }
        let readMoreRange = (text as NSString).range(of: "Read More...")
        if gesture.didTapAttributedTextInLabel(label: self.lblDescription, inRange: readMoreRange) {
            print("Read More Tapped")
            
            if (self.audioDetails?.AudioDescription.trim.count ?? 0) > 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
                aVC.strDesc = self.audioDetails!.AudioDescription
                aVC.strTitle = "Description"
                aVC.isOkButtonHidden = true
                aVC.modalPresentationStyle = .overFullScreen
                self.present(aVC, animated: false, completion: nil)
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func closeClicked(sender : UIButton) {
        self.dismiss(animated: true) {
            self.didClosePlayerDetail?()
        }
    }
    
    @IBAction func addToPlaylistClicked(sender : UIButton) {
        if let audioID = self.audioDetails?.ID {
            // Segment Tracking
            // SegmentTracking.shared.audioDetailsEvents(name: "Add to Playlist Clicked", audioData: self.audioDetails, source: "Audio Details", trackingType: .track)
            
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
            aVC.audioID = audioID
            aVC.source = "Audio Details Screen"
            let navVC = UINavigationController(rootViewController: aVC)
            navVC.navigationBar.isHidden = true
            navVC.modalPresentationStyle = .overFullScreen
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func removeFromPlaylistClicked(sender : UIButton) {
        if let playlistID = audioDetails?.PlaylistID {
            if isPlayingPlaylist(playlistID: playlistID) {
                if DJMusicPlayer.shared.nowPlayingList.count > 1 {
                    callRemoveAudioFromPlaylistAPI()
                } else {
                    showAlertToast(message: Theme.strings.alert_disclaimer_playlist_remove)
                }
            } else {
                callRemoveAudioFromPlaylistAPI()
            }
        }
    }
    
    @IBAction func downloadClicked(sender : UIButton) {
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            return
        }
        
        if lockDownloads == "1" {
            openInactivePopup(controller: self)
            return
        } else if lockDownloads == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
            return
        }
        
        if let details = self.audioDetails {
            details.isSingleAudio = "1"
            CoreDataHelper.shared.saveAudio(audioData: details)
            
            // Segment Tracking
            // SegmentTracking.shared.audioDetailsEvents(name: "Audio Download Started", audioData: self.audioDetails, source: "Audio Details", trackingType: .track)
        }
    }
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AudioDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AudioCategoryCell.self, for: indexPath)
        cell.lblTitle.text = arrayCategory[indexPath.row]
        return cell
    }
    
}
