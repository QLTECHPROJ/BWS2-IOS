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
    
    
    // MARK:- VARIABLES
    var strTitle = Theme.strings.step_1_title
    var strSubTitle = Theme.strings.step_1_subtitle
    var imageMain = UIImage(named: "profileForm")
    var viewTapped : (() -> Void)?
    
    var hideTitle = false
    var hideSubTitle = false
    var hideImage = false
    var hideTapAnywhere = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func setupUI() {
        lblTitle.text = strTitle.uppercased()
        lblSubTitle.attributedText = strSubTitle.attributedString(alignment: .center, lineSpacing: 5)
        lblTapAnywhere.text = Theme.strings.tap_anywhere_to_continue.uppercased()
        imageView.image = imageMain
        
        lblTitle.isHidden = hideTitle
        lblSubTitle.isHidden = hideSubTitle
        lblTapAnywhere.isHidden = hideTapAnywhere
        imageView.isHidden = hideImage
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesturerecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK:- ACTIONS
    @objc func tapGestureAction(gesturerecognizer : UIGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
        self.viewTapped?()
    }
    
}
