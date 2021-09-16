//
//  SupportPopupVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 16/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class SupportPopupVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDetail : TTTAttributedLabel!
    @IBOutlet weak var btnClose : UIButton!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureSupportPopup()
    }
    
    
    // MARK:- Configure Support Popup
    func configureSupportPopup() {
        lblTitle.text = supportTitle
        
        let strTC = supportEmail
        let string = supportText + "\(strTC)"
        let nsString = string as NSString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        
        let fullAttributedString = NSAttributedString(string:string, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: Theme.colors.textColor.cgColor,
            NSAttributedString.Key.font: Theme.fonts.montserratFont(ofSize: 13, weight: .regular),
        ])
        
        lblDetail.textAlignment = .center
        lblDetail.attributedText = fullAttributedString
        
        let rangeTC = nsString.range(of: strTC)
        
        let ppLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: Theme.colors.green_008892,
            NSAttributedString.Key.underlineStyle.rawValue: false,
        ]
        
        lblDetail.activeLinkAttributes = [:]
        lblDetail.linkAttributes = ppLinkAttributes
        
        let urlTC = URL(string: "action://TC")!
        lblDetail.addLink(to: urlTC, with: rangeTC)
        
        lblDetail.textColor = Theme.colors.textColor
        lblDetail.numberOfLines = 0
        lblDetail.delegate = self
        
        btnClose.setTitle(Theme.strings.close, for: .normal)
    }
    
    // MARK:- ACTIONS
    @IBAction func closeClicked(sender : UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}


// MARK:- TTTAttributedLabelDelegate
extension SupportPopupVC : TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("mailto:\(supportEmail)")
        if url.absoluteString == "action://TC" {
            self.openUrl(urlString: "mailto:\(supportEmail)")
        }
    }
    
    //    func attributedLabel(_ label: TTTAttributedLabel!, didLongPressLinkWith url: URL!, at point: CGPoint) {
    //        print("link long clicked")
    //    }
    
}
