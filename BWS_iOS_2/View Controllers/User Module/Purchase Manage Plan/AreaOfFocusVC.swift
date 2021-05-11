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
    
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    // MARK:- VARIABLES
    var arrayAreaOfFocus = [AreaOfFocusModel]()
    var arrayCategories = [CategoryListModel]()
    var arrayCategoriesMain = [CategoryListModel]()
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
        arrayAreaOfFocus.removeAll()
        
        for category in arrayCategories {
            for subCategory in category.Details {
                if subCategory.isSelected {
                    let cat = AreaOfFocusModel()
                    cat.MainCat = category.View
                    cat.RecommendedCat = subCategory.ProblemName
                    arrayAreaOfFocus.append(cat)
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
        
        if isSelected {
            arrayCategories[indexPath.section].Details[indexPath.row].isSelected = false
            let cat = AreaOfFocusModel()
            cat.MainCat = arrayCategories[indexPath.section].View
            cat.RecommendedCat = arrayCategories[indexPath.section].Details[indexPath.row].ProblemName
            
            if let removeIndex = arrayAreaOfFocus.firstIndex(of: cat) {
                arrayAreaOfFocus.remove(at: removeIndex)
            }
        } else {
            if arrayAreaOfFocus.count < 3 {
                for subCategory in arrayCategories[indexPath.section].Details {
                    subCategory.isSelected = false
                    
                    let cat = AreaOfFocusModel()
                    cat.MainCat = arrayCategories[indexPath.section].View
                    cat.RecommendedCat = subCategory.ProblemName
                    
                    if let removeIndex = arrayAreaOfFocus.firstIndex(of: cat) {
                        arrayAreaOfFocus.remove(at: removeIndex)
                    }
                }
                
                arrayCategories[indexPath.section].Details[indexPath.row].isSelected = true
                
                let cat = AreaOfFocusModel()
                cat.MainCat = arrayCategories[indexPath.section].View
                cat.RecommendedCat = arrayCategories[indexPath.section].Details[indexPath.row].ProblemName
                arrayAreaOfFocus.append(cat)
            } else {
                showAlertToast(message: Theme.strings.alert_max_category)
            }
        }
        
        tableView.reloadData()
        
        //        if arrayAresOfFocus.count < 3 || isSelected == true {
        //            for (section,categoy) in arrayCategories.enumerated() {
        //                if indexPath.section == section {
        //                    var isSelected = categoy.Details[indexPath.row].isSelected
        //                    for subCategory in categoy.Details {
        //                        subCategory.isSelected = false
        //                    }
        //
        //                    isSelected.toggle()
        //                    categoy.Details[indexPath.row].isSelected = isSelected
        //                }
        //            }
        //        } else {
        //            showAlertToast(message: Theme.strings.alert_max_category)
        //        }
        //
        //        self.setupData()
    }
    
    func searchCategory(searchText : String) {
        if searchText.trim.count > 0 {
            arrayCategories = arrayCategoriesMain.filter({ (model:CategoryListModel) -> Bool in
                return model.View.lowercased().contains(searchText.lowercased())
            })
            
             if arrayCategories.count > 0 {
                tableView.tableFooterView = nil
                lblNoData.isHidden = true
             } else {
                tableView.tableFooterView = footerView
                lblNoData.isHidden = false
                lblNoData.text = "Couldn't find " + searchText + " Try searching again"
             }
            lblNoData.isHidden = arrayCategories.count != 0
            tableView.reloadData()
        } else {
            tableView.tableFooterView = nil
            arrayCategories = arrayCategoriesMain
            lblNoData.isHidden = true
            tableView.reloadData()
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func continueClicked() {
        print("Sleep Time :- ",averageSleepTime)
        
        if isFromEdit && DJMusicPlayer.shared.currentPlaylist?.Created == "2" {
            self.clearAudioPlayer()
        }
        
        if arrayAreaOfFocus.count > 0 {
            var selectedCategories = [[String:Any]]()
            for category in arrayAreaOfFocus {
                let catData = ["View":category.MainCat,
                               "ProblemName":category.RecommendedCat]
                selectedCategories.append(catData)
            }
            
            callSaveCategoryAPI(areaOfFocus: selectedCategories)
        } else {
            showAlertToast(message: Theme.strings.alert_select_category)
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
            cell.configureCell(data: arrayAreaOfFocus)
            
            cell.searchText = { keyword in
                self.searchCategory(searchText: keyword)
            }
            
            cell.backClicked = {
                if self.isFromEdit {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: CategoryTableCell.self)
            cell.arrayAreaOfFocus = self.arrayAreaOfFocus
            cell.configureCell(data: arrayCategories[indexPath.row])
            
            cell.categoryClicked = { rowIndex in
                self.categoryClicked(indexPath: IndexPath(row: rowIndex, section: indexPath.row))
            }
            
            return cell
        }
    }
    
}
