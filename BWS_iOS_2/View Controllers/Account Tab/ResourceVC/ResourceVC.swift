//
//  ResourceVC.swift
//  BWS
//
//  Created by Sapu on 21/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

enum ResourcesType : String {
    case audioBooks = "1"
    case documentaries = "2"
    case podcasts = "3"
    case websites = "4"
    case apps = "5"
}

class ResourceVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewSegment : UIView!
    @IBOutlet weak var viewFilter : UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var viewFilterHeightConst : NSLayoutConstraint!
    
    
    // MARK:- VARIABLES
    var selectedSegment: SJSegmentTab?
    var segmentController = SJSegmentedViewController()
    
    var selectedController: UIViewController?
    
    var pageMenu = DJPageMenuController()
    
    static var arrayCategories = [ResourceCategoryDataModel]()
    static var selectedCategory = ""
    
    var selectedResourcesType = "Audio Books"
    
    static var audioData = [ResourceListDataModel]()
    static var podcastData = [ResourceListDataModel]()
    static var websiteData = [ResourceListDataModel]()
    static var documentariesData = [ResourceListDataModel]()
    static var appsData = [ResourceListDataModel]()
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSegment.clipsToBounds = true
        
        viewFilter.isHidden = true
        
        ResourceVC.arrayCategories = [ResourceCategoryDataModel]()
        
        ResourceVC.audioData = [ResourceListDataModel]()
        ResourceVC.podcastData = [ResourceListDataModel]()
        ResourceVC.websiteData = [ResourceListDataModel]()
        ResourceVC.documentariesData = [ResourceListDataModel]()
        ResourceVC.appsData = [ResourceListDataModel]()
        
        //        openPageMenuOrder()
        callResourceCategoryListAPI()
        
        // Segment Tracking
        SegmentTracking.shared.trackEvent(name: "Resources Screen Viewed", traits: ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""], trackingType: .screen)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        viewSegment.isUserInteractionEnabled = true
        viewFilter.isHidden = true
        
        ResourceVC.audioData = [ResourceListDataModel]()
        ResourceVC.podcastData = [ResourceListDataModel]()
        ResourceVC.websiteData = [ResourceListDataModel]()
        ResourceVC.documentariesData = [ResourceListDataModel]()
        ResourceVC.appsData = [ResourceListDataModel]()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(UINib(nibName:"FeatureCell", bundle: nil), forCellReuseIdentifier:"FeatureCell")
        tableView.rowHeight = 30
        
        tableView.reloadData()
        viewFilterHeightConst.constant = CGFloat(ResourceVC.arrayCategories.count * 30)
        self.view.layoutIfNeeded()
    }
    
    
    // MARK:- FUNCTIONS
    //    func openPageMenuOrder() {
    //        let firstVC:RecAudioBookVC = storyboard! .instantiateViewController(withIdentifier:"RecAudioBookVC") as! RecAudioBookVC
    //        firstVC.title = "Audio Books"
    //
    //        let secondVC:RecPodCastsVC = storyboard! .instantiateViewController(withIdentifier:"RecPodCastsVC") as! RecPodCastsVC
    //        secondVC.title = "Podcasts"
    //
    //        let ThirdVC:RecApps = storyboard! .instantiateViewController(withIdentifier:"RecApps") as! RecApps
    //        ThirdVC.title = "Apps"
    //
    //        let forthVC:RecWebSite = storyboard! .instantiateViewController(withIdentifier:"RecWebSite") as! RecWebSite
    //        forthVC.title = "Websites"
    //
    //        let fifthVC:RecDocuVC = storyboard! .instantiateViewController(withIdentifier:"RecDocuVC") as! RecDocuVC
    //        fifthVC.title = "Documentaries"
    //
    //        segmentController.segmentControllers = [firstVC,secondVC,ThirdVC,forthVC,fifthVC]
    //
    //        segmentController.segmentTitleColor = Theme.colors.title!
    //        segmentController.selectedSegmentViewHeight = 3.0
    //        segmentController.segmentTitleFont = UIFont(name:"Montserrat-Medium", size: 16)!
    //        segmentController.delegate = self
    //        segmentController.selectedSegmentViewColor = Theme.colors.button_Background!
    //        segmentController.segmentViewHeight = 50
    //        addChild(segmentController)
    //        self.viewSegment.addSubview(segmentController.view)
    //        segmentController.view.frame = self.viewSegment.bounds
    //        segmentController.didMove(toParent: self)
    //    }
    
    func setUpPageMenu() {
        if pageMenu.view.isDescendant(of: self.view) {
            pageMenu.view.removeFromSuperview()
        }
        
        let font = UIFont(name:"Montserrat-Medium", size: 16)!
        
        //let bottomHairlineColor = Theme.colors.button_Background!
        let bottomHairlineColor = Theme.colors.green_008892
        let menuBackColor = UIColor.white
        let titleColor = UIColor.black
        let shadowColor = UIColor.lightGray
        
        // Customize menu (Optional)
        let parameters: [DJPageMenuOption] = [
            .scrollMenuBackgroundColor(menuBackColor),
            .viewBackgroundColor(UIColor.clear),
            .bottomMenuHairlineColor(UIColor.darkGray),
            .selectionIndicatorColor(bottomHairlineColor),
            .menuItemSeparatorColor(UIColor.clear),
            .selectedMenuItemLabelColor(bottomHairlineColor),
            .unselectedMenuItemLabelColor(titleColor),
            .menuItemHeight(50),
            .menuItemWidth(100),
            .menuItemFont(font),
            .addBottomMenuHairline(false),
            .addBottomMenuShadow(true),
            .bottomMenuShadowColor(shadowColor),
            .bounceEnabled(false),
            .menuItemWidthBasedOnTitleTextWidth(true)
        ]
        
        var controllers : [UIViewController] {
            get {
                // Initialize view controllers to display and place in array
                
                let firstVC:RecAudioBookVC = storyboard! .instantiateViewController(withIdentifier:"RecAudioBookVC") as! RecAudioBookVC
                firstVC.title = "Audio Books"
                
                let secondVC:RecPodCastsVC = storyboard! .instantiateViewController(withIdentifier:"RecPodCastsVC") as! RecPodCastsVC
                secondVC.title = "Podcasts"
                
                let thirdVC:RecApps = storyboard! .instantiateViewController(withIdentifier:"RecApps") as! RecApps
                thirdVC.title = "Apps"
                
                let forthVC:RecWebSite = storyboard! .instantiateViewController(withIdentifier:"RecWebSite") as! RecWebSite
                forthVC.title = "Websites"
                
                let fifthVC:RecDocuVC = storyboard! .instantiateViewController(withIdentifier:"RecDocuVC") as! RecDocuVC
                fifthVC.title = "Documentaries"
                
                //                firstVC.parentVC = self
                
                return [firstVC, secondVC, thirdVC, forthVC, fifthVC]
            }
        }
        
        // Initialize scroll menu
        self.pageMenu = DJPageMenuController.init(viewControllers: controllers, inView: self.viewSegment, inController: self, pageDelegate: self, pageMenuOptions: parameters)
        //        self.pageMenu.delegate = self
        //        self.pageMenu.collectionView(pageMenu.menuScrollView, didSelectItemAt: IndexPath(row: 0, section: 0))
    }
    
    func refreshData() {
        if let controller = self.selectedController {
            if controller.isKind(of: RecAudioBookVC.self) {
                if let aVC =  controller as? RecAudioBookVC {
                    // Segment Tracking
                    SegmentTracking.shared.trackEvent(name: "Resources Screen Viewed", traits: ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "", "resourceType":"Audio Books"], trackingType: .screen)
                    
                    aVC.collectionView.reloadData()
                    if ResourceVC.audioData.count == 0 {
                       aVC.callResourceListAPI(resourceID: ResourcesType.audioBooks.rawValue) {
                            aVC.setupData()
                       }
                    }
                }
            }
            else if controller.isKind(of: RecDocuVC.self) {
                if let aVC =  controller as? RecDocuVC {
                    // Segment Tracking
                    SegmentTracking.shared.trackEvent(name: "Resources Screen Viewed", traits: ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "", "resourceType":"Documentaries"], trackingType: .screen)
                    
                    aVC.tableView.reloadData()
                    if ResourceVC.documentariesData.count == 0 {
                       aVC.callResourceListAPI(resourceID: ResourcesType.documentaries.rawValue) {
                            aVC.setupData()
                    }
                    }
                }
            }
            else if controller.isKind(of: RecPodCastsVC.self) {
                if let aVC =  controller as? RecPodCastsVC {
                    // Segment Tracking
                    SegmentTracking.shared.trackEvent(name: "Resources Screen Viewed", traits: ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "", "resourceType":"Podcasts"], trackingType: .screen)
                    
                    aVC.tableView.reloadData()
                    if ResourceVC.podcastData.count == 0 {
                        aVC.callResourceListAPI(resourceID: ResourcesType.podcasts.rawValue) {
                            aVC.setupData()
                    }
                    }
                }
            }
            else if controller.isKind(of: RecWebSite.self) {
                if let aVC =  controller as? RecWebSite {
                    // Segment Tracking
                    SegmentTracking.shared.trackEvent(name: "Resources Screen Viewed", traits: ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "", "resourceType":"Websites"], trackingType: .screen)
                    
                    aVC.tableView.reloadData()
                    if ResourceVC.websiteData.count == 0 {
                        aVC.callResourceListAPI(resourceID: ResourcesType.websites.rawValue) {
                            aVC.setupData()
                        }
                    }
                }
            }
            else if controller.isKind(of: RecApps.self) {
                if let aVC =  controller as? RecApps {
                    // Segment Tracking
                    SegmentTracking.shared.trackEvent(name: "Resources Screen Viewed", traits: ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? "", "resourceType":"Apps"], trackingType: .screen)
                    
                    aVC.collectionView.reloadData()
                    if ResourceVC.appsData.count == 0 {
                        aVC.callResourceListAPI(resourceID: ResourcesType.apps.rawValue) {
                            aVC.setupData()
                        }
                    }
                }
            }
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterClicked(sender : UIButton) {
        viewFilter.isHidden.toggle()
        viewSegment.isUserInteractionEnabled = viewFilter.isHidden
    }
    
}


