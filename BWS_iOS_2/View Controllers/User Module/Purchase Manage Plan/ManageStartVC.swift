//
//  ManageStartVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 16/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ManageStartVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    @IBOutlet weak var imageView : UIImageView!
    
    
    // MARK:- VARIABLES
    var strTitle = "You are Doing Good"
    var strSubTitle = "We are analysing the information you provided and in the process of devising a personalised treatment plan for you."
    var imageMain = UIImage(named: "manageStartWave")
    var continueClicked : (() -> Void)?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblTitle.text = strTitle
        lblSubTitle.attributedText = strSubTitle.attributedString(alignment: .center, lineSpacing: 10)
        imageView.image = self.imageMain
    }
    
    
    // MARK:- ACTIONS
    @IBAction func continueClicked(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.continueClicked?()
    }
    
}
