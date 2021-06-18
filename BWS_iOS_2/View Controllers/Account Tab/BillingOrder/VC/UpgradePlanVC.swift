//
//  UpgradePlanVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 03/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class UpgradePlanVC: BaseViewController {
    
    //MARK:- UIOutlet
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        
        lblSubTitle.attributedText = Theme.strings.upgradePlan_subtitle.attributedString(alignment: .center, lineSpacing: 5)
        
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedUpdate(_ sender: UIButton) {
    }
    
    @IBAction func onTappedClose(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
