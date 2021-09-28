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
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var HeaderCollectionview: DynamicHeightCollectionView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var footerCollectionview: UICollectionView!
    
    
    // MARK:- VARIABLES
    let collectionViewHeaderFooterReuseIdentifier = "MyHeaderFooterClass"
    var arrayAreaOfFocus = [AreaOfFocusModel]()
    var arrayCategories = [CategoryListModel]()
    var arrayCategoriesMain = [CategoryListModel]()
    var averageSleepTime = ""
    var isFromEdit = false
    var isFromEditSleepTime = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.areaOfFocus)
        
        tableView.register(nibWithCellClass: RecommendedCategoryHeaderCell.self)
        tableView.register(nibWithCellClass: CategoryTableCell.self)
        footerCollectionview.register(MyHeaderFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier)
        footerCollectionview.register(nibWithCellClass: CategoryCollectionCell.self)
        
        callGetRecommendedCategoryAPI()
        buttonEnableDisable()
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        footerCollectionview.delegate = self
        footerCollectionview.dataSource = self
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        footerCollectionview.collectionViewLayout = layout
        footerCollectionview.reloadData()
        footerCollectionview.layoutIfNeeded()
        
        tableView.tableFooterView = footerCollectionview
    }
    
    override func setupData() {
        /*
        guard let selectedCategories = CoUserDataModel.currentUser?.AreaOfFocus else {
            return
        }
        
        arrayAreaOfFocus.removeAll()
        for category in selectedCategories {
            let cat = AreaOfFocusModel()
            cat.MainCat = category.MainCat
            cat.RecommendedCat = category.RecommendedCat
            arrayAreaOfFocus.append(cat)
        }
         */
        
        tableView.reloadData()
        footerCollectionview.reloadData()
        buttonEnableDisable()
        
        adjustCollectionViewHeight()
    }
    
    func setInitialData() {
        /*
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
         */
        
        self.setupData()
    }
    
    func categoryClicked(indexPath : IndexPath,collectionview:UICollectionView) {
        
        let isSelected = self.arrayCategories[indexPath.section].Details[indexPath.item].isSelected
        
        if isSelected {
            self.arrayCategories[indexPath.section].Details[indexPath.item].isSelected = false
            let cat = AreaOfFocusModel()
            cat.MainCat = self.arrayCategories[indexPath.section].View
            cat.RecommendedCat = self.arrayCategories[indexPath.section].Details[indexPath.item].ProblemName
            
            if let removeIndex = self.arrayAreaOfFocus.firstIndex(of: cat) {
                self.arrayAreaOfFocus.remove(at: removeIndex)
            }
        } else {
            if self.arrayAreaOfFocus.count < 3 {
                /*
                 for subCategory in self.arrayCategories[indexPath.section].Details {
                     subCategory.isSelected = false
                     
                     let cat = AreaOfFocusModel()
                     cat.MainCat = self.arrayCategories[indexPath.section].View
                     cat.RecommendedCat = subCategory.ProblemName
                     
                     if let removeIndex = self.arrayAreaOfFocus.firstIndex(of: cat) {
                         self.arrayAreaOfFocus.remove(at: removeIndex)
                     }
                 }
                 */
                
                self.arrayCategories[indexPath.section].Details[indexPath.item].isSelected = true
                
                let cat = AreaOfFocusModel()
                cat.MainCat = self.arrayCategories[indexPath.section].View
                cat.RecommendedCat = self.arrayCategories[indexPath.section].Details[indexPath.item].ProblemName
                self.arrayAreaOfFocus.append(cat)
            } else {
                showAlertToast(message: Theme.strings.alert_max_category)
            }
        }
        
        tableView.alwaysBounceVertical = false
        footerCollectionview.reloadData()
        tableView.reloadData()
        buttonEnableDisable()
        
        adjustCollectionViewHeight()
    }
    
    func searchCategory(searchText : String) {
        if searchText.trim.count > 0 {
            var categories = [CategoryListModel]()
            
            for category in arrayCategoriesMain {
                let newCat = CategoryListModel()
                newCat.ID = category.ID
                newCat.View = category.View
                newCat.Details = category.Details.filter({ (model:CategoryDataModel) -> Bool in
                    return model.ProblemName.lowercased().contains(searchText.lowercased())
                })
                
                categories.append(newCat)
            }
            
            //            arrayCategories = arrayCategoriesMain.filter({ (model:CategoryListModel) -> Bool in
            //                return model.View.lowercased().contains(searchText.lowercased())
            //            })
            
            arrayCategories = categories
            
            let categoryList = arrayCategories.filter({ (model:CategoryListModel) -> Bool in
                return model.Details.count > 0
            })
            
            if categoryList.count > 0 {
                //tableView.tableFooterView = nil
                footerCollectionview.isHidden = false
                lblNoData.isHidden = true
            } else {
                footerCollectionview.isHidden = true
                tableView.tableFooterView = footerView
                lblNoData.isHidden = false
                lblNoData.text = "Couldn't find " + searchText + " Try searching again"
            }
            
            lblNoData.isHidden = categoryList.count != 0
            
            tableView.reloadData()
            tableView.scrollToBottom()
            tableView.scrollToTop()
            footerCollectionview.reloadData()
        } else {
            tableView.tableFooterView = footerCollectionview
            footerCollectionview.isHidden = false
            arrayCategories = arrayCategoriesMain
            lblNoData.isHidden = true
            tableView.reloadData()
            tableView.scrollToBottom()
            tableView.scrollToTop()
            footerCollectionview.reloadData()
        }
        
        adjustCollectionViewHeight()
    }
    
    override func buttonEnableDisable() {
        if arrayAreaOfFocus.count > 0 {
            btnCategory.isUserInteractionEnabled = true
            btnCategory.backgroundColor = Theme.colors.green_008892
        } else {
            btnCategory.isUserInteractionEnabled = false
            btnCategory.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    func adjustCollectionViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.footerCollectionview.reloadData()
            let height = self.footerCollectionview.collectionViewLayout.collectionViewContentSize.height
            self.footerCollectionview.frame = CGRect(x: 0, y: 0, width: Int(self.footerCollectionview.frame.width), height:Int(height))
            self.tableView.tableFooterView = self.footerCollectionview
        }
    }
    
    func showAlertForChangeSleepTime(data : SaveCategoryDataModel) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
        aVC.titleText = ""
        aVC.detailText = data.popupContent
        aVC.firstButtonTitle = Theme.strings.Edit_Area_of_Focus
        aVC.secondButtonTitle = Theme.strings.Edit_Sleep_Time
        aVC.modalPresentationStyle = .overFullScreen
        aVC.delegate = self
        self.present(aVC, animated: true, completion: nil)
    }
    
    func handleRedirection() {
        var shouldPush = true
        if let controllers = self.navigationController?.viewControllers {
            for controller in controllers {
                if controller.isKind(of: SleepTimeVC.self) {
                    if let aVC = controller as? SleepTimeVC {
                        aVC.isFromEdit = self.isFromEdit
                    }
                    shouldPush = false
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        
        if shouldPush {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
            aVC.isFromEdit = self.isFromEdit
            aVC.hideCloseButton = false
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func continueClicked() {
        print("Sleep Time :- ",averageSleepTime)
        
        //        if isFromEdit && DJMusicPlayer.shared.currentPlaylist?.Created == "2" {
        //            self.clearAudioPlayer()
        //        }
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RecommendedCategoryHeaderCell.self)
        cell.configureCell(data: arrayAreaOfFocus)
        
        cell.searchText = { keyword in
            self.searchCategory(searchText: keyword)
        }
        
        cell.backClicked = {
            if self.isFromEditSleepTime {
                self.navigationController?.popViewController(animated: true)
            } else if self.isFromEdit {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension AreaOfFocusVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCategories[section].Details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CategoryCollectionCell.self, for: indexPath)
        cell.lblCategory.text = arrayCategories[indexPath.section].Details[indexPath.item].ProblemName
        cell.arrayAreaOfFocus = self.arrayAreaOfFocus
        cell.configureCell(mainCategory: arrayCategories[indexPath.section].View, data: arrayCategories[indexPath.section].Details[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryClicked(indexPath: indexPath, collectionview: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath)
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
            label.text = arrayCategories[indexPath.section].View
            label.font = .systemFont(ofSize: 16)
            label.textColor = .black
            label.backgroundColor = .white
            headerView.addSubview(label)
            headerView.backgroundColor = UIColor.white
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath)
            footerView.backgroundColor = UIColor.green
            return footerView
            
        default:
            break
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if arrayCategories[section].Details.count == 0 {
            return CGSize(width: 140, height: 0)
        }
        return CGSize(width: 140, height: 50)
    }
    
}

// MARK:- AlertPopUpVCDelegate
extension AreaOfFocusVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 1 {
            self.handleRedirection()
        }
    }
    
}
