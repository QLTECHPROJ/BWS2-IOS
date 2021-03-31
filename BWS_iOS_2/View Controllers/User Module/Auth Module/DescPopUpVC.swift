//
//  DescPopUpVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class DescPopUpVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    
    
    // MARK:- VARIABLES
    var clickedOk : (() -> Void)?
    var clickedClose : (() -> Void)?
    
    var strTitle = ""
    var strDesc = ""
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = strTitle
        
        let normalString = strDesc
        lblDesc.attributedText = normalString.attributedString(alignment: .center, lineSpacing: 10)
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedOK(_ sender: UIButton) {
        self.clickedOk?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTappedClose(_ sender: UIButton) {
        self.clickedClose?()
        self.dismiss(animated: true, completion: nil)
    }
    
}
