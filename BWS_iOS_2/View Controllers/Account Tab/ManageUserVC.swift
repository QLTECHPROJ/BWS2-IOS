//
//  ManageUserVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ManageUserVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRemove: UIButton!
    
    // MARK:- VARIABLES
    var arrayUsers = [CoUserDataModel]()
    var isCome:String?
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callManageUserListAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: ManageUserCell.self)
        tableView.rowHeight = 70
        tableView.reloadData()
        
        buttonEnableDisable()
    }
    
    override func setupData() {
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        let selectedUserCount = arrayUsers.filter { $0.isSelected == true }.count
        
        if selectedUserCount > 0 {
            btnRemove.isUserInteractionEnabled = true
            btnRemove.backgroundColor = Theme.colors.green_008892
        } else {
            btnRemove.isUserInteractionEnabled = false
            btnRemove.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    func cancelClicked(indexPath : IndexPath) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if arrayUsers[indexPath.row].InviteStatus == "1" {
            callCancelInviteAPI(user: arrayUsers[indexPath.row])
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        if isCome == "SMS" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: TabBarController.self)
            aVC.selectedIndex = 6
            self.navigationController?.pushViewController(aVC, animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func addUserClicked(sender : UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddUserVC.self)
        aVC.isCome = "AddUser"
        self.navigationController?.pushViewController(aVC, animated: true)

    }
    
    @IBAction func removeUserClicked(sender : UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
        aVC.titleText = Theme.strings.delete_user_alert_title
        aVC.detailText = Theme.strings.delete_user_alert_subtitle
        aVC.firstButtonTitle = Theme.strings.yes
        aVC.secondButtonTitle = Theme.strings.no
        aVC.firstButtonBackgroundColor = Theme.colors.gray_7E7E7E
        aVC.modalPresentationStyle = .overFullScreen
        aVC.delegate = self
        self.present(aVC, animated: false, completion: nil)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension ManageUserVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ManageUserCell.self)
        cell.configureCell(data: arrayUsers[indexPath.row])
        cell.didClickedCancel = {
            self.cancelClicked(indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayUsers[indexPath.row].InviteStatus != "1" {
            
            for user in arrayUsers {
                if user.UserId == arrayUsers[indexPath.row].UserId {
                    user.isSelected.toggle()
                } else {
                    user.isSelected = false
                }
            }
            
            tableView.reloadData()
            buttonEnableDisable()
        }
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension ManageUserVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            callDeleteUserAPI()
        }
    }
    
}
