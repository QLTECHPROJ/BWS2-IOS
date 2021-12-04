//
//  SessionBannerCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 15/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionBannerCell: UITableViewCell {
    
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var lblSessionTitle: UILabel!
    @IBOutlet weak var lblSessionDesc: UILabel!
    @IBOutlet weak var lblSession: UILabel!
    @IBOutlet weak var lblDescProgress: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var imgProgress: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : SessionListDataModel?) {
        guard let data = data else {
            return
        }
        
        lblSession.text = data.session_title
        lblDescProgress.text = data.session_progress_text
        lblProgress.text = data.session_progress
        lblSessionTitle.text = data.session_short_desc
        lblSessionDesc.text = data.session_desc
        
        let hexColor = data.session_progress_color.replacingOccurrences(of: "#", with: "")
        viewProgress.backgroundColor = UIColor(hex: hexColor)
        
        if let imgUrl = URL(string: data.session_progress_img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imgProgress.sd_setImage(with: imgUrl, completed: nil)
        }
    }
    
}
