//
//  AddUserVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 24/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AddUserVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Functions
    override func setupUI() {
        
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedSameNumber(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: SetUpPInVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    @IBAction func onTappedDiffNumber(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ContactVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func onTappedInfo(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
        aVC.strTitle = "With Same Mobile Number"
        aVC.strDesc = Theme.strings.disclaimer_description
        aVC.isOkButtonHidden = true
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
    }
}