// MARK:- SJSegmentedViewControllerDelegate
extension ResourceVC: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        selectedSegment?.titleColor(Theme.colors.gray_7E7E7E)
        selectedSegment = segment
        segment?.titleColor(Theme.colors.green_008892)
        selectedController = controller
        self.refreshData()
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension ResourceVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResourceVC.arrayCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as! FeatureCell
        if ResourceVC.selectedCategory  == "" {
            if indexPath.row == 0 {
                cell.img.image = UIImage(named: "BlueArrow")
                cell.lblFeature?.textColor = hexStringToUIColor(hex: "005BAA")
                cell.img.isHidden = false
            }else {
                cell.img.isHidden = true
                cell.lblFeature?.textColor = hexStringToUIColor(hex: "999999")
            }
            
        }
        else if ResourceVC.selectedCategory == ResourceVC.arrayCategories[indexPath.row].CategoryName {
            cell.img.image = UIImage(named: "BlueArrow")
            cell.lblFeature?.textColor = hexStringToUIColor(hex: "005BAA")
            cell.img.isHidden = false
        }
        else {
            cell.img.isHidden = true
            cell.lblFeature?.textColor = hexStringToUIColor(hex: "999999")
        }
        
        cell.imgHeight.constant = 12
        cell.lblLeading.constant = 4
        cell.selectionStyle = .none
        cell.lblFeature?.text = ResourceVC.arrayCategories[indexPath.row].CategoryName
        cell.lblFeature?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as! FeatureCell
        //cell.lblFeature?.textColor = hexStringToUIColor(hex: "005BAA")
        //cell.img.image = UIImage(named: "BlueArrow")
        ResourceVC.selectedCategory = ResourceVC.arrayCategories[indexPath.row].CategoryName
        if ResourceVC.selectedCategory == ResourceVC.arrayCategories[indexPath.row].CategoryName {
            cell.img.image = UIImage(named: "BlueArrow")
            cell.lblFeature?.textColor = hexStringToUIColor(hex: "005BAA")
            cell.img.isHidden = false
        }
        
        // Segment Tracking
        var traits : [String : Any] = ["userId":"",
                      "resourceType":selectedResourcesType,
                      "masterCategory":ResourceVC.selectedCategory]
        
        let allMasterCategory : [String] = ResourceVC.arrayCategories.map { $0.CategoryName }.filter { $0 != "All" }
        traits["allMasterCategory"] = allMasterCategory
        
        SegmentTracking.shared.trackEvent(name: "Resources Filter Clicked", traits: traits, trackingType: .track)
        
        self.setupData()
        self.refreshData()
    }
    
}


// MARK:- DJPageMenuControllerDelegate
extension ResourceVC : DJPageMenuControllerDelegate {
    
    func didChangeIndex(pageIndex: Int, selectedController: UIViewController) {
        self.selectedController = selectedController
        self.refreshData()
    }
    
}
