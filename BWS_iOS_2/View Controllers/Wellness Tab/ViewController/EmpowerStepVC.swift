//
//  EmpowerStepVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class EmpowerStepVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblSectionTitle : UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTapAnywhere : UILabel!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    
    // MARK:- VARIABLES
    var strSectionTitle = Theme.strings.step_1_title
    var strSubTitle = Theme.strings.step_1_title
    var strDescription = Theme.strings.step_1_subtitle
    var imageMain = UIImage(named: "profileForm")
    var imageUrl = ""
    var viewTapped : (() -> Void)?
    var color = hexStringToUIColor(hex: "2AB6C7")
    
    var hideSectionTitle = false
    var hideSubTitle = false
    var hideDescription = false
    var hideImage = false
    var hideTapAnywhere = false
    var isImageHide = true
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func setupUI() {
        MainView.backgroundColor = color
        lblSectionTitle.text = strSectionTitle.uppercased()
        lblSubTitle.text = strSubTitle
        lblDescription.attributedText = strDescription.attributedString(alignment: .center, lineSpacing: 5)
        lblTapAnywhere.text = Theme.strings.tap_anywhere_to_continue.uppercased()
        imageView.image = imageMain
        
        if let strUrl = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imageView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        if lblDescription.calculateMaxLines() > 2 {
            // Add "Read More" text at trailing in UILabel
            DispatchQueue.main.async {
                self.lblDescription.addTrailing(with: " ", moreText: "...Read More", moreTextFont: Theme.fonts.montserratFont(ofSize: 14, weight: .bold), moreTextColor: .white)
            }
            
            // Add Tap Gesture for checking Tap event on "Read More" text
            lblDescription.isUserInteractionEnabled = true
            lblDescription.lineBreakMode = .byWordWrapping
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
            tapGesture.numberOfTouchesRequired = 1
            lblDescription.addGestureRecognizer(tapGesture)
        }
        
        lblSectionTitle.isHidden = hideSectionTitle
        lblSubTitle.isHidden = hideSubTitle
        lblDescription.isHidden = hideDescription
        lblTapAnywhere.isHidden = hideTapAnywhere
        imageView.isHidden = hideImage
        imgBackground.isHidden = isImageHide
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesturerecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = lblDescription.text else { return }
        let readMoreRange = (text as NSString).range(of: "...Read More")
        if gesture.didTapAttributedTextInLabel(label: self.lblDescription, inRange: readMoreRange) {
            print("Read More Tapped")
            
            if strDescription.trim.count > 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
                aVC.strDesc = strDescription
                aVC.strTitle = strSubTitle
                aVC.isOkButtonHidden = true
                aVC.modalPresentationStyle = .overFullScreen
                self.present(aVC, animated: false, completion: nil)
            }
        }
    }
    
    // MARK:- ACTIONS
    @objc func tapGestureAction(gesturerecognizer : UIGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
        self.viewTapped?()
    }
    
}
