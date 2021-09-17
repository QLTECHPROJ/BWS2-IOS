//
//  WellnessStartVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 14/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class WellnessStartVC: BaseViewController {
    
    //MARK:- UIOutlet
    
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
    @IBAction func onTappedContinue(_ sender: UIButton) {
//        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: ExpSessionVC.self)
//        self.navigationController?.pushViewController(aVC, animated: false)
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        aVC.strTitle = Theme.strings.step_3_title
        aVC.strSubTitle = Theme.strings.step_3_subtitle
        aVC.imageMain = UIImage(named: "profileForm")
        aVC.viewTapped = {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: Step2VC.self)
            EmpowerProfileForm2Model.shared.Step = "2"
            EmpowerProfileForm2Model.shared.UserId = CoUserDataModel.currentUser?.UserId ?? ""
            self.navigationController?.pushViewController(aVC, animated: false)
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
    }
    
    @IBAction func onTappedCreatePlaylist(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        aVC.strTitle = Theme.strings.step_3_title
        aVC.strSubTitle = Theme.strings.step_3_subtitle
        aVC.imageMain = UIImage(named: "profileForm")
        aVC.viewTapped = {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: Step3VC.self)
            EmpowerProfileForm3Model.shared.Step = "1"
            EmpowerProfileForm3Model.shared.UserId = CoUserDataModel.currentUser?.UserId ?? ""
            self.navigationController?.pushViewController(aVC, animated: false)
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
        
//        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
//        aVC.strTitle = Theme.strings.step_3_title
//        aVC.strSubTitle = Theme.strings.step_3_subtitle
//        aVC.imageMain = UIImage(named: "profileForm")
//        aVC.viewTapped = {
//            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: PersonalDetailVC.self)
//            EmpowerProfileFormModel.shared.Step = "1"
//            EmpowerProfileFormModel.shared.UserId = CoUserDataModel.currentUser?.UserId ?? ""
//            self.navigationController?.pushViewController(aVC, animated: false)
//        }
//        aVC.modalPresentationStyle = .overFullScreen
//        self.present(aVC, animated: false, completion: nil)
        
    }
    
}
