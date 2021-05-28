//
//  UITableView+Extension.swift
//  LifePlatform
//

import UIKit


extension UITableView {
    
    func scrollToTop() {
        let section = self.numberOfSections
        if section < 0 {
            return
        }
        
        let row = self.numberOfRows(inSection: 0)
        if row < 0 {
            return
        }
        
        self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    func scrollToBottom() {
        let section = self.numberOfSections - 1
        if section < 0 {
            return
        }
        
        let row = self.numberOfRows(inSection: section) - 1
        if row < 0 {
            return
        }
        
        self.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: false)
    }
    
    func sizeHeaderToFit(tblheaderView: UIView?) {
        if let headerView = tblheaderView{
            
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            self.tableHeaderView = headerView
        }
    }
}
