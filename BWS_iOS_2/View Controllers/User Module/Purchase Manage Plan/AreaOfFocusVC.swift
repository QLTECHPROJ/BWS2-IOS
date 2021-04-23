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
    var arrayAresOfFocus = [CategoryDataModel]()
    var arrayCategories = [CategoryListModel]()
    var averageSleepTime = ""
    
    
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
                    arrayAresOfFocus.append(subCategory)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func continueClicked() {
        print("Sleep Time :- ",averageSleepTime)
        if arrayAresOfFocus.count > 0 {
            let categories = arrayAresOfFocus.map { $0.ProblemName }
            let strCategories = categories.joined(separator: ",")
            print("Selected Categories :- ",strCategories)
            
            callSaveCategoryAPI(areaOfFocus: strCategories)
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
            
            cell.categoryClicked = {
                self.setupData()
            }
            
            return cell
        }
    }
    
}
