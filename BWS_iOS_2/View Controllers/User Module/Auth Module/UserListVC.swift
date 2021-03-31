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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet weak var btnForgetPin: UIButton!
    
    
    // MARK:- VARIABLES
    var tapGesture = UITapGestureRecognizer()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: UserListCell.self)
        tableView.tableFooterView = viewFooter
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewFooter.addGestureRecognizer(tapGesture)
        viewFooter.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddProfileVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedForgotPin(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddProfileVC.self)
        aVC.isCome = "ForgotPin"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    
    @IBAction func onTappedLogin(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddProfileVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension UserListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserListCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:PinVC.self)
        aVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(aVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
