//
//  DJPageMenuController.swift
//  DJPageMenu
//

import UIKit

public protocol DJPageMenuControllerDelegate {
    func didChangeIndex(pageIndex : Int, selectedController : UIViewController)
}

open class DJPageMenuController: UIViewController {
    
    // MARK: - Configuration
    var configuration = DJPageMenuConfiguration()
    
    
    // MARK:- VARIABLES
    var menuArray = [Menu]()
    
    var menuScrollView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let controllerScrollView = UIScrollView()
    var controllerArray = [UIViewController]()
    
    var delegate : DJPageMenuControllerDelegate?
    
    
    // MARK:- FUNCTIONS
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public init(viewControllers: [UIViewController], in containerView: UIView, pageMenuOptions: [DJPageMenuOption]?) {
        super.init(nibName: nil, bundle: nil)
        
        if let options = pageMenuOptions {
            configurePageMenu(options: options)
        }
        
        controllerArray = viewControllers
        
        //Setup storyboard
        self.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        containerView.addSubview(self.view)
        
        //Build UI
        setUpUserInterface()
    }
    
    public init(viewControllers: [UIViewController], inView containerView: UIView, inController controller: UIViewController, pageDelegate : DJPageMenuControllerDelegate? , pageMenuOptions: [DJPageMenuOption]?) {
        super.init(nibName: nil, bundle: nil)
        
        if let options = pageMenuOptions {
            configurePageMenu(options: options)
        }
        
        controllerArray = viewControllers
        
        //Setup storyboard
        controller.addChild(self)
        containerView.addSubview(self.view)
        self.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        didMove(toParent: controller)
        
        self.delegate = pageDelegate
        
        //Build UI
        setUpUserInterface()
    }
    
    public init(viewControllers: [UIViewController], in controller: UIViewController, pageMenuOptions: [DJPageMenuOption]?) {
        super.init(nibName: nil, bundle: nil)
        
        if let options = pageMenuOptions {
            configurePageMenu(options: options)
        }
        
        controllerArray = viewControllers
        
        //Setup storyboard
        self.view.frame = CGRect(x: 0, y: 0, width: controller.view.frame.size.width, height: controller.view.frame.size.height)
        controller.addChild(self)
        controller.view.addSubview(self.view)
        didMove(toParent: controller)
        
        
        //Build UI
        setUpUserInterface()
    }
    
    public init(viewControllers: [UIViewController], in controller: UIViewController, pageMenuConfiguration: DJPageMenuConfiguration?) {
        super.init(nibName: nil, bundle: nil)
        
        if let newConfiguration = pageMenuConfiguration {
            self.configuration = newConfiguration
        }
        
        controllerArray = viewControllers
        
        //Setup storyboard
        self.view.frame = CGRect(x: 0, y: 0, width: controller.view.frame.size.width, height: controller.view.frame.size.height)
        controller.addChild(self)
        controller.view.addSubview(self.view)
        didMove(toParent: controller)
        
        
        //Build UI
        setUpUserInterface()
    }
    
