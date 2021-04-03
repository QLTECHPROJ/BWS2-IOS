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
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblAccessAudioTitle: UILabel!
    @IBOutlet weak var lblIntroductorySubTitle: UILabel!
    @IBOutlet weak var lblFeedbackTitle: UILabel!
    @IBOutlet weak var lblFeedbackSubTitle: UILabel!
    
    @IBOutlet weak var lblProfiles: UILabel!
    
    @IBOutlet weak var sliderProfiles: MultiSlider!
    @IBOutlet weak var tblPlanList: UITableView!
    @IBOutlet weak var tblPlanListHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblTrialText: UILabel!
    
    @IBOutlet weak var collectionViewAudios: UICollectionView!
    
    @IBOutlet weak var carouselView: iCarousel!
    
    @IBOutlet weak var tblFAQ: UITableView!
    @IBOutlet weak var tblFAQHeightConst: NSLayoutConstraint!
    
    
    // MARK:- VARIABLES
    var arrayPlans = [PlanDataModel]()
    var selectedPlanIndex = 0
    var arrayQuestions = [FAQDataModel]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionViewAudios.register(nibWithCellClass: AudioCollectionCell.self)
        collectionViewAudios.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionViewAudios.contentOffset = CGPoint(x: (self.collectionViewAudios.contentSize.width - 115) / 2, y: 0)
        }
        
        fetchPlans()
        fetchQuestions()
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        let normalString = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut"
        lblSubTitle.attributedText = normalString.attributedString(alignment: .center, lineSpacing: 10)
        
        let accessAudioString = "Access More Than 65 Audio Programs."
        lblAccessAudioTitle.attributedText = accessAudioString.attributedString(alignment: .center, lineSpacing: 10)
        
        let introductorySubTitleString = "Self reported date of 2173 clients before and after the introductory session"
        lblIntroductorySubTitle.attributedText = introductorySubTitleString.attributedString(alignment: .center, lineSpacing: 10)
        
        let feedbackTitleString = "SEE REAL TESTIMONIALS \nFROM REAL CUSTOMERS"
        lblFeedbackTitle.attributedText = feedbackTitleString.attributedString(alignment: .center, lineSpacing: 10)
        
        let feedbackSubTitleString = "“I would pay it all over again. It was worth every penny. On a bad day I would be very agitated and very angry about everyday occurrences.”"
        lblFeedbackSubTitle.attributedText = feedbackSubTitleString.attributedString(alignment: .left, lineSpacing: 10)
        
        setupSlider()
        setStartButtonTitle()
        setupPrivacyLabel()
        
        tblPlanList.register(nibWithCellClass: PlanListCell.self)
        tblFAQ.register(nibWithCellClass: FAQCell.self)
        
        tblPlanListHeightConst.constant = CGFloat(arrayPlans.count * 110)
        self.view.layoutIfNeeded()
        tblPlanList.reloadData()
        
        tblFAQ.rowHeight = UITableView.automaticDimension
        tblFAQ.estimatedRowHeight = 80
        tblFAQ.reloadData()
        
        self.tblFAQ.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        carouselView.type = .linear
        carouselView.backgroundColor = UIColor.clear
        
        // DispatchQueue.main.asyncAfter(deadline: .now()) {
        //     self.tblFAQHeightConst.constant = self.tblFAQ.contentSize.height
        //     self.view.layoutIfNeeded()
        // }
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
        sliderProfiles.minimumValue = CGFloat(2)
        sliderProfiles.maximumValue = CGFloat(6)
        sliderProfiles.snapStepSize = CGFloat(1)
        sliderProfiles.distanceBetweenThumbs = CGFloat(1)
        sliderProfiles.keepsDistanceBetweenThumbs = true
        sliderProfiles.value = [sliderProfiles.minimumValue]
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        
        // let roundedStepValue = round(sender.value / 1) * 1
        // sender.value = roundedStepValue
        // lblProfiles.text = "\(Int(roundedStepValue))"
        // print("Slider Value :- ",sender.value)
        
        lblProfiles.text = "\(Int(slider.value[0]))"
    }
    
    func setStartButtonTitle() {
        if selectedPlanIndex < arrayPlans.count {
            let planText = "START AT " + arrayPlans[selectedPlanIndex].PlanPrice + " / " + arrayPlans[selectedPlanIndex].PlanPeriod
            btnStart.setTitle(planText.uppercased(), for: .normal)
            btnStart.isEnabled = true
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
        let weeklyPlan = PlanDataModel()
        weeklyPlan.isSelected = true
        weeklyPlan.PlanName = "Weekly"
        weeklyPlan.PlanDescription = "Lorem ipsum dolor sit"
        weeklyPlan.PlanPrice = "$9.99"
        weeklyPlan.PlanPeriod = "Week"
        arrayPlans.append(weeklyPlan)
        
        let monthlyPlan = PlanDataModel()
        monthlyPlan.isSelected = false
        monthlyPlan.PlanName = "Monthly"
        monthlyPlan.PlanDescription = "Lorem ipsum dolor sit"
        monthlyPlan.PlanPrice = "$29.99"
        monthlyPlan.PlanPeriod = "Month"
        arrayPlans.append(monthlyPlan)
        
        let sixMonthlyPlan = PlanDataModel()
        sixMonthlyPlan.isSelected = false
        sixMonthlyPlan.PlanName = "Six-Monthly"
        sixMonthlyPlan.PlanDescription = "Lorem ipsum dolor sit"
        sixMonthlyPlan.PlanPrice = "$149.99"
        sixMonthlyPlan.PlanPeriod = "Six Month"
        sixMonthlyPlan.Popular = "1"
        arrayPlans.append(sixMonthlyPlan)
        
        let yearlyPlan = PlanDataModel()
        yearlyPlan.isSelected = false
        yearlyPlan.PlanName = "Annual"
        yearlyPlan.PlanDescription = "Lorem ipsum dolor sit"
        yearlyPlan.PlanPrice = "$249.99"
        yearlyPlan.PlanPeriod = "Year"
        arrayPlans.append(yearlyPlan)
    }
    
    func fetchQuestions() {
        arrayQuestions.removeAll()
        
        for i in 1...10 {
            let question = FAQDataModel()
            if i % 3 == 0 {
                question.Question = "\(i) - How can I cancel if I need to?"
                question.Answer = "\(i) - How do I purchase a subscription?"
            }
            else if i % 2 == 0 {
                question.Question = "\(i) - Is there a free trial?"
                question.Answer = "\(i) - Yes. Every plan comes with a 30-day free trial option"
            }
            else {
                question.Question = "\(i) - What are the benefits of signing up for the Membership Program"
                question.Answer = "\(i) - What's the best way to use the Membership? Where do I start?"
            }
            arrayQuestions.append(question)
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func closeClicked(sender : UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startClicked(sender : UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: OrderSummaryVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
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
        if tableView == tblFAQ {
            return arrayQuestions.count
        } else {
            return arrayPlans.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblFAQ {
            let cell = tableView.dequeueReusableCell(withClass: FAQCell.self)
            cell.configureCell(data: arrayQuestions[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: PlanListCell.self)
            let isSelected = (indexPath.row == selectedPlanIndex)
            cell.configureCell(data: arrayPlans[indexPath.row], isSelected: isSelected)
            return cell
        }
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
        }
        else {
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
        if tableView == tblFAQ {
            return UITableView.automaticDimension
        }
        else {
            return 110
        }
    }
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension ManagePlanListVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AudioCollectionCell.self, for: indexPath)
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
        return 5
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let width : CGFloat = SCREEN_WIDTH - 52
        let height : CGFloat = 180
        let cell = PlayVideoCell()
        let view = cell.loadViewFromNib()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .wrap:
            return 1
        case .spacing:
            return value * 1.05
        default:
            return value
        }
    }
    
}
