//
//  TimeView.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 03/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class TimeView: UIView {
     
    @IBOutlet weak var lblTitle: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commitInit()
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed("TimeView", owner: nil, options: nil)
        self.frame = self.bounds
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(self)
    }
}
