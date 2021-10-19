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
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCreatePlaylist: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCreateplaylist: UIView!
    
    //MARK:- Variables
    var isButtonHide = true
    var strTitle = "Unconscious Brain vs Conscious brain"
    var strSubTitle = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut"
    var imageMain = UIImage(named: "Wellness")
    var color = hexStringToUIColor(hex: "2AB6C7")
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        
        lblTitle.text = strTitle.uppercased()
        lblSubTitle.attributedText = strSubTitle.attributedString(alignment: .center, lineSpacing: 5)
       
        img.image = imageMain
        viewCreateplaylist.isHidden = isButtonHide
        
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedContinue(_ sender: UIButton) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)

    }
    
    @IBAction func onTappedCreatePlaylist(_ sender: UIButton) {
        //Step - 2
        //        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        //        aVC.strTitle = Theme.strings.step_3_title
        //        aVC.strSubTitle = Theme.strings.step_3_subtitle
        //        aVC.imageMain = UIImage(named: "profileForm")
        //        aVC.viewTapped = {
        //            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: Step2VC.self)
        //            EmpowerProfileForm2Model.shared.Step = "2"
        //            EmpowerProfileForm2Model.shared.UserId = CoUserDataModel.currentUser?.UserId ?? ""
        //            self.navigationController?.pushViewController(aVC, animated: false)
        //        }
        //        aVC.modalPresentationStyle = .overFullScreen
        //        self.present(aVC, animated: false, completion: nil)
        //Step - 3
//        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
//        aVC.strTitle = Theme.strings.step_3_title
//        aVC.strSubTitle = Theme.strings.step_3_subtitle
//        aVC.imageMain = UIImage(named: "profileForm")
//        aVC.viewTapped = {
//            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: Step3VC.self)
//            EmpowerProfileForm3Model.shared.Step = "3"
//            EmpowerProfileForm3Model.shared.UserId = CoUserDataModel.currentUser?.UserId ?? ""
//            self.navigationController?.pushViewController(aVC, animated: false)
//        }
//        aVC.modalPresentationStyle = .overFullScreen
//        self.present(aVC, animated: false, completion: nil)
//        
//        //Step - 1
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
