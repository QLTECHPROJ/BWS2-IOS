//
//  AreaOfFocusVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AreaOfFocusVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- VARIABLES
    var arrayAresOfFocus = [AreaOfFocusModel]()
    var arrayCategories = [CategoryListModel]()
    var averageSleepTime = ""
    var isFromEdit = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(nibWithCellClass: RecommendedCategoryHeaderCell.self)
        tableView.register(nibWithCellClass: CategoryTableCell.self)
        
        callGetRecommendedCategoryAPI()
        
        // DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        //     let aVC = AppStoryBoard.main.viewController(viewControllerClass: PreparingPlaylistVC.self)
        //     self.navigationController?.pushViewController(aVC, animated: true)
        // }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        arrayAresOfFocus.removeAll()
        
        for category in arrayCategories {
            for subCategory in category.Details {
                if subCategory.isSelected {
                    let cat = AreaOfFocusModel()
                    cat.MainCat = category.View
                    cat.RecommendedCat = subCategory.ProblemName
                    arrayAresOfFocus.append(cat)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func setInitialData() {
        guard let selectedCategories = CoUserDataModel.currentUser?.AreaOfFocus else {
            return
        }
        
        for category in arrayCategories {
            for subCategory in category.Details {
                for selectedCategory in selectedCategories {
                    if selectedCategory.MainCat == category.View && selectedCategory.RecommendedCat == subCategory.ProblemName {
                        subCategory.isSelected = true
                    }
                }
            }
        }
        
        self.setupData()
    }
    
    func categoryClicked(indexPath : IndexPath) {
        
        let isSelected = arrayCategories[indexPath.section].Details[indexPath.row].isSelected
        
        if arrayAresOfFocus.count < 3 || isSelected == true {
            for (section,categoy) in arrayCategories.enumerated() {
                if indexPath.section == section {
                    var isSelected = categoy.Details[indexPath.row].isSelected
                    for subCategory in categoy.Details {
                        subCategory.isSelected = false
                    }
                    
                    isSelected.toggle()
                    categoy.Details[indexPath.row].isSelected = isSelected
                }
            }
        } else {
            showAlertToast(message: "You can select maximum 3 categories")
        }
        
        self.setupData()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func continueClicked() {
        print("Sleep Time :- ",averageSleepTime)
        if arrayAresOfFocus.count > 0 {
            var selectedCategories = [[String:Any]]()
            for category in arrayAresOfFocus {
                let catData = ["View":category.MainCat,
                               "ProblemName":category.RecommendedCat]
                selectedCategories.append(catData)
            }
            
            callSaveCategoryAPI(areaOfFocus: selectedCategories)
        } else {
            showAlertToast(message: "Please Select Category")
        }
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension AreaOfFocusVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return arrayCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: RecommendedCategoryHeaderCell.self)
            cell.configureCell(data: arrayAresOfFocus)
            
            cell.backClicked = {
                self.navigationController?.popViewController(animated: true)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: CategoryTableCell.self)
            cell.configureCell(data: arrayCategories[indexPath.row])
            
            cell.categoryClicked = { rowIndex in
                self.categoryClicked(indexPath: IndexPath(row: rowIndex, section: indexPath.row))
            }
            
            return cell
        }
    }
    
}
