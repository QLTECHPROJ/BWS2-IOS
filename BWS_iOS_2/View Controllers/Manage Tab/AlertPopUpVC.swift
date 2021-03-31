//
//  AlertPopUpVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 31/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

protocol AlertPopUpVCDelegate {
    func handleAction(sender : UIButton, popUpTag : Int )
}

class AlertPopUpVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDetail : UILabel!
    
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var btnClose : UIButton!
    
    // MARK:- VARIABLES
    var titleText = "Delete playlist"
    var detailText = "Are you sure you want to delete Self-development playlist?"
    var firstButtonTitle = "DELETE"
    var secondButtonTitle = "CLOSE"
    var firstButtonBackgroundColor = Theme.colors.greenColor
    var secondButtonBackgroundColor = UIColor.clear
    
    var hideFirstButton = false
    var hideSecondButton = false
    
    var popUpTag = 0
    
    // 0 : Delete, 1 : Close
    var delegate : AlertPopUpVCDelegate?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        lblTitle.text = titleText
        lblDetail.text = detailText
        
        btnDelete.isHidden = firstButtonTitle.count == 0
        btnClose.isHidden = secondButtonTitle.count == 0
        
        btnDelete.setTitle(firstButtonTitle, for: UIControl.State.normal)
        btnDelete.backgroundColor = firstButtonBackgroundColor
        
        btnClose.setTitle(secondButtonTitle, for: UIControl.State.normal)
        btnClose.backgroundColor = secondButtonBackgroundColor
        
        btnDelete.isHidden = hideFirstButton
        btnClose.isHidden = hideSecondButton
    }
    
    
    // MARK:- ACTIONS
    @IBAction func buttonClicked(sender : UIButton) {
        self.dismiss(animated: false) {
            self.delegate?.handleAction(sender: sender, popUpTag: self.popUpTag)
        }
    }
    
}

