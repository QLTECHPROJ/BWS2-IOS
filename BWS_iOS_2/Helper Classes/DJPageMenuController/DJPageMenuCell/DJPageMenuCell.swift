//
//  DJPageMenuCell.swift
//  DJPageMenu
//

import UIKit

class Menu: NSObject {
    var title = ""
    var width  : CGFloat = 0
    var selected = false
    
    override init() {
        super.init()
    }
    
    init(title : String, selected : Bool) {
        self.title = title
        self.selected = selected
    }
    
}

class DJPageMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSelectionIndicator : UILabel!
    @IBOutlet weak var lblSeparator : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

}
