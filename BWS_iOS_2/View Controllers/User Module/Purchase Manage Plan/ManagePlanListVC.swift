//
//  ManagePlanListVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import MultiSlider

class ManagePlanListVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblPrivacy: TTTAttributedLabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblAccessAudioTitle: UILabel!
    @IBOutlet weak var lblIntroductorySubTitle: UILabel!
    @IBOutlet weak var lblFeedbackTitle: UILabel!
    
    @IBOutlet weak var tblPlanFeatures: UITableView!
    @IBOutlet weak var tblPlanFeaturesHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var lblProfiles: UILabel!
    
    @IBOutlet weak var sliderProfiles: MultiSlider!
    @IBOutlet weak var tblPlanList: UITableView!
    @IBOutlet weak var tblPlanListHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblTrialText: UILabel!
    
    @IBOutlet weak var collectionViewAudios: UICollectionView!
    
    @IBOutlet weak var viewSessionHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var carouselView: iCarousel!
    
    @IBOutlet weak var tblFAQ: UITableView!
    @IBOutlet weak var tblFAQHeightConst: NSLayoutConstraint!
    
    
    // MARK:- VARIABLES
    var dataModel = PlanListDataModel()
    var PlanFeatures = [PlanFeatureModel]()
    var arrayPlans = [PlanDetailsModel]()
    var selectedPlanIndex = 0
    
    var profileCount = 2
    
    var arrayQuestions = [FAQDataModel]()
    var arrayAudios = [AudioDetailsDataModel]()
    var arrayVideos = [TestminialVideoDataModel]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.enrichPlanList)
        
        lblTitle.text = ""
        lblSubTitle.text = ""
        
        collectionViewAudios.register(nibWithCellClass: AudioCollectionCell.self)
        collectionViewAudios.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionViewAudios.contentOffset = CGPoint(x: (self.collectionViewAudios.contentSize.width - 115) / 2, y: 0)
        }
        
        setupUI()
        
        // fetchPlans()
        
        callManagePlanListAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        setupSlider()
        setStartButtonTitle()
        setupPrivacyLabel()
        
        viewSessionHeightConst.constant = 0
        self.view.layoutIfNeeded()
        
        tblPlanFeatures.register(nibWithCellClass: PlanFeaturesCell.self)
        tblPlanList.register(nibWithCellClass: PlanListCell.self)
        tblFAQ.register(nibWithCellClass: FAQCell.self)
        
        tblFAQ.rowHeight = UITableView.automaticDimension
        tblFAQ.estimatedRowHeight = 80
        tblFAQ.reloadData()
        
        self.tblFAQ.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        carouselView.dataSource = self
        carouselView.delegate = self
        carouselView.type = .linear
        carouselView.backgroundColor = UIColor.clear
        carouselView.isPagingEnabled = true
    }
    
    override func setupData() {
        PlanFeatures = dataModel.PlanFeatures
        arrayPlans = dataModel.Plan.filter { $0.ProfileCount == "\(profileCount)" }
        arrayAudios = dataModel.AudioFiles
        arrayVideos = dataModel.TestminialVideo
        arrayQuestions = dataModel.FAQs
        
        lblTitle.text = dataModel.Title
        
        let normalString = dataModel.Desc
        lblSubTitle.attributedText = normalString.attributedString(alignment: .center, lineSpacing: 10)
        
        let accessAudioString = "Access More Than 75 Audio Programs."
        lblAccessAudioTitle.attributedText = accessAudioString.attributedString(alignment: .center, lineSpacing: 10)
        
        let introductorySubTitleString = "Self reported date of 2173 clients before and after the introductory session"
        lblIntroductorySubTitle.attributedText = introductorySubTitleString.attributedString(alignment: .center, lineSpacing: 10)
        
        let feedbackTitleString = "SEE REAL TESTIMONIALS \nFROM REAL CUSTOMERS"
        lblFeedbackTitle.attributedText = feedbackTitleString.attributedString(alignment: .center, lineSpacing: 10)
        
        setStartButtonTitle()
        
        tblPlanFeaturesHeightConst.constant = CGFloat(PlanFeatures.count * 38)
        self.view.layoutIfNeeded()
        
        tblPlanListHeightConst.constant = CGFloat(arrayPlans.count * 110)
        self.view.layoutIfNeeded()
        
        tblPlanFeatures.reloadData()
        tblPlanList.reloadData()
        tblFAQ.reloadData()
        
        collectionViewAudios.reloadData()
        carouselView.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.tblFAQHeightConst.constant = newsize.height
                }
            }
        }
    }
    
    func setupSlider() {
        sliderProfiles.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        sliderProfiles.isContinuous = true
        sliderProfiles.minimumValue = CGFloat(1)
        sliderProfiles.maximumValue = CGFloat(5)
        sliderProfiles.snapStepSize = CGFloat(1)
        sliderProfiles.distanceBetweenThumbs = CGFloat(1)
        sliderProfiles.keepsDistanceBetweenThumbs = true
        sliderProfiles.value = [2]
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        
        if slider.value[0] < 2 {
            slider.value = [2]
        }
        
        // let roundedStepValue = round(sender.value / 1) * 1
        // sender.value = roundedStepValue
        // lblProfiles.text = "\(Int(roundedStepValue))"
        // print("Slider Value :- ",sender.value)
        
        lblProfiles.text = "\(Int(slider.value[0]))"
        profileCount = Int(slider.value[0])
        setupData()
    }
    
    func setStartButtonTitle() {
        if selectedPlanIndex < arrayPlans.count {
            let planText = "START AT " + "$" + arrayPlans[selectedPlanIndex].PlanAmount + " / " + arrayPlans[selectedPlanIndex].PlanTenure
            btnStart.setTitle(planText.uppercased(), for: .normal)
            btnStart.isEnabled = true
            lblTrialText.text = arrayPlans[selectedPlanIndex].FreeTrial
        } else {
            btnStart.isEnabled = false
        }
    }
    
    func setupPrivacyLabel() {
        lblPrivacy.numberOfLines = 0
        
        // By signing in you agree to our T&Cs, Privacy Policy and Disclaimer
        
        let strTC = "T&Cs"
        let strPrivacy = "Privacy Policy"
        let strDisclaimer = "Disclaimer"
        
        // By clicking on Register or Sign up you agree to our T&Cs, Privacy Policy & Disclaimer
        let string = "By clicking on Register or Sign up you \nagree to our \(strTC), \(strPrivacy) and \(strDisclaimer)"
        
        let nsString = string as NSString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        
        let fullAttributedString = NSAttributedString(string:string, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: Theme.colors.textColor.cgColor,
            NSAttributedString.Key.font: Theme.fonts.montserratFont(ofSize: 11, weight: .regular),
        ])
        
        lblPrivacy.textAlignment = .center
        lblPrivacy.attributedText = fullAttributedString
        
        let rangeTC = nsString.range(of: strTC)
        let rangePrivacy = nsString.range(of: strPrivacy)
        let rangeDisclaimer = nsString.range(of: strDisclaimer)
        
        let ppLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: Theme.colors.textColor,
            NSAttributedString.Key.underlineStyle.rawValue: NSUnderlineStyle.single.rawValue,
        ]
        
        lblPrivacy.activeLinkAttributes = [:]
        lblPrivacy.linkAttributes = ppLinkAttributes
        
        let urlTC = URL(string: "action://TC")!
        let urlPrivacy = URL(string: "action://Policy")!
        let urlDisclaimer = URL(string: "action://Disclaimer")!
        lblPrivacy.addLink(to: urlTC, with: rangeTC)
        lblPrivacy.addLink(to: urlPrivacy, with: rangePrivacy)
        lblPrivacy.addLink(to: urlDisclaimer, with: rangeDisclaimer)
        
        lblPrivacy.textColor = UIColor.black
        lblPrivacy.delegate = self
    }
    
    func fetchPlans() {
        let weeklyPlan = PlanDetailsModel()
        weeklyPlan.isSelected = true
        weeklyPlan.PlanInterval = "Weekly"
        weeklyPlan.SubName = "Lorem ipsum dolor sit"
        weeklyPlan.PlanAmount = "$9.99"
        weeklyPlan.PlanTenure = "Week"
        arrayPlans.append(weeklyPlan)
        
        let monthlyPlan = PlanDetailsModel()
        monthlyPlan.isSelected = false
        monthlyPlan.PlanInterval = "Monthly"
        monthlyPlan.SubName = "Lorem ipsum dolor sit"
        monthlyPlan.PlanAmount = "$29.99"
        monthlyPlan.PlanTenure = "Month"
        arrayPlans.append(monthlyPlan)
        
        let sixMonthlyPlan = PlanDetailsModel()
        sixMonthlyPlan.isSelected = false
        sixMonthlyPlan.PlanInterval = "Six-Monthly"
        sixMonthlyPlan.SubName = "Lorem ipsum dolor sit"
        sixMonthlyPlan.PlanAmount = "$149.99"
        sixMonthlyPlan.PlanTenure = "Six Month"
        sixMonthlyPlan.RecommendedFlag = "1"
        arrayPlans.append(sixMonthlyPlan)
        
        let yearlyPlan = PlanDetailsModel()
        yearlyPlan.isSelected = false
        yearlyPlan.PlanInterval = "Annual"
        yearlyPlan.SubName = "Lorem ipsum dolor sit"
        yearlyPlan.PlanAmount = "$249.99"
        yearlyPlan.PlanTenure = "Year"
        arrayPlans.append(yearlyPlan)
        
        setupData()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func closeClicked(sender : UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startClicked(sender : UIButton) {
        if selectedPlanIndex < arrayPlans.count {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: OrderSummaryVC.self)
            aVC.planData = arrayPlans[selectedPlanIndex]
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK:- TTTAttributedLabelDelegate
extension ManagePlanListVC : TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("link clicked")
        if url.absoluteString == "action://TC" {
            self.openUrl(urlString: "https://brainwellnessspa.com.au/terms-conditions")
        }
        else if url.absoluteString == "action://Policy" {
            self.openUrl(urlString: "https://brainwellnessspa.com.au/privacy-policy")
        }
        else if url.absoluteString == "action://Disclaimer" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
            aVC.strDesc = "The Brain Wellness App offers a unique, alternative and drug free method created by our founder Terri Bowman aimed to assist people encountering struggles in their daily lives, to find inner peace and overcome negative thoughts and emotions (the Brain Wellness App Method). \n\nThe Brain Wellness App Method is not a scientific method. \n\nThe testimonials of our clients speak for themselves and we are so proud of the incredible results they have achieved – we want to help you and are committed to assisting you find a way to live a better life. However, as with any service, we accept that it may not be right for everyone and that results may vary from client to client. Accordingly, we make no promises or representations that our service will work for you but we invite you to try it for yourself."
            aVC.strTitle = "Disclaimer"
            aVC.isOkButtonHidden = true
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: false, completion: nil)
        }
    }
    
    //    func attributedLabel(_ label: TTTAttributedLabel!, didLongPressLinkWith url: URL!, at point: CGPoint) {
    //        print("link long clicked")
    //    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension ManagePlanListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblPlanFeatures {
            return PlanFeatures.count
        } else if tableView == tblFAQ {
            return arrayQuestions.count
        } else if tableView == tblPlanList {
            return arrayPlans.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblPlanFeatures {
            let cell = tableView.dequeueReusableCell(withClass: PlanFeaturesCell.self)
            cell.configureCell(data: PlanFeatures[indexPath.row])
            return cell
        } else if tableView == tblFAQ {
            let cell = tableView.dequeueReusableCell(withClass: FAQCell.self)
            cell.configureCell(data: arrayQuestions[indexPath.row])
            return cell
        } else if tableView == tblPlanList {
            let cell = tableView.dequeueReusableCell(withClass: PlanListCell.self)
            let isSelected = (indexPath.row == selectedPlanIndex)
            cell.configureCell(data: arrayPlans[indexPath.row], isSelected: isSelected)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblFAQ {
            var isSelected = arrayQuestions[indexPath.row].isSelected
            
            for question in arrayQuestions {
                question.isSelected = false
            }
            
            isSelected.toggle()
            arrayQuestions[indexPath.row].isSelected = isSelected
            tableView.reloadData()
            
            setStartButtonTitle()
        } else if tableView == tblPlanList {
            selectedPlanIndex = indexPath.row
            tableView.reloadData()
            
            setStartButtonTitle()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblFAQ {
            // DispatchQueue.main.asyncAfter(deadline: .now()) {
            //     self.tblFAQHeightConst.constant = tableView.contentSize.height
            //     self.view.layoutIfNeeded()
            // }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblPlanFeatures {
            return 38
        } else if tableView == tblFAQ {
            return UITableView.automaticDimension
        } else if tableView == tblPlanList {
            return 110
        }
        
        return 0
    }
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension ManagePlanListVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayAudios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AudioCollectionCell.self, for: indexPath)
        cell.configureCell(audioData: arrayAudios[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 115
        let height = 145
        return CGSize(width: width, height: height)
    }
    
}


extension ManagePlanListVC : iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return arrayVideos.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let width : CGFloat = SCREEN_WIDTH - 32
        let height : CGFloat = 360
        let frame = CGRect(x: 0, y: 10, width: width, height: height)
        
        guard let cell = PlayVideoCell.instantiateFromNib() else {
            return UIView()
        }
        
        cell.configureCell(data: arrayVideos[index])
        cell.frame = frame
        return cell
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .wrap:
            return 1
        case .spacing:
            return value
        default:
            return value
        }
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        NotificationCenter.default.post(name: .pauseYouTubeVideo, object: nil)
    }
    
}
