//
//  BrainFeelingVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 22/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class BrainFeelingVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var collectionview : UICollectionView!
    @IBOutlet weak var btnContinue : UIButton!
    
    // MARK:- VARIABLES
    var arrayCategories = [BrainFeelingModel]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionview.register(nibWithCellClass: CategoryCollectionCell.self)
        
        setupUI()
        buttonEnableDisable()
        
        callGetBrainFeelingAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        collectionview.collectionViewLayout = layout
        collectionview.reloadData()
        collectionview.layoutIfNeeded()
    }
    
    func categoryClicked(indexPath : IndexPath) {
        let selectedCategories = arrayCategories.filter({ $0.isSelected })
        
        if self.arrayCategories[indexPath.item].isSelected {
            self.arrayCategories[indexPath.item].isSelected = false
        } else {
            if selectedCategories.count < 3 {
                self.arrayCategories[indexPath.item].isSelected = true
            } else {
                showAlertToast(message: Theme.strings.alert_max_category)
            }
        }
        
        self.collectionview.reloadData()
        self.buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        let selectedCategories = arrayCategories.filter({ $0.isSelected })
        if selectedCategories.count > 0 {
            btnContinue.isUserInteractionEnabled = true
            btnContinue.backgroundColor = Theme.colors.green_008892
        } else {
            btnContinue.isUserInteractionEnabled = false
            btnContinue.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    func fetchDummyData() {
        for i in 1...30 {
            let category = BrainFeelingModel()
            category.id = "\(i)"
            category.name = (i % 2 == 0) ? "ProblemName \(i)" : "Cat \(i * 2)"
            
            arrayCategories.append(category)
        }
        
        collectionview.reloadData()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func continueClicked(sender : UIButton) {
        let selectedCategories = arrayCategories.filter({ $0.isSelected })
        if selectedCategories.count > 0 {
            let strSelectedCategories = selectedCategories.map( { $0.id })
            print("selectedCategories :- ",strSelectedCategories)
            callSaveBrainFeelingAPI(feelings: strSelectedCategories)
        } else {
            showAlertToast(message: Theme.strings.alert_select_category)
        }
    }
    
}


extension BrainFeelingVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CategoryCollectionCell.self, for: indexPath)
        cell.configureCell(data: arrayCategories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryClicked(indexPath: indexPath)
    }
    
}
