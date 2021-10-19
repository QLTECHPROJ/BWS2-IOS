//
//  StepVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class StepVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTapAnywhere : UILabel!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    
    // MARK:- VARIABLES
    var strTitle = Theme.strings.step_1_title
    var strSubTitle = Theme.strings.step_1_subtitle
    var imageMain = UIImage(named: "profileForm")
    var viewTapped : (() -> Void)?
    var color = hexStringToUIColor(hex: "2AB6C7")
    
    var hideTitle = false
    var hideSubTitle = false
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
        lblTitle.text = strTitle.uppercased()
        lblSubTitle.attributedText = strSubTitle.attributedString(alignment: .center, lineSpacing: 5)
        lblTapAnywhere.text = Theme.strings.tap_anywhere_to_continue.uppercased()
        imageView.image = imageMain
        
        lblTitle.isHidden = hideTitle
        lblSubTitle.isHidden = hideSubTitle
        lblTapAnywhere.isHidden = hideTapAnywhere
        imageView.isHidden = hideImage
        imgBackground.isHidden = isImageHide
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesturerecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK:- ACTIONS
    @objc func tapGestureAction(gesturerecognizer : UIGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
        self.viewTapped?()
    }
    
}