    func setUpUserInterface() {
        let viewsDictionary = ["menuScrollView":menuScrollView, "controllerScrollView":controllerScrollView]
        
        // Set up controller scroll view
        controllerScrollView.isPagingEnabled = true
        controllerScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        controllerScrollView.frame = CGRect(x: 0.0, y: configuration.menuItemHeight, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(controllerScrollView)
        
        let controllerScrollView_constraint_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[controllerScrollView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let controllerScrollView_constraint_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:|[controllerScrollView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        self.view.addConstraints(controllerScrollView_constraint_H)
        self.view.addConstraints(controllerScrollView_constraint_V)
        
        // Set up menu scroll view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let menuFrame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: configuration.menuItemHeight)
        menuScrollView = UICollectionView(frame: menuFrame, collectionViewLayout: layout)
        menuScrollView.register(UINib(nibName: "DJPageMenuCell", bundle: nil), forCellWithReuseIdentifier: "DJPageMenuCell")
        
        menuScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(menuScrollView)
        
        if configuration.addBottomMenuShadow {
            menuScrollView.dropShadow(color: configuration.bottomMenuShadowColor, opacity: 0.5, offSet: CGSize(width: 1, height: 3), radius: 2)
        }
        
        //        let menuScrollView_constraint_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuScrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        //        let menuScrollView_constraint_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[menuScrollView(\(self.menuItemHeight))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        //
        //        self.view.addConstraints(menuScrollView_constraint_H)
        //        self.view.addConstraints(menuScrollView_constraint_V)
        
        // Add hairline to menu scroll view
        if configuration.addBottomMenuHairline {
            let menuBottomHairline : UIView = UIView()
            menuBottomHairline.backgroundColor = configuration.bottomMenuHairlineColor
            menuBottomHairline.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(menuBottomHairline)
            
            let menuBottomHairline_constraint_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuBottomHairline]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
            let menuBottomHairline_constraint_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(configuration.menuItemHeight)-[menuBottomHairline(0.5)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
            
            self.view.addConstraints(menuBottomHairline_constraint_H)
            self.view.addConstraints(menuBottomHairline_constraint_V)
        }
        
        // Disable scroll bars
        menuScrollView.showsHorizontalScrollIndicator = false
        menuScrollView.showsVerticalScrollIndicator = false
        controllerScrollView.showsHorizontalScrollIndicator = false
        controllerScrollView.showsVerticalScrollIndicator = false
        
        // Set delegate for controller scroll view
        menuScrollView.dataSource = self
        menuScrollView.delegate = self
        
        controllerScrollView.delegate = self
        
        // Configure controller scroll view content size
        controllerScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(controllerArray.count), height: 0.0)
        
        var index = 0
        
        for controller in controllerArray {
            // Add first two controllers to scrollview and as child view controller
            if index == 0 {
                // Add first two controllers to scrollview and as child view controller
//                controller.viewWillAppear(true)
                addPageAtIndex(0)
                delegate?.didChangeIndex(pageIndex: 0, selectedController: controllerArray[0])
//                controller.viewDidAppear(true)
            }
            
            let menuModel = Menu()
            
            if let controllerTitle = controller.title {
                var newMenuWidth : CGFloat = 0.0
                
                newMenuWidth = (controllerTitle as NSString).size(withAttributes: [NSAttributedString.Key.font : configuration.menuItemFont]).width + 50
                
                menuModel.title = controllerTitle
                menuModel.width = newMenuWidth
                
                if index == 0 {
                    menuModel.selected = true
                }
                
                menuArray.append(menuModel)
                if configuration.menuItemWidth < newMenuWidth {
                    configuration.menuItemWidth = newMenuWidth
                }
            }
            else {
                let menuTitle = "Menu \(index)"
                var newMenuWidth : CGFloat = 0.0
                
                newMenuWidth = (menuTitle as NSString).size(withAttributes: [NSAttributedString.Key.font : configuration.menuItemFont]).width + 50
                
                menuModel.title = menuTitle
                menuModel.width = newMenuWidth
                
                if index == 0 {
                    menuModel.selected = true
                }
                
                menuArray.append(menuModel)
                if configuration.menuItemWidth < newMenuWidth {
                    configuration.menuItemWidth = newMenuWidth
                }
            }
            
            index += 1
        }
        
        var totalWidth : CGFloat = 0
        
        if configuration.menuItemWidthBasedOnTitleTextWidth {
            for menu in menuArray {
                totalWidth = totalWidth + menu.width
            }
        }
        else {
            totalWidth = configuration.menuItemWidth * CGFloat(menuArray.count)
        }
        
        if totalWidth < menuScrollView.frame.width {
            let newMenuWidth = menuScrollView.frame.width / CGFloat(menuArray.count)
            
            for menu in menuArray {
                menu.width = newMenuWidth
            }
        }
        
        menuScrollView.reloadData()
        
        menuScrollView.bounces = configuration.bounceEnabled
        controllerScrollView.bounces = configuration.bounceEnabled
        
        menuScrollView.backgroundColor = configuration.scrollMenuBackgroundColor
        controllerScrollView.backgroundColor = configuration.viewBackgroundColor
    }
    
    // MARK: - Remove/Add Page
    func addPageAtIndex(_ index : Int) {
        // Call didMoveToPage delegate function
        let newVC = controllerArray[index]
        
        newVC.willMove(toParent: self)
        
        newVC.view.frame = CGRect(x: self.view.frame.width * CGFloat(index), y: configuration.menuItemHeight, width: self.view.frame.width, height: self.view.frame.height - configuration.menuItemHeight)
        
        self.addChild(newVC)
        self.controllerScrollView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
    }
    
    func removePageAtIndex(_ index : Int) {
        let oldVC = controllerArray[index]
        
        oldVC.willMove(toParent: nil)
        
        oldVC.view.removeFromSuperview()
        oldVC.removeFromParent()
        
        oldVC.didMove(toParent: nil)
    }
    
}


// MARK:- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension DJPageMenuController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DJPageMenuCell", for: indexPath) as! DJPageMenuCell
        
        let menu = menuArray[indexPath.row]
        
        cell.lblTitle.font = configuration.menuItemFont
        cell.lblTitle.text = menu.title
        cell.lblSelectionIndicator.isHidden = !menu.selected
        
        if menu.selected {
            cell.lblTitle.textColor = configuration.selectedMenuItemLabelColor
        }
        else {
            cell.lblTitle.textColor = configuration.unselectedMenuItemLabelColor
        }
        
        cell.lblSelectionIndicator.backgroundColor = configuration.selectionIndicatorColor
        cell.lblSeparator.backgroundColor = configuration.menuItemSeparatorColor
        
        if indexPath.row == menuArray.count - 1 {
            cell.lblSeparator.isHidden = true
        }
        else {
            cell.lblSeparator.isHidden = false
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if configuration.menuItemWidthBasedOnTitleTextWidth {
            return CGSize(width: menuArray[indexPath.row].width, height: configuration.menuItemHeight)
        }
        
        return CGSize(width: configuration.menuItemWidth, height: configuration.menuItemHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for menu in menuArray {
            menu.selected = false
        }
        
        if indexPath.row < controllerArray.count {
            if controllerArray[indexPath.row].view.isDescendant(of: controllerScrollView) == false {
                addPageAtIndex(indexPath.row)
            }
        }
        
        menuArray[indexPath.row].selected = true
        collectionView.reloadData()
        
        let newContentX : Int = Int(controllerScrollView.frame.width) * indexPath.row
        
        if newContentX < Int(controllerScrollView.contentSize.width) {
            controllerScrollView.contentOffset = CGPoint(x: newContentX, y: 0)
        }
        
        menuScrollView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        
        self.delegate?.didChangeIndex(pageIndex: indexPath.row, selectedController: controllerArray[indexPath.row])
    }
    
}


// MARK:- UIScrollViewDelegate
extension DJPageMenuController : UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == controllerScrollView {
            let controllerIndex : Int = Int(scrollView.contentOffset.x / self.view.frame.width)
            let menuIndex : Int = Int(scrollView.contentOffset.x / self.view.frame.width)
            print("controllerIndex :- ",controllerIndex)
            print("menuIndex :- ",menuIndex)
            
            if controllerIndex < controllerArray.count {
                if controllerArray[controllerIndex].view.isDescendant(of: controllerScrollView) == false {
                    addPageAtIndex(controllerIndex)
                }
            }
            
            if menuIndex < controllerIndex {
                menuScrollView.scrollToItem(at: IndexPath(row: controllerIndex, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
                menuScrollView.selectItem(at: IndexPath(row: controllerIndex, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            }
            else {
                menuScrollView.scrollToItem(at: IndexPath(row: controllerIndex, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
                menuScrollView.selectItem(at: IndexPath(row: controllerIndex, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            }
            
            for menu in menuArray {
                menu.selected = false
            }
            
            if controllerIndex < menuArray.count {
                menuArray[controllerIndex].selected = true
            }
            
            menuScrollView.reloadData()
            
            self.delegate?.didChangeIndex(pageIndex: menuIndex, selectedController: controllerArray[controllerIndex])
        }
    }
    
}
