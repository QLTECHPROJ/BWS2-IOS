//
//  ResourceDetailVC.swift
//  BWS
//
//  Created by Dhruvit on 30/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class ResourceDetailVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblScreenTitle : UILabel!
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    
    @IBOutlet weak var btnDiscover : UIButton!
    @IBOutlet weak var objStack : UIStackView!
    @IBOutlet weak var btnIOS : UIButton!
    
    
    // MARK:- VARIABLES
    var objDetail : ResourceListDataModel?
    var screenTitle = "Resource"
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        lblScreenTitle.text = screenTitle
        
        if let data = objDetail {
            
//            // Segment Tracking
//            let traits = ["userId":"",
//                          "resourceId":data.ID,
//                          "resourceName":data.title,
//                          "resourceType":screenTitle,
//                          "author":data.author,
//                          "resourceDesc":data.ResourceDesc,
//                          "masterCategory":data.master_category,
//                          "subCategory":data.sub_category,
//                          "resourceLink":data.resource_link_1]
//            SegmentTracking.shared.trackEvent(name: "Resource Details Viewed", traits: traits, trackingType: .screen)
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        if let data = objDetail {
            if let strUrl = data.Detailimage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
                imgView.sd_setImage(with: imgUrl, completed: nil)
            }
            
            lblTitle.text = data.title
            lblSubTitle.text = data.author
            lblDesc.text = data.ResourceDesc
            
            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 40
            paragraphStyle.lineHeightMultiple = 1.3

            let attrString = NSMutableAttributedString(string: data.ResourceDesc)
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

            lblDesc.attributedText = attrString
            
            switch data.type {
            case "WEBSITES":
                lblSubTitle.isHidden = true
                btnDiscover.isHidden = false
                objStack.isHidden = true
            case "APPS":
                lblSubTitle.isHidden = true
                btnDiscover.isHidden = true
                objStack.isHidden = false
                
                btnIOS.isHidden = !canOpenUrl(urlString: data.resource_link_2)
                
                if btnIOS.isHidden {
                    objStack.isHidden = true
                }
                
            default:
                lblSubTitle.isHidden = false
                btnDiscover.isHidden = false
                objStack.isHidden = true
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func discoverClicked(sender : UIButton) {
        if let data = objDetail {
            switch data.type {
            case "APPS":
                break
            default:
//                // Segment Tracking
//                let traits = ["userId":LoginDataModel.currentUser?.UserID ?? "",
//                              "resourceId":data.ID,
//                              "resourceName":data.title,
//                              "resourceType":screenTitle,
//                              "author":data.author,
//                              "resourceDesc":data.ResourceDesc,
//                              "masterCategory":data.master_category,
//                              "subCategory":data.sub_category,
//                              "resourceLink":data.resource_link_1]
//                SegmentTracking.shared.trackEvent(name: "Resource External Link Clicked", traits: traits, trackingType: .screen)
                
                openUrl(urlString: data.resource_link_1)
                break
            }
        }
    }
    
    @IBAction func androidClicked(sender : UIButton) {
        if let data = objDetail {
            switch data.type {
            case "APPS":
                openUrl(urlString: data.resource_link_1)
                break
            default:
                break
            }
        }
    }
    
    @IBAction func iOSClicked(sender : UIButton) {
        if let data = objDetail {
            switch data.type {
            case "APPS":
                // Segment Tracking
//                let traits = ["userId":LoginDataModel.currentUser?.UserID ?? "",
//                              "resourceId":data.ID,
//                              "resourceName":data.title,
//                              "resourceType":screenTitle,
//                              "author":data.author,
//                              "resourceDesc":data.ResourceDesc,
//                              "masterCategory":data.master_category,
//                              "subCategory":data.sub_category,
//                              "resourceLink":data.resource_link_2]
//                SegmentTracking.shared.trackEvent(name: "Resource External Link Clicked", traits: traits, trackingType: .screen)
                
                openUrl(urlString: data.resource_link_2)
                break
            default:
                break
            }
        }
    }
    
}
