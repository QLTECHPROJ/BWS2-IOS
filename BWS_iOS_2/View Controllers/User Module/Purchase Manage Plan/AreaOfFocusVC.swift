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
    var arrayMain : CategoryModel?
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.register(nibWithCellClass: RecommendedCategoryHeaderCell.self)
        tableView.register(nibWithCellClass: CategoryTableCell.self)
      
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            let aVC = AppStoryBoard.main.viewController(viewControllerClass: PreparingPlaylistVC.self)
//            self.navigationController?.pushViewController(aVC, animated: true)
//        }
        callRecCategory()
        setupData()
       // fetchAreaOfFocus()
      //  fetchCategories()
        
    }
    
    
    // MARK:- FUNCTIONS
//    func fetchAreaOfFocus() {
//      //  arrayAresOfFocus.removeAll()
//
//      //  let timesArray = ["Alcohol Addiction", "Parental Stress", "Drug Addiction"]
//        for time in arrayCategories {
//            let subCategory = CategoryDataModel()
//
//            for i in 0...time.Details.count {
//                subCategory.ProblemName = time.Details[i].ProblemName
//            }
//
//            arrayAresOfFocus.append(subCategory)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.tableView.reloadData()
//        }
//    }
    
//    func fetchCategories() {
//        arrayCategories.removeAll()
//
//      //  let categoryArray = ["Mental Health", "Self - Development", "Addiction"]
//     //   let timesArray = ["Alcohol Addiction", "Eating Disorder", "Money Stress", "Anger / Aggression / Moods", "Obsessive complusive disorder", "Stress / Anxiety / Depression / Happiness", "Trauma/PTSD", "Insomnia", "Loneliness or Abandonment", "Memory", "Mind Chatter or Worry", "Parental Stress", "Fatigue", "Self esteem / Self confidence / Self Worth / Inadequacies", "Relationship Breakdown"]
//
//        for category in arrayCategories {
//            var arraySubCategories = [CategoryDataModel]()
//
//            for time in arrayCategories {
//                let subCategory = CategoryDataModel()
//                for i in 0...time.Details.count {
//                    subCategory.ProblemName = time.Details[i].ProblemName
//                }
//                arraySubCategories.append(subCategory)
//            }
//
//            let categoryData = CategoryListModel()
//            categoryData.View = category.View
//            categoryData.Details = arraySubCategories
//            arrayCategories.append(categoryData)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.tableView.reloadData()
//        }
//    }
    
    override func setupData() {

    }
    
    @IBAction func OnTappedContinue(_ sender: UIButton) {
        
        
    }
    
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension AreaOfFocusVC : UITableViewDataSource, UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        } else {
       // return arrayCategories[section].Details.count
       // }
        
        if arrayCategories.count > 0 {
            
            return arrayCategories.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: RecommendedCategoryHeaderCell.self)
            let arrayCat = CategoryModel.category.self
            if arrayCat != nil {
                cell.configureCell(data:arrayCat!)
            }
            cell.backClicked = {
                self.navigationController?.popViewController(animated: true)
            }
            return cell
        }
        else {
        let cell = tableView.dequeueReusableCell(withClass: CategoryTableCell.self)
        cell.lblCategory.text = arrayCategories[indexPath.row - 1].View
            cell.configureCell(data:arrayCategories[indexPath.row - 1], main: arrayMain!)
       // cell.collectionView.reloadData()
        return cell
        }
    }
   
}
