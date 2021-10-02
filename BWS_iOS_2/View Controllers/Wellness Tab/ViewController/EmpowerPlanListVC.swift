//
//  EmpowerPlanListVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 01/10/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import MultiSlider

class EmpowerPlanListVC: BaseViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = ""
        lblSubTitle.text = ""
        
        collectionViewAudios.register(nibWithCellClass: AudioCollectionCell.self)
        collectionViewAudios.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionViewAudios.contentOffset = CGPoint(x: (self.collectionViewAudios.contentSize.width - 115) / 2, y: 0)
        }
        
        setupUI()
        
        // fetchPlans()
        
        //callManagePlanListAPI()
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        
        setupSlider()
        setStartButtonTitle()
       // setupPrivacyLabel()
        
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
        
        lblSubTitle.attributedText = dataModel.Desc.attributedString(alignment: .center, lineSpacing: 5)
        
        lblAccessAudioTitle.attributedText = Theme.strings.manage_plan_list_access_audios.attributedString(alignment: .center, lineSpacing: 5)
        
        lblIntroductorySubTitle.attributedText = Theme.strings.manage_plan_list_introductory_session.attributedString(alignment: .center, lineSpacing: 5)
        
        lblFeedbackTitle.attributedText = Theme.strings.manage_plan_list_testimonials.attributedString(alignment: .center, lineSpacing: 5)
        
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
        sliderProfiles.maximumValue = CGFloat(4)
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
    
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension EmpowerPlanListVC : UITableViewDataSource, UITableViewDelegate {
    
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
extension EmpowerPlanListVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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


extension EmpowerPlanListVC : iCarouselDelegate, iCarouselDataSource {
    
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
