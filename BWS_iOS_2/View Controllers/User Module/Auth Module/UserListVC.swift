//
//  UserListVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class UserListVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet weak var btnForgetPin: UIButton!
    
    
    // MARK:- VARIABLES
    var tapGesture = UITapGestureRecognizer()
    var arrayUsers = [CoUserDataModel]()
    var maxUsers = 2
    var hideBackButton = true
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        callUserListAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        btnBack.isHidden = hideBackButton
        
        let normalString = "Simply sign-in to your account and continue your journey towards mental & emotional transformation"
        lblSubTitle.attributedText = normalString.attributedString(alignment: .left, lineSpacing: 10)
        
        tableView.register(nibWithCellClass: UserListCell.self)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewFooter.addGestureRecognizer(tapGesture)
        viewFooter.isUserInteractionEnabled = true
        
        buttonEnableDisable()
    }
    
    override func setupData() {
        self.buttonEnableDisable()
        
        if arrayUsers.count < maxUsers {
            tableView.tableFooterView = viewFooter
        } else {
            tableView.tableFooterView = UIView()
        }
        
        self.tableView.reloadData()
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddProfileVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = false
        let selectedUser = arrayUsers.filter { $0.isSelected == true }.first
        
        if selectedUser != nil {
            shouldEnable = true
        }
        
        if shouldEnable {
            btnLogin.isUserInteractionEnabled = true
            btnLogin.backgroundColor = Theme.colors.green_008892
            
            btnForgetPin.isUserInteractionEnabled = true
            btnForgetPin.setTitleColor(Theme.colors.green_008892, for: .normal)
        } else {
            btnLogin.isUserInteractionEnabled = false
            btnLogin.backgroundColor = Theme.colors.gray_7E7E7E
            
            btnForgetPin.isUserInteractionEnabled = false
            btnForgetPin.setTitleColor(Theme.colors.gray_7E7E7E, for: .normal)
        }
    }
    
    func handleCoUserRedirection() {
        if let coUser = CoUserDataModel.currentUser {
            if coUser.isProfileCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: ContinueVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.isAssessmentCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DoDassAssessmentVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.planDetails?.count == 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.AvgSleepTime.trim.count == 0 || coUser.AreaOfFocus.count == 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else {
                APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedForgotPin(_ sender: UIButton) {
        let selectedUser = arrayUsers.filter { $0.isSelected == true }.first
        
        if let selectedUser = selectedUser {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddProfileVC.self)
            aVC.selectedUser = selectedUser
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            showAlertToast(message: Theme.strings.alert_select_login_user)
        }
    }
    
    
    @IBAction func onTappedLogin(_ sender: UIButton) {
        let selectedUser = arrayUsers.filter { $0.isSelected == true }.first
        
        if let selectedUser = selectedUser {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:PinVC.self)
            aVC.selectedUser = selectedUser
            aVC.pinVerified = {
                self.handleCoUserRedirection()
            }
            aVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(aVC, animated: true, completion: nil)
        } else {
            showAlertToast(message: Theme.strings.alert_select_login_user)
        }
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension UserListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserListCell.self)
        cell.configureCell(data: arrayUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for user in arrayUsers {
            user.isSelected = false
        }
        
        arrayUsers[indexPath.row].isSelected = true
        tableView.reloadData()
        
        buttonEnableDisable()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
}
