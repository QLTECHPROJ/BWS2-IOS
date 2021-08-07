//
//  DescriptionPopupVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class DescriptionPopupVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    
    
    // MARK:- VARIABLES
    var clickedOk : (() -> Void)?
    var clickedClose : (() -> Void)?
    
    var titleColor = Theme.colors.textColor
    
    var titleFont = Theme.fonts.montserratFont(ofSize: 18, weight: .bold)
    var descFont = Theme.fonts.montserratFont(ofSize: 15, weight: .regular)
    
    var strTitle = ""
    var strDesc = ""
    
    var isOkButtonHidden = true
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.numberOfLines = 2
        //lblTitle.text = strTitle
        lblTitle.isHidden = ( strTitle.trim.count == 0 )
        lblTitle.attributedText = strTitle.attributedString(alignment: .center, lineSpacing: 2)
        lblDesc.attributedText = strDesc.attributedString(alignment: .left, lineSpacing: 2)
        
        btnOK.isHidden = isOkButtonHidden
        btnClose.isHidden = !isOkButtonHidden
        
        lblTitle.font = titleFont
        lblDesc.font = descFont
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedOK(_ sender: UIButton) {
        self.clickedOk?()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onTappedClose(_ sender: UIButton) {
        self.clickedClose?()
        self.dismiss(animated: false, completion: nil)
    }
    
}
