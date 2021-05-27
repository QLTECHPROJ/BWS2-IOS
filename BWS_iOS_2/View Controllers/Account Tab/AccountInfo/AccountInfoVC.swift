//
//  AccountInfoVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 27/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AccountInfoVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var arrImage = ["UserName","ChangePassword","ChangePIN"]
    var arrTitle = ["Edit Profile","Change Password","Change PIN"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.account_info)
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableView.register(nibWithCellClass:AccountCell.self)
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
}

extension AccountInfoVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AccountCell.self)
        cell.viewBack.backgroundColor = Theme.colors.off_white_F9F9F9
        cell.img.image = UIImage(named: arrImage[indexPath.section])
        cell.lblTitle.text = arrTitle[indexPath.section]
        cell.lblLine.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if checkInternet() == false {
                showAlertToast(message: Theme.strings.alert_check_internet)
                return
            }
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: EditProfileVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }else if indexPath.section == 1 {
            if checkInternet() == false {
                showAlertToast(message: Theme.strings.alert_check_internet)
                return
            }
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: ChangePassWordVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }else {
            if checkInternet() == false {
                showAlertToast(message: Theme.strings.alert_check_internet)
                return
            }
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: ChangePINVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
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
