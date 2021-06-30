//
//  ProfileForm2VC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import EVReflection

class ProfileFormModel : EVObject {
    var gender = ""
    var genderX = ""
    var age = ""
    var prevDrugUse = ""
    var Medication = ""
    
    static var shared = ProfileFormModel()
}


class ProfileForm2VC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var tableViewHeightConst : NSLayoutConstraint!
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    
    
    // MARK:- VARIABLES
    var arrayOptions = ["Male", "Female", "Gender X"]
    
    
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
        
        progressView.progress = 0.0
        btnPrev.isEnabled = true
        btnPrev.isHidden = true
        
        btnNext.isEnabled = false
        if ProfileFormModel.shared.gender.trim.count > 0 {
            if arrayOptions.contains(ProfileFormModel.shared.gender) {
                if ProfileFormModel.shared.gender == "Gender X" {
                    progressView.progress = 0.0
                } else {
                    progressView.progress = 0.25
                }
                btnNext.isEnabled = true
            }
        }
    }
    
    override func goNext() {
        if ProfileFormModel.shared.gender == "Gender X" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm3VC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm4VC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
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
extension ProfileForm2VC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: OptionsCell.self)
        let optionValue = arrayOptions[indexPath.row]
        cell.buttonOption.setTitle(optionValue, for: .normal)
        
        if optionValue == ProfileFormModel.shared.gender {
            cell.buttonOption.borderColor = Theme.colors.purple
            cell.buttonOption.setTitleColor(Theme.colors.purple, for: .normal)
        } else {
            cell.buttonOption.borderColor = Theme.colors.gray_DDDDDD
            cell.buttonOption.setTitleColor(Theme.colors.textColor, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileFormModel.shared.gender = arrayOptions[indexPath.row]
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
