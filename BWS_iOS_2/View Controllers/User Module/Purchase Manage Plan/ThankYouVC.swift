//
//  ThankYouVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ThankYouVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnViewInvoice: UIButton!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.thankYou)
        
        lblSubTitle.attributedText = Theme.strings.thank_you_subtitle.attributedString(alignment: .center, lineSpacing: 5)
        
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : Theme.colors.textColor,
                                                           NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                                           NSAttributedString.Key.font : Theme.fonts.montserratFont(ofSize: 13, weight: .regular)]
        let attributedTitle = NSMutableAttributedString(string: "View Invoice", attributes: attributes)
        btnViewInvoice.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func handleCoUserRedirection() {
        if let coUser = CoUserDataModel.currentUser {
            if coUser.isProfileCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
                aVC.strTitle = Theme.strings.step_3_title
                aVC.strSubTitle = Theme.strings.step_3_subtitle
                aVC.imageMain = UIImage(named: "profileForm")
                aVC.viewTapped = {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm1VC.self)
                    self.navigationController?.pushViewController(aVC, animated: false)
                }
                aVC.modalPresentationStyle = .overFullScreen
                self.present(aVC, animated: false, completion: nil)
            } else if coUser.AvgSleepTime.trim.count == 0 || coUser.AreaOfFocus.count == 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else {
                APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func exploreAppClicked(sender: UIButton) {
        if IAPHelper.shared.isIAPEnabled {
            // IAP Verify Purchase
            IAPHelper.shared.verifySubscriptions()
        }
        self.handleCoUserRedirection()
    }
    
    @IBAction func viewInvoiceClicked(sender: UIButton) {
        print("viewInvoiceClicked")
    }
    
}
