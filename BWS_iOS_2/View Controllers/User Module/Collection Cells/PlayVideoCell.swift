//
//  PlayVideoCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblComment : UILabel!
    @IBOutlet var playerView: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        NotificationCenter.default.addObserver(forName: .pauseYouTubeVideo, object: nil, queue: nil) { (notfication) in
            self.playerView.pauseVideo()
            self.playerView.stopVideo()
        }
    }
    
    // Configure Cell
    func configureCell(data : TestminialVideoDataModel) {
        lblName.text = data.UserName
        
        let commentString = """
        \(data.VideoDesc)
        """
        lblComment.attributedText = commentString.attributedString(alignment: .left, lineSpacing: 5)
        
        let videoURLComponents = data.VideoLink.components(separatedBy: "v=")
        let videoID = videoURLComponents.count > 1 ? videoURLComponents[1] : videoURLComponents.first
        
        guard let itemID = videoID else {
            return
        }
        
        playerView.clearsContextBeforeDrawing = true
        playerView.delegate = self
        playerView.webView?.backgroundColor = .black
        playerView.webView?.isOpaque = false
        
        DispatchQueue.main.async {
            self.playerView.load(withVideoId: itemID, playerVars: ["playsinline": "1"])
        }
    }
    
}

extension PlayVideoCell: YTPlayerViewDelegate {
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.black
    }
    
    //    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
    //        let customLoadingView = UIView()
    //        Create a custom loading view
    //        return customLoadingView
    //    }
}


extension UIView {
    
    static func instantiateFromNib() -> Self? {
        return nib?.instantiate() as? Self
    }
    
}

extension UINib {
    
    func instantiate() -> Any? {
        return instantiate(withOwner: nil, options: nil).first
    }
    
}
