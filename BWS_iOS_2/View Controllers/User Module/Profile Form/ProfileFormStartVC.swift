//
//  ProfileFormStartVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import EVReflection

class ProfileFormModel : EVObject {
    var profileType = ""
    var gender = ""
    var genderX = ""
    var age = ""
    var prevDrugUse = ""
    var Medication = ""
    
    static var shared = ProfileFormModel()
}

class ProfileFormStartVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblSubTitle : UILabel!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let normalString = "Lorem ipsum dolor sit amet, \nconsetetur sadipscing elitr, sed diam"
        lblSubTitle.attributedText = normalString.attributedString(alignment: .center, lineSpacing: 10)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesturerecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK:- FUNCTIONS
    @objc func tapGestureAction(gesturerecognizer : UIGestureRecognizer) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm1VC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
