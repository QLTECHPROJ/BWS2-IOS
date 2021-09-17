//
//  PersonalDetailVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 13/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import EVReflection

class EmpowerProfileFormModel : EVObject {
    var gender = ""
    var genderX = ""
    var dob = ""
    var Step = ""
    var UserId = ""
    var title = ""
    var home_address = ""
    var suburb = ""
    var postcode = ""
    var ethnicity = ""
    var mental_health_challenges = ""
    var mental_health_treatments = ""
    
    static var shared = EmpowerProfileFormModel()
}


class PersonalDetailVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var tableViewHeightConst : NSLayoutConstraint!
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    
    //MARK:- Variables
    var arrayOptions = ["Mr", "Mrs", "Master","Ms","Dr","Other"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.register(nibWithCellClass: SleepTimeCell.self)
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableView.register(nibWithCellClass: OptionsCell.self)
        tableView.reloadData()
        
        tableViewHeightConst.constant = CGFloat(96 * arrayOptions.count)
        self.view.layoutIfNeeded()
        
        progressView.progress = 0.0
        btnPrev.isEnabled = true
        btnPrev.isHidden = true
        btnNext.isEnabled = false
        if EmpowerProfileFormModel.shared.title.trim.count > 0 {
            progressView.progress = 0.16
            btnNext.isEnabled = true
        }
    }
    
    override func setupData() {
        
    }
    
    override func goNext() {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: AddressVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    //MARK:- IBAction Methods
    @IBAction func prevClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        goNext()
    }
  
}
// MARK:- UITableViewDelegate, UITableViewDataSource
extension PersonalDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: OptionsCell.self)
        let optionValue = arrayOptions[indexPath.row]
        cell.buttonOption.setTitle(optionValue, for: .normal)
        
//        if optionValue == ProfileFormModel.shared.gender {
//            cell.buttonOption.borderColor = Theme.colors.purple
//            cell.buttonOption.setTitleColor(Theme.colors.purple, for: .normal)
//        } else {
//            cell.buttonOption.borderColor = Theme.colors.gray_DDDDDD
//            cell.buttonOption.setTitleColor(Theme.colors.textColor, for: .normal)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileFormModel.shared.gender = arrayOptions[indexPath.row]
        self.setupUI()
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //self.goNext()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
}

// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension PersonalDetailVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: SleepTimeCell.self, for: indexPath)
        cell.lblSleepTime.text = arrayOptions[indexPath.item]
        cell.borderWidth = 1
        cell.cornerRadius = 8
        cell.clipsToBounds = true
        cell.borderColor = Theme.colors.gray_CDD4D9
        if arrayOptions[indexPath.item] == EmpowerProfileFormModel.shared.title {
            cell.borderColor = Theme.colors.purple
            cell.lblSleepTime.textColor = Theme.colors.purple
        } else {
            cell.borderColor = Theme.colors.gray_DDDDDD
            cell.lblSleepTime.textColor = Theme.colors.gray_DDDDDD
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        EmpowerProfileFormModel.shared.title = arrayOptions[indexPath.row]
        self.setupUI()
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goNext()
            self.view.isUserInteractionEnabled = true
        }
        collectionview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - 56) / 2
        let height = (50 * width) / 159
        return CGSize(width: width, height: height)
    }
    
}
