//
//  GenderVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 14/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class GenderVC: BaseViewController {
    
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
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: OptionsCell.self)
       
        tableViewHeightConst.constant = CGFloat(96 * arrayOptions.count)
        self.view.layoutIfNeeded()
        
        progressView.progress = 0.48
        btnPrev.isEnabled = true
        
        btnNext.isEnabled = false
        if EmpowerProfileFormModel.shared.gender.trim.count > 0 {
            if arrayOptions.contains(EmpowerProfileFormModel.shared.gender) {
                if EmpowerProfileFormModel.shared.genderX == "Gender X" {
                    progressView.progress = 0.48
                } else {
                    progressView.progress = 0.64
                    btnPrev.isHidden = false
                }
                btnNext.isEnabled = true
            }
        }
        tableView.reloadData()
    }
    
    override func goNext() {
        if EmpowerProfileFormModel.shared.gender == "Gender X" {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: GenderXVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: PersonalHistoryVC.self)
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
extension GenderVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: OptionsCell.self)
        let optionValue = arrayOptions[indexPath.row]
        cell.buttonOption.setTitle(optionValue, for: .normal)
        
        if optionValue == EmpowerProfileFormModel.shared.gender {
            cell.buttonOption.borderColor = Theme.colors.purple
            cell.buttonOption.setTitleColor(Theme.colors.purple, for: .normal)
        } else {
            cell.buttonOption.borderColor = Theme.colors.gray_DDDDDD
            cell.buttonOption.setTitleColor(Theme.colors.textColor, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EmpowerProfileFormModel.shared.gender = arrayOptions[indexPath.row]
        self.setupUI()
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goNext()
            self.view.isUserInteractionEnabled = true
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
}