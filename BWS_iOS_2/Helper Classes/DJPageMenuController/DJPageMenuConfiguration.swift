//
//  DJPageMenuConfiguration.swift
//  DJPageMenu
//

import Foundation
import UIKit

public enum DJPageMenuOption {
    
    case scrollMenuBackgroundColor(UIColor)
    case viewBackgroundColor(UIColor)
    case bottomMenuHairlineColor(UIColor)
    case selectionIndicatorColor(UIColor)
    case menuItemSeparatorColor(UIColor)
    case menuItemHeight(CGFloat)
    case menuItemWidth(CGFloat)
    case selectedMenuItemLabelColor(UIColor)
    case unselectedMenuItemLabelColor(UIColor)
    case menuItemFont(UIFont)
    case addBottomMenuHairline(Bool)
    case addBottomMenuShadow(Bool)
    case bottomMenuShadowColor(UIColor)
    case bounceEnabled(Bool)
    case menuItemWidthBasedOnTitleTextWidth(Bool)
    
}

public class DJPageMenuConfiguration {
    
    open var scrollMenuBackgroundColor : UIColor = UIColor.white
    open var viewBackgroundColor : UIColor = UIColor.white
    open var bottomMenuHairlineColor : UIColor = UIColor.white
    open var selectionIndicatorColor : UIColor = UIColor.darkGray
    open var menuItemSeparatorColor : UIColor = UIColor.darkGray
    open var menuItemHeight : CGFloat = 50
    open var menuItemWidth : CGFloat = 100
    open var selectedMenuItemLabelColor : UIColor = UIColor.black
    open var unselectedMenuItemLabelColor : UIColor = UIColor.lightGray
    open var menuItemFont : UIFont = UIFont.systemFont(ofSize: 15)
    open var addBottomMenuHairline : Bool = false
    open var addBottomMenuShadow : Bool = false
    open var bottomMenuShadowColor : UIColor = UIColor.darkGray
    open var bounceEnabled : Bool = false
    open var menuItemWidthBasedOnTitleTextWidth : Bool = false
    
    public init() {
        
    }
    
}

extension DJPageMenuController {
    
    func configurePageMenu(options: [DJPageMenuOption]) {
        for option in options {
            switch (option) {
            case let .scrollMenuBackgroundColor(value):
                configuration.scrollMenuBackgroundColor = value
            case let .viewBackgroundColor(value):
                configuration.viewBackgroundColor = value
            case let .bottomMenuHairlineColor(value):
                configuration.bottomMenuHairlineColor = value
            case let .selectionIndicatorColor(value):
                configuration.selectionIndicatorColor = value
            case let .menuItemSeparatorColor(value):
                configuration.menuItemSeparatorColor = value
            case let .menuItemHeight(value):
                configuration.menuItemHeight = value
            case let .selectedMenuItemLabelColor(value):
                configuration.selectedMenuItemLabelColor = value
            case let .unselectedMenuItemLabelColor(value):
                configuration.unselectedMenuItemLabelColor = value
            case let .menuItemFont(value):
                configuration.menuItemFont = value
            case let .menuItemWidth(value):
                configuration.menuItemWidth = value
            case let .addBottomMenuHairline(value):
                configuration.addBottomMenuHairline = value
            case let .addBottomMenuShadow(value):
                configuration.addBottomMenuShadow = value
            case let .bottomMenuShadowColor(value):
                configuration.bottomMenuShadowColor = value
            case let .bounceEnabled(value):
                configuration.bounceEnabled = value
            case let .menuItemWidthBasedOnTitleTextWidth(value):
                configuration.menuItemWidthBasedOnTitleTextWidth = value
            }
        }
    }
        
}
