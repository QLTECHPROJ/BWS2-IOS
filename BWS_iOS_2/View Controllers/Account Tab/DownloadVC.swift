//
//  DownloadVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 20/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class DownloadVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewSegment : UIView!
    
    
    // MARK:- VARIABLES
    var selectedSegment: SJSegmentTab?
    var segmentController = SJSegmentedViewController()
    var selectedController: UIViewController?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.openPageMenuOrder()
        }
    }
    
    
    // MARK:- FUNCTIONS
    func openPageMenuOrder()  {
        let firstVC = AppStoryBoard.account.viewController(viewControllerClass: DownloadAudioVC.self)
        firstVC.title = "Audios"
        
        let secondVC = AppStoryBoard.account.viewController(viewControllerClass: DownloadPlaylistVC.self)
        secondVC.title = "Playlists"
        
        segmentController.segmentControllers = [firstVC,secondVC]
        
        segmentController.segmentTitleColor = Theme.colors.textColor
        segmentController.segmentSelectedTitleColor = Theme.colors.greenColor
        segmentController.selectedSegmentViewHeight = 3.0
        segmentController.segmentTitleFont = Theme.fonts.montserratFont(ofSize: 13, weight: .medium)
        segmentController.delegate = self
        segmentController.selectedSegmentViewColor = Theme.colors.greenColor
        segmentController.segmentViewHeight = 50
        addChild(segmentController)
        self.viewSegment.addSubview(segmentController.view)
        segmentController.view.frame = self.viewSegment.bounds
        segmentController.didMove(toParent: self)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- SJSegmentedViewControllerDelegate
extension DownloadVC: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        selectedSegment = segment
        selectedController = controller
        self.refreshData()
    }
    
    func refreshData() {
        if let controller = self.selectedController {
            if controller.isKind(of: DownloadAudioVC.self) {
                // Segment Tracking
                // SegmentTracking.shared.trackDownloadedAudiosScreenViewed()
            } else if controller.isKind(of: DownloadPlaylistVC.self) {
                // Segment Tracking
                // SegmentTracking.shared.trackDownloadedPlaylistsScreenViewed()
            }
        }
    }
    
}
