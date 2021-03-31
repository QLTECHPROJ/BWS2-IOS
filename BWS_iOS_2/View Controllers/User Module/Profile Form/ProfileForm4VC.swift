//
//  ProfileForm4VC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ProfileForm4VC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var tableViewHeightConst : NSLayoutConstraint!
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    
    
    // MARK:- VARIABLES
    // var selectedValue = ""
    var arrayOptions = ["0 - 4", "5 -12", "13 - 17", "> 18"]
    var parameters = [String:Any]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: OptionsCell.self)
        tableView.reloadData()
        
        tableViewHeightConst.constant = CGFloat(96 * arrayOptions.count)
        self.view.layoutIfNeeded()
        
        progressView.progress = 0.8
        btnPrev.isEnabled = true
        
        btnNext.isEnabled = false
        if ProfileFormModel.shared.age.trim.count > 0 {
            if arrayOptions.contains(ProfileFormModel.shared.age) {
                btnNext.isEnabled = true
            }
        }
    }
    
    override func goNext() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm5VC.self)
        parameters["age"] = ProfileFormModel.shared.age
        aVC.parameters = self.parameters
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func prevClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        goNext()
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension ProfileForm4VC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: OptionsCell.self)
        let optionValue = arrayOptions[indexPath.row]
        cell.buttonOption.setTitle(optionValue, for: .normal)
        
        if optionValue == ProfileFormModel.shared.age {
            cell.buttonOption.borderColor = Theme.colors.purple
            cell.buttonOption.setTitleColor(Theme.colors.purple, for: .normal)
        } else {
            cell.buttonOption.borderColor = Theme.colors.gray_DDDDDD
            cell.buttonOption.setTitleColor(Theme.colors.textColor, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileFormModel.shared.age = arrayOptions[indexPath.row]
        self.setupUI()
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goNext()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
}
