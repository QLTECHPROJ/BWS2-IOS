//
//  PlaylistDetailVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 02/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

protocol PlaylistOptionsVCDelegate {
    func didClickedRename()
    func didClickedDelete()
    func didClickedFind()
    func didClickedAddToPlaylist()
}

class PlaylistDetailVC: BaseViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblPlaylistName : UILabel!
    @IBOutlet weak var lblCategory : UILabel!
    @IBOutlet weak var lblAudioCount : UILabel!
    
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var stackViewDescription : UIStackView!
    
    @IBOutlet weak var objCollection : UICollectionView!
    @IBOutlet weak var collectionTopConst : NSLayoutConstraint!
    @IBOutlet weak var collectionHeightConst : NSLayoutConstraint!
    
    @IBOutlet weak var btnRename : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var btnFind : UIButton!
    @IBOutlet weak var btnDownload : UIButton!
    @IBOutlet weak var btnAddToPlaylist : UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    
    // MARK:- VARIABLES
    var objPlaylist : PlaylistDetailsModel?
    var delegate : PlaylistOptionsVCDelegate?
    var showFindButton = true
    var arrayCategory = [String]()
    var sectionName = ""
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        objCollection.register(nibWithCellClass: AudioCategoryCell.self)
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        self.objPlaylist?.sectionName = self.sectionName
    }
    
    // MARK:- FUNCTIONS
    override func setupData() {
        if let details = objPlaylist {
            if let imgUrl = URL(string: details.PlaylistImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                imgView.sd_setImage(with: imgUrl, completed: nil)
            }
            
            lblPlaylistName.text = details.PlaylistName
            
            if details.PlaylistMastercat.trim.count > 0 {
                lblCategory.text = details.PlaylistMastercat
                lblCategory.isHidden = false
            }
            else {
                lblCategory.isHidden = true
            }
            
            let totalAudios = details.TotalAudio.trim.count > 0 ? details.TotalAudio : "0"
            let totalhour = details.Totalhour.trim.count > 0 ? details.Totalhour : "0"
            let totalminute = details.Totalminute.trim.count > 0 ? details.Totalminute : "0"
            lblAudioCount.text = "\(totalAudios) Audios | \(totalhour)h \(totalminute)m"
            
            if objPlaylist!.Created == "1" {
                btnRename.isHidden = false
                btnDelete.isHidden = false
                btnFind.isHidden = true
                stackViewDescription.isHidden = true
                objCollection.isHidden = true
                
                collectionTopConst.constant = 0
                collectionHeightConst.constant = 0
                self.view.layoutIfNeeded()
            }
            else {
                btnRename.isHidden = true
                btnDelete.isHidden = true
                btnFind.isHidden = false
                stackViewDescription.isHidden = false
                
                if showFindButton == false {
                    btnFind.isHidden = true
                }
                
                lblDescription.text = details.PlaylistDesc
                stackViewDescription.isHidden = details.PlaylistDesc.trim.count == 0
                
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
                
                arrayCategory = details.PlaylistSubcat.components(separatedBy: ",").filter { $0.trim.count > 0 }
                objCollection.reloadData()
                collectionTopConst.constant = arrayCategory.count > 0 ? 30 : 0
                collectionHeightConst.constant = arrayCategory.count > 0 ? 50 : 0
                objCollection.isHidden = arrayCategory.count == 0
                self.view.layoutIfNeeded()
            }
            
            if let songs = objPlaylist?.PlaylistSongs, songs.count > 0 {
                btnDownload.isHidden = false
            }
            else {
                btnDownload.isHidden = true
            }
            
            if details.Like == "1" {
                btnLike.setImage(UIImage(named: "Like"), for: UIControl.State.normal)
                btnLike.tintColor = UIColor.clear
            }
            else {
                btnLike.setImage(UIImage(named: "LikeWhite"), for: UIControl.State.normal)
                btnLike.tintColor = UIColor.white
            }
        }
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = lblDescription.text else { return }
        let readMoreRange = (text as NSString).range(of: "Read More...")
        if gesture.didTapAttributedTextInLabel(label: self.lblDescription, inRange: readMoreRange) {
            print("Read More Tapped")
            
            if (self.objPlaylist?.PlaylistDesc.trim.count ?? 0) > 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
                aVC.strDesc = self.objPlaylist!.PlaylistDesc
                aVC.strTitle = "Description"
                aVC.isOkButtonHidden = true
                aVC.modalPresentationStyle = .overFullScreen
                self.present(aVC, animated: false, completion: nil)
            }
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func likePlaylist(_ sender: UIButton) {
        // Playlist Like API Call
    }
    
    @IBAction func closeClicked(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func renameClicked(sender : UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didClickedRename()
        }
    }
    
    @IBAction func deleteClicked(sender : UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didClickedDelete()
        }
    }
    
    @IBAction func findClicked(sender : UIButton) {
        // Segment Tracking
        // SegmentTracking.shared.playlistEvents(name: "Playlist Search Clicked", objPlaylist: objPlaylist, trackingType: .track)
        
        self.dismiss(animated: true) {
            self.delegate?.didClickedFind()
        }
    }
    
    @IBAction func downloadClicked(sender : UIButton) {
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            return
        }
        
        // Handle Playist Download
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToPlaylistClicked(sender : UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didClickedAddToPlaylist()
        }
    }

}

extension PlaylistDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AudioCategoryCell.self, for: indexPath)
        cell.lblTitle.text = arrayCategory[indexPath.row]
        return cell
    }
    
}
