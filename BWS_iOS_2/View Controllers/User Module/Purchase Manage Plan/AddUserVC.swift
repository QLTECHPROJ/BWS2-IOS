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
        self.callGetCoUserDetailsAPI { (success) in
            if success {
                if let userData = CoUserDataModel.currentUser {
                    if userData.isPinSet == "0" {
                        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
                        aVC.strTitle = ""
                        aVC.strSubTitle = "Proceed with adding New User"
                        aVC.imageMain = UIImage(named: "NewUser")
                        aVC.viewTapped = {
                            let aVC = AppStoryBoard.main.viewController(viewControllerClass: SetUpPInVC.self)
                            aVC.selectedUser = userData
                            self.navigationController?.pushViewController(aVC, animated: true)
                        }
                        aVC.modalPresentationStyle = .overFullScreen
                        self.present(aVC, animated: false, completion: nil)
                       
                    }else {
                        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
                        aVC.strTitle = ""
                        aVC.strSubTitle = "Proceed with adding New User"
                        aVC.imageMain = UIImage(named: "NewUser")
                        aVC.viewTapped = {
                            let aVC = AppStoryBoard.main.viewController(viewControllerClass: UserDetailVC.self)
                            self.navigationController?.pushViewController(aVC, animated: true)
                        }
                        aVC.modalPresentationStyle = .overFullScreen
                        self.present(aVC, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    
    //MARK:- IBAction Methods
    @IBAction func onTappedSameNumber(_ sender: UIButton) {
        setupData()
    }
    @IBAction func onTappedDiffNumber(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        aVC.strTitle = ""
        aVC.strSubTitle = "Proceed with adding New User"
        aVC.imageMain = UIImage(named: "NewUser")
        aVC.viewTapped = {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ContactVC.self)
            self.navigationController?.pushViewController(aVC, animated: false)
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
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
