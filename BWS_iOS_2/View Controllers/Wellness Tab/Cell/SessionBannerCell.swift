//
//  SessionBannerCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 15/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionBannerCell: UITableViewCell {
    
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var lblSessionTitle: UILabel!
    @IBOutlet weak var lblSessionDesc: UILabel!
    @IBOutlet weak var lblSession: UILabel!
    @IBOutlet weak var lblDescProgress: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var imgProgress: UIImageView!
    
    var sessionData : SessionListDataModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblSession.text = ""
        lblSessionTitle.text = ""
        lblSessionDesc.text = ""
        
        viewProgress.isHidden = true
        lblSessionDesc.numberOfLines = 3
    }
    
    // Configure Cell
    func configureCell(data : SessionListDataModel?) {
        guard let data = data else {
            return
        }
        
        self.sessionData = data
        
        lblSession.text = data.session_title
        lblDescProgress.text = data.session_progress_text
        lblProgress.text = data.session_progress
        lblSessionTitle.text = data.session_short_desc
        lblSessionDesc.text = data.session_desc
        
        lblProgress.isHidden = data.session_progress.trim.count == 0
        lblDescProgress.isHidden = data.session_progress_text.trim.count == 0
        
        if data.session_progress.trim.count == 0 && data.session_progress_text.trim.count == 0 {
            viewProgress.isHidden = true
        } else {
            viewProgress.isHidden = false
        }
        
        let hexColor = data.session_progress_color.replacingOccurrences(of: "#", with: "")
        viewProgress.backgroundColor = UIColor(hex: hexColor)
        
        if let imgUrl = URL(string: data.session_progress_img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imgProgress.sd_setImage(with: imgUrl, completed: nil)
        }
        
        if lblSessionDesc.calculateMaxLines() > 3 {
            // Add "Read More" text at trailing in UILabel
            DispatchQueue.main.async {
                self.lblSessionDesc.addTrailing(with: " ", moreText: "...Read More", moreTextFont: Theme.fonts.montserratFont(ofSize: 15, weight: .bold), moreTextColor: Theme.colors.textColor)
            }
            
            // Add Tap Gesture for checking Tap event on "Read More" text
            lblSessionDesc.isUserInteractionEnabled = true
            lblSessionDesc.lineBreakMode = .byWordWrapping
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
            tapGesture.numberOfTouchesRequired = 1
            lblSessionDesc.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = lblSessionDesc.text else { return }
        let readMoreRange = (text as NSString).range(of: "...Read More")
        if gesture.didTapAttributedTextInLabel(label: self.lblSessionDesc, inRange: readMoreRange) {
            print("Read More Tapped")
            
            if (sessionData?.session_desc ?? "").trim.count > 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
                aVC.strDesc = sessionData?.session_desc ?? ""
                aVC.strTitle = sessionData?.session_title ?? ""
                aVC.isOkButtonHidden = true
                aVC.modalPresentationStyle = .overFullScreen
                self.parentViewController?.present(aVC, animated: true, completion: nil)
            }
        }
    }
    
}
