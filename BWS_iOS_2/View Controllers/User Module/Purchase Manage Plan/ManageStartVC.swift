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
    var strTitle = Theme.strings.you_are_doing_good_title
    var strSubTitle = Theme.strings.you_are_doing_good_subtitle
    var imageMain = UIImage(named: "manageStartWave")
    var imageUrl = ""
    var continueClicked : (() -> Void)?
    var isForIntroContent = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupData()
        
        if isForIntroContent {
            callIntroSessionContentAPI()
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        lblTitle.text = strTitle
        lblSubTitle.attributedText = strSubTitle.attributedString(alignment: .center, lineSpacing: 5)
        imageView.image = self.imageMain
        
        if imageUrl.trim.count > 0 {
            if let imgUrl = URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                imageView.sd_setImage(with: imgUrl, completed: nil)
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func continueClicked(sender : UIButton) {
        self.dismiss(animated: false, completion: nil)
        self.continueClicked?()
    }
    
}
