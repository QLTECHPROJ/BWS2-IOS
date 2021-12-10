//
//  DassAssessmentResultVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 16/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

enum MembershipType : String {
    case enhance = "enhance"
    case empower = "empower"
}

class DassAssessmentResultVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var lblScoreTitle : UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    @IBOutlet weak var indexScoreView : UIView!
    @IBOutlet weak var indexScoreLabelView : UIView!
    
    @IBOutlet weak var lblScore : UILabel!
    @IBOutlet weak var lblScoreLevel : UILabel!
    
    
    // MARK:- VARIABLES
    var assessmentData : AssessmentDataModel?
    var isFromEdit = false
    var totalAngle: CGFloat = 180
    var rotation: CGFloat = -90
    
    var needleColor = UIColor.black
    var needleWidth: CGFloat = 15
    let needle = UIImageView()
    
    var scoreValue: Int = 0 {
        didSet {
            // figure out where the needle is, between 0 and 1
            let needlePosition = CGFloat(scoreValue) / 100
            
            // create a lerp from the start angle (rotation) through to the end angle (rotation + totalAngle)
            let lerpFrom = rotation
            let lerpTo = rotation + totalAngle
            
            // lerp from the start to the end position, based on the needle's position
            let needleRotation = lerpFrom + (lerpTo - lerpFrom) * needlePosition
            needle.transform = CGAffineTransform(rotationAngle: deg2rad(needleRotation))
        }
    }
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Segment Tracking
        let traits = ["wellnessScore":CoUserDataModel.currentUser?.indexScore ?? "",
                      "scoreLevel":CoUserDataModel.currentUser?.ScoreLevel ?? ""]
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.wellnessScore, traits: traits)
        
        // Clear Assessment Questions Data
        AssessmentDetailModel.current = nil
        UserDefaults.standard.removeObject(forKey: "ArrayPage")
        UserDefaults.standard.synchronize()
        
        callAssesmentGetDetailsAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        indexScoreLabelView.cornerRadius = indexScoreLabelView.frame.size.height / 2
        indexScoreLabelView.clipsToBounds = true
        indexScoreLabelView.isHidden = false
        
        setupUI()
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        needle.clipsToBounds = true
        needle.image = UIImage(named: "arrowIndexScore")
        needle.contentMode = .scaleAspectFit
        needle.backgroundColor = UIColor.clear // needleColor
        // needle.translatesAutoresizingMaskIntoConstraints = false
        
        // make the needle a third of our height
        needle.bounds = CGRect(x: 0, y: 0, width: needleWidth, height: (indexScoreView.bounds.height * 0.65))
        
        // align it so that it is positioned and rotated from the bottom center
        needle.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // now center the needle over our center point
        needle.center = CGPoint(x: indexScoreLabelView.frame.midX, y: indexScoreLabelView.frame.midY)
        indexScoreView.addSubview(needle)
    }
    
    override func setupData() {
        if let data = assessmentData {
            lblScreenTitle.text = data.MainTitle
            lblScoreTitle.text = data.SubTitle
            
            let colorCode = data.colorcode.replace(string: "#", replacement: "")
            lblScoreTitle.textColor = UIColor(hex: colorCode)
            
            lblTitle.attributedText = data.AssesmentTitle.attributedString(alignment: .center, lineSpacing: 5)
            // lblSubTitle.attributedText =  data.AssesmentContent.attributedString(alignment: .center, lineSpacing: 5)
            // lblSubTitle.attributedText =  data.AssesmentContent.htmlToAttributedString()
            lblSubTitle.attributedText =  data.AssesmentContent.htmlAttributed(family: Theme.fonts.MontserratLight, size: 14, color: Theme.colors.gray_313131)
            lblSubTitle.textAlignment = .center
        }
        
        scoreValue = 0
        lblScore.text = "\(scoreValue)"
        lblScoreLevel.text = "Normal"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1) {
                self.scoreValue = Int(CoUserDataModel.currentUser?.indexScore ?? "") ?? 0
                self.lblScore.text = "\(self.scoreValue)"
                self.lblScoreLevel.text = CoUserDataModel.currentUser?.ScoreLevel ?? ""
            }
        }
    }
    
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 205 // return number * .pi / 180
    }
    
    override func goNext() {
        if CoUserDataModel.currentUser?.isPlanPurchased == false {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:ManagePlanListVC.self)
            let navVC = UINavigationController(rootViewController: aVC)
            navVC.isNavigationBarHidden = true
            navVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(navVC, animated: false, completion: nil)
        } else {
            if let coUser = CoUserDataModel.currentUser {
                if coUser.isProfileCompleted == "0" {
                    redirectToProfileStep()
                } else if coUser.AvgSleepTime.trim.count == 0 || coUser.AreaOfFocus.count == 0 {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
                    self.navigationController?.pushViewController(aVC, animated: true)
                } else {
                    APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
                }
            }
        }
    }
    
    func handleNavigation() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ManageStartVC.self)
        aVC.strTitle = Theme.strings.you_are_doing_good_title
        aVC.strSubTitle = Theme.strings.you_are_doing_good_subtitle
        aVC.imageMain = UIImage(named: "manageStartWave")
        aVC.continueClicked = {
            self.goNext()
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func continueClicked(sender : UIButton) {
        if isFromEdit {
            self.navigationController?.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .refreshData, object: nil)
            return
        }
        
        if CoUserDataModel.currentUser?.isMainAccount == "0" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ThankYouVC.self)
            aVC.isCome = "UserDetail"
            self.navigationController?.pushViewController(aVC, animated: false)
        } else {
            self.goNext()
        }
    }
    
}
