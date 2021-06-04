//
//  PreparingPlaylistVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 26/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import ANActivityIndicator

class PreparingPlaylistVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    @IBOutlet weak var animationView : ANActivityIndicatorView!
    
    
    // MARK:- VARIABLES
    var isFromEdit = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.preparingPlaylist)
        
        lblTitle.attributedText = Theme.strings.preparing_playlist_title.attributedString(alignment: .center, lineSpacing: 5)
        lblSubTitle.attributedText = Theme.strings.preparing_playlist_subtitle.attributedString(alignment: .center, lineSpacing: 5)
        
        animationView.animationType = .ballSpinFadeLoader
        animationView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            
            // Segment Tracking
            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Suggested_Playlist_Created)
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ManageStartVC.self)
            aVC.strTitle = Theme.strings.you_playlist_is_ready_title
            aVC.strSubTitle = Theme.strings.you_playlist_is_ready_subtitle
            aVC.imageMain = UIImage(named: "playlistReadyWave")
            aVC.continueClicked = {
                self.goNext()
            }
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: false, completion: nil)
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func goNext() {
        if isFromEdit {
            self.navigationController?.dismiss(animated: false, completion: nil)
            NotificationCenter.default.post(name: .refreshData, object: nil)
        } else {
            APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
        }
    }
    
    
}
