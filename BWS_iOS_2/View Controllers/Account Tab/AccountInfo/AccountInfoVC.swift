//
//  AccountInfoVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 27/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

enum AccountInfoMenu : String {
    case editProfile = "Edit Profile"
    case changePIN = "Change PIN"
    case deleteAccount = "Delete Account"
}

class AccountInfoVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- VARIABLES
    var arrayImage = ["UserName", "ChangePIN", "delete_account"]
    var arrayTitle : [AccountInfoMenu] = [AccountInfoMenu.editProfile, AccountInfoMenu.changePIN, AccountInfoMenu.deleteAccount]
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.account_info)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass:AccountCell.self)
        
        if CoUserDataModel.currentUser?.isPinSet != "1" {
            if let index = arrayTitle.firstIndex(of: .changePIN), arrayTitle.count > index, arrayImage.count > index {
                arrayImage.remove(at: index)
                arrayTitle.remove(at: index)
            }
        }
    }
    
    func handleCellSelctionAction(indexPath : IndexPath) {
        
        switch arrayTitle[indexPath.section] {
        case .editProfile:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: EditProfileVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .changePIN:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: ChangePINVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .deleteAccount:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: CancelSubVC.self)
            aVC.isFromDelete = true
            self.navigationController?.pushViewController(aVC, animated: true)
            break
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension AccountInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AccountCell.self)
        cell.viewBack.backgroundColor = Theme.colors.off_white_F9F9F9
        cell.img.image = UIImage(named: arrayImage[indexPath.section])
        cell.lblTitle.text = arrayTitle[indexPath.section].rawValue
        cell.lblLine.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.handleCellSelctionAction(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
