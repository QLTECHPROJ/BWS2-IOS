//
//  SessionCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 14/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var imgCurrentSession: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var stackViewBooklet: UIStackView!
    @IBOutlet weak var imgCheckAudio: UIImageView!
    @IBOutlet weak var lblAudio: UILabel!
    @IBOutlet weak var imgCheckBooklet: UIImageView!
    @IBOutlet weak var lblBooklet: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var stackViewDate: UIStackView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var stackViewBeforeSession: UIStackView!
    @IBOutlet weak var lblBeforeSessionTitle: UILabel!
    @IBOutlet weak var lblBeforeSession: UILabel!
    
    @IBOutlet weak var stackViewAfterSession: UIStackView!
    @IBOutlet weak var lblAfterSessionTitle: UILabel!
    @IBOutlet weak var lblAfterSession: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblBeforeSessionTitle.text = "Before Session: "
        lblAfterSessionTitle.text = "After Session: "
        
        topView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 2)
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 2)
        
        topView.backgroundColor = Theme.colors.gray_999999
        bottomView.backgroundColor = Theme.colors.gray_999999
    }
    
    // Configure Cell
    func configureCell(data : SessionListDataMainModel) {
        
        lblTitle.text = data.title
        lblDesc.text = data.desc
        lblDate.text =  data.session_date
        lblTime.text =  data.session_time
        lblAudio.text = data.pre_session_audio_title
        lblBooklet.text = data.booklet_title
        lblBeforeSession.text = ""
        lblAfterSession.text = ""
        
        if let strUrl = data.status_img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgStatus.sd_setImage(with: imgUrl, completed: nil)
        }
        
        if data.user_session_status == "Completed" {
            imgCurrentSession.isHidden = true
            viewMain.layer.borderWidth = 0
            viewMain.layer.borderColor = UIColor.clear.cgColor
            stackViewBooklet.isHidden = true
            
            topView.backgroundColor = Theme.colors.purple_9A86BB
            bottomView.backgroundColor = Theme.colors.purple_9A86BB
        } else if data.user_session_status == "Inprogress" {
            viewMain.layer.borderWidth = 1
            viewMain.layer.borderColor = Theme.colors.purple_9A86BB.cgColor
            
            topView.backgroundColor = Theme.colors.purple_9A86BB
            bottomView.backgroundColor = Theme.colors.gray_999999
            
            imgCurrentSession.isHidden = false
            
            if data.pre_session_audio_status == "1" {
                imgCheckAudio.image = UIImage(named: "Check")
            } else {
                imgCheckAudio.image = UIImage(named: "Unckeck")
            }
            
            if data.booklet_status == "1" {
                imgCheckBooklet.image = UIImage(named: "Check")
            } else {
                imgCheckBooklet.image = UIImage(named: "Unckeck")
            }
        } else {
            viewMain.layer.borderWidth = 0
            viewMain.layer.borderColor = UIColor.clear.cgColor
            
            topView.backgroundColor = Theme.colors.gray_999999
            bottomView.backgroundColor = Theme.colors.gray_999999
            
            imgCurrentSession.isHidden = true
            stackViewDate.isHidden = true
            stackViewBooklet.isHidden = true
            stackViewBeforeSession.isHidden = true
            stackViewAfterSession.isHidden = true
        }
        
        var arrayAfterFeelings = [NSAttributedString]()
        var arrayBeforeFeelings = [NSAttributedString]()
        
        for (index,feeling) in data.before_session.enumerated() {
            var strFeeling = feeling.key
            if index < (data.before_session.count - 1) {
                strFeeling = feeling.key + ", "
            }
            
            let hexColor = UIColor(hex: "\(feeling.color.replacingOccurrences(of: "#", with: ""))")
            let myAttribute = [ NSAttributedString.Key.foregroundColor:hexColor,NSAttributedString.Key.font:UIFont(name: Theme.fonts.MontserratMedium, size: 10)]
            let myAttrString = NSAttributedString(string: strFeeling, attributes: myAttribute as [NSAttributedString.Key : Any])
            arrayBeforeFeelings.append(myAttrString)
        }
        
        lblBeforeSession.attributedText = arrayBeforeFeelings.joined()
        
        for (index,feeling) in data.after_session.enumerated() {
            var strFeeling = feeling.key
            if index < (data.after_session.count - 1) {
                strFeeling = feeling.key + ", "
            }
            
            let hexColor = UIColor(hex: "\(feeling.color.replacingOccurrences(of: "#", with: ""))")
            let myAttribute = [ NSAttributedString.Key.foregroundColor:hexColor,NSAttributedString.Key.font:UIFont(name: Theme.fonts.MontserratMedium, size: 10)]
            let myAttrString = NSAttributedString(string: strFeeling, attributes: myAttribute as [NSAttributedString.Key : Any])
            arrayAfterFeelings.append(myAttrString)
        }
        
        lblAfterSession.attributedText = arrayAfterFeelings.joined()
        
        lblBeforeSessionTitle.isHidden = lblBeforeSession.text?.trim.count == 0
        stackViewBeforeSession.isHidden = lblBeforeSession.text?.trim.count == 0
        
        lblAfterSessionTitle.isHidden = lblAfterSession.text?.trim.count == 0
        stackViewAfterSession.isHidden = lblAfterSession.text?.trim.count == 0
        
        if lblDate.text?.trim.count == 0 && lblTime.text?.trim.count == 0 {
            stackViewDate.isHidden = true
        } else {
            stackViewDate.isHidden = true
        }
        
        if lblAudio.text?.trim.count == 0 && lblBooklet.text?.trim.count == 0 {
            stackViewBooklet.isHidden = true
        } else {
            stackViewBooklet.isHidden = false
        }
    }
    
}

