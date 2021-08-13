//
//  UserListPopUpVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class UserListPopUpVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewUserList: UIView!
    @IBOutlet weak var viewUserListTopConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewFooter: UIView!
    
    
    // MARK:- VARIABLES
    var tapGesture = UITapGestureRecognizer()
    var arrayUsers = [CoUserDataModel]()
    var maxUsers = 2
    var totalUserCount = 1
    var selectedUser : CoUserDataModel?
    var didCompleteLogin : (() -> Void)?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewUserList.isHidden = true
        viewUserListTopConst.constant = 0
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        callUserListAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        //viewUserList.roundCorners([.topLeft, .topRight], radius: 10)
        
        tableView.register(nibWithCellClass: UserListCell.self)
        if let coUser = CoUserDataModel.currentUser {
            
            if coUser.isMainAccount == "1" {
                tableView.tableFooterView = viewFooter
            } else {
                tableView.tableFooterView = UIView()
            }
            
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewFooter.addGestureRecognizer(tapGesture)
        viewFooter.isUserInteractionEnabled = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTappedback(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewBack.addGestureRecognizer(tapGesture)
        viewBack.isUserInteractionEnabled = true
    }
    
    override func setupData() {
        var heightConst = CGFloat(arrayUsers.count * 86) + CGFloat(70)
        
        heightConst = heightConst + 90
        if heightConst > SCREEN_HEIGHT - 200 {
            heightConst = SCREEN_HEIGHT - 200
        }
        
        if let coUser = CoUserDataModel.currentUser {
        
            if coUser.isMainAccount == "1" {
                viewUserListTopConst.constant = (SCREEN_HEIGHT - 44) - heightConst
            } else {
                viewUserListTopConst.constant =  (SCREEN_HEIGHT + 44) - heightConst
            }
            
        }
        // Minus 44 for Safe Area
        viewUserList.backgroundColor = .white
        self.view.layoutIfNeeded()
        
        self.viewUserList.isHidden = false
        
        for user in arrayUsers {
            if user.UserId == CoUserDataModel.currentUserId {
                user.isSelected = true
            }
        }
        
        self.tableView.reloadData()
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if lockDownloads == "1" {
            openInactivePopup(controller: self)
            return
        } else if lockDownloads == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
            return
        }
        
        if totalUserCount < maxUsers {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddUserVC.self)
            aVC.isCome = "AddUser"
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            showAlertToast(message: Theme.strings.alert_upgrade_plan)
        }
    }
    
    @objc func viewTappedback(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleCoUserRedirection() {
        if let coUser = CoUserDataModel.currentUser {
            if coUser.IsFirst == "1" && coUser.isMainAccount == "0"{
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:EmailVerifyVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.isAssessmentCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DoDassAssessmentVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.planDetails.count == 0  && coUser.isMainAccount == "1"{
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.isProfileCompleted == "0" {
                redirectToProfileStep()
            } else if coUser.AvgSleepTime.trim.count == 0 || coUser.AreaOfFocus.count == 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else {
                APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
            }
        }
    }
    
    func newUserLogin() {
        if let newLoginUser = selectedUser {
            if newLoginUser.isPinSet == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: SetUpPInVC.self)
                aVC.isComeFrom = "UserListPopup"
                aVC.selectedUser = selectedUser
                self.navigationController?.pushViewController(aVC, animated: true)
            }else {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:PinVC.self)
                aVC.strTitle = "Unlock"
                aVC.selectedUser = newLoginUser
                aVC.pinVerified = {
                    self.handleCoUserRedirection()
                }
                aVC.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(aVC, animated: true, completion: nil)
            }
        }
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension UserListPopUpVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortUsers = arrayUsers.sorted(by: { $0.MainAccountID == $1.UserId })
        return sortUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserListCell.self)
        cell.configureCell(data: arrayUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = arrayUsers[indexPath.row]
        
        DispatchQueue.main.async {
            if self.selectedUser?.UserId == CoUserDataModel.currentUserId {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.newUserLogin()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
}
