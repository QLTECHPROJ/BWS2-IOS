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
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(nibWithCellClass: RecommendedCategoryHeaderCell.self)
        tableView.register(nibWithCellClass: CategoryTableCell.self)
        
        fetchAreaOfFocus()
        fetchCategories()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: PreparingPlaylistVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    
    // MARK:- FUNCTIONS
    func fetchAreaOfFocus() {
        arrayAresOfFocus.removeAll()
        
        let timesArray = ["Alcohol Addiction", "Parental Stress", "Drug Addiction"]
        for time in timesArray {
            let subCategory = CategoryDataModel()
            subCategory.CategoryName = time
            arrayAresOfFocus.append(subCategory)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
    func fetchCategories() {
        arrayCategories.removeAll()
        
        let categoryArray = ["Mental Health", "Self - Development", "Addiction"]
        let timesArray = ["Alcohol Addiction", "Eating Disorder", "Money Stress", "Anger / Aggression / Moods", "Obsessive complusive disorder", "Stress / Anxiety / Depression / Happiness", "Trauma/PTSD", "Insomnia", "Loneliness or Abandonment", "Memory", "Mind Chatter or Worry", "Parental Stress", "Fatigue", "Self esteem / Self confidence / Self Worth / Inadequacies", "Relationship Breakdown"]
        
        for category in categoryArray {
            var arraySubCategories = [CategoryDataModel]()
            
            for time in timesArray {
                let subCategory = CategoryDataModel()
                subCategory.CategoryName = time
                arraySubCategories.append(subCategory)
            }
            
            let categoryData = CategoryListModel()
            categoryData.CategoryName = category
            categoryData.SubCategories = arraySubCategories
            arrayCategories.append(categoryData)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
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
        }
        else {
            let cell = tableView.dequeueReusableCell(withClass: CategoryTableCell.self)
            cell.configureCell(data: arrayCategories[indexPath.row])
            return cell
        }
    }
    
}
