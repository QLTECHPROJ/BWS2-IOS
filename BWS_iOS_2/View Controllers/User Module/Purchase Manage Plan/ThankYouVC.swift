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
    
    @IBOutlet weak var lblTop: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnViewInvoice: UIButton!
    @IBOutlet weak var imgThankYou: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var btnAddUser: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK:- VARIABLE
    var isCome:String?
    
    
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
        
        setupData()
    }
    
    func handleCoUserRedirection() {
        if let coUser = CoUserDataModel.currentUser {
            if coUser.isAssessmentCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DoDassAssessmentVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }else if coUser.isProfileCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
                aVC.strTitle = Theme.strings.step_3_title
                aVC.strSubTitle = Theme.strings.step_3_subtitle
                aVC.imageMain = UIImage(named: "profileForm")
                aVC.viewTapped = {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm2VC.self)
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
    
    override func setupData() {
        if isCome == "UserDetail"{
            if let coUser = CoUserDataModel.currentUser {
            scrollview.isScrollEnabled = false
            imgThankYou.image = UIImage(named: "Congrats")
            lblTitle.font = UIFont(name: Theme.fonts.MontserratBold, size: 45.0)
                let strText = "Congrats!\n" + coUser.Name
            addAttribut(strText: strText, strSubString: coUser.Name, label: lblTitle, size: 24)
            lblSubTitle.text = "You already have access to 6 month of Enhance program." 
            btnAddUser.isHidden = true
            btnViewInvoice.isHidden = true
            imgWidth.constant = 309
            imgHeight.constant = 281
            lblTop.constant = 40
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedAddUser(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: AddUserVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func exploreAppClicked(sender: UIButton) {
        if IAPHelper.shared.isIAPEnabled {
            // IAP Verify Purchase
            IAPHelper.shared.verifySubscriptions()
        }
        self.callGetCoUserDetailsAPI { (success) in
            if success {
                self.handleCoUserRedirection()
            } 
        }
      
    }
    
    @IBAction func viewInvoiceClicked(sender: UIButton) {
        print("viewInvoiceClicked")
    }
    
}
