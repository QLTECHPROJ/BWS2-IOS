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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet weak var btnForgetPin: UIButton!
    
    
    // MARK:- VARIABLES
    var tapGesture = UITapGestureRecognizer()
    var arrayUsers = [UserListDataModel]()
    var hideBackButton = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        callUserListAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        btnBack.isHidden = hideBackButton
        
        tableView.register(nibWithCellClass: UserListCell.self)
        tableView.tableFooterView = viewFooter
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewFooter.addGestureRecognizer(tapGesture)
        viewFooter.isUserInteractionEnabled = true
        
        buttonEnableDisable()
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddProfileVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func buttonEnableDisable() {
        var shouldEnable = false
        let selectedUser = arrayUsers.filter { $0.isSelected == true }.first
        
        if selectedUser != nil {
            shouldEnable = true
        }
        
        if shouldEnable {
            btnLogin.isUserInteractionEnabled = true
            btnLogin.backgroundColor = Theme.colors.greenColor
        } else {
            btnLogin.isUserInteractionEnabled = false
            btnLogin.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedForgotPin(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddProfileVC.self)
        aVC.isCome = "ForgotPin"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    
    @IBAction func onTappedLogin(_ sender: UIButton) {
        let selectedUser = arrayUsers.filter { $0.isSelected == true }.first
        
        if let selectedUser = selectedUser {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:PinVC.self)
            aVC.selectedUser = selectedUser
            aVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(aVC, animated: true, completion: nil)
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
