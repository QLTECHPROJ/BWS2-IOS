//
//  AssessmentVC.swift
//  DemoAssessment
//
//  Created by Mac Mini on 02/04/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit

class AssessmentVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var cvHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewheight: NSLayoutConstraint!
    
    
    // MARK:- VARIABLES
    var isFromEdit = false
    var pageIndex = 0
    var dicAssessment:AssessmentDetailModel?
    var arrayQuetion = [AssessmentQueModel]()
    var arrNewSection = [[AssessmentQueModel]]()
    var arrPage = [Int]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.assessmentForm)
        
        lbl1.text = ""
        lbl2.text = ""
        lbl3.text = ""
        lbl4.text = ""
        
        progressView.progress = 0
        
        collectionView.register(UINib(nibName:"SubColCell", bundle: nil), forCellWithReuseIdentifier:"SubColCell")
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        callAssessmentAPI()
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        lblTitle.text = dicAssessment?.Toptitle
        lblSubTitle.text = dicAssessment?.Subtitle
        arrayQuetion = dicAssessment?.Questions ?? []
        
        let arrayOldQuetion = AssessmentDetailModel.current?.Questions ?? []
        
        for question in arrayQuetion {
            for oldQuestion in arrayOldQuetion {
                if question.Question == oldQuestion.Question {
                    question.selectedAnswer = oldQuestion.selectedAnswer
                }
            }
        }
        
        if let arrayContent = dicAssessment?.Content, arrayContent.count > 3 {
            lbl1.text = arrayContent[0].condition
            lbl2.text = arrayContent[1].condition
            lbl3.text = arrayContent[2].condition
            lbl4.text = arrayContent[3].condition
        }
        
        for question in arrayQuetion {
            let ansComponents = question.Answer.components(separatedBy: "|")
            let total = ansComponents.distance(from:Int(ansComponents[0]) ?? 0, to:Int(ansComponents[1]) ?? 10)
            question.answers.removeAll()
            for i in 0...total {
                question.answers.append(i)
            }
        }
        
        arrNewSection = arrayQuetion.chunked(into: 2)
        
        //jump into last index of assessmeny
        let page = UserDefaults.standard.array(forKey: "ArrayPage") as? [Int]
        if page == nil {
            pageIndex = 0
            arrPage.append(pageIndex)
        } else {
            let max = page?.max()
            pageIndex = max!
        }
        
        setupUI()
        
        collectionView.reloadData()
    }
    
    override func setupUI() {
        collectionView.reloadData()
        buttonEnableDisable()
        
        if arrNewSection.count > 0 {
            if btnNext.isEnabled {
                progressView.progress = Float(pageIndex + 1) / Float(arrNewSection.count)
            } else {
                progressView.progress = Float(pageIndex) / Float(arrNewSection.count)
            }
        }
    }
    
    override func buttonEnableDisable() {
        btnPre.isHidden = pageIndex == 0
        
        if arrNewSection.count > 0 {
            let arrData = arrNewSection[pageIndex]
            if arrData.count > 1 {
                if arrData[0].selectedAnswer == -1 || arrData[1].selectedAnswer == -1 {
                    btnNext.isEnabled = false
                } else {
                    btnNext.isEnabled = true
                }
            }
            
            //scrollview height manage with collectionview and mainView
            cvHeight.constant = CGFloat(arrNewSection[pageIndex].count * 270)
            mainViewheight.constant = CGFloat(arrNewSection[pageIndex].count * 270 + 400)
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedNext(_ sender: UIButton) {
        if pageIndex < (arrNewSection.count - 1) {
            pageIndex = pageIndex + 1
            print(pageIndex)
            collectionView.reloadData()
        } else {
            let arrayOldQuetion = AssessmentDetailModel.current?.Questions ?? []
            var arrAns = [String]()
            for question in arrayOldQuetion {
                arrAns.append("\(question.selectedAnswer)")
            }
            
            print(arrAns)
            let jsonString = convertIntoJSONString(arrayObject: arrAns) ?? ""
            callSaveAnsAssessmentAPI(arrAns:jsonString)
        }
        
        setupUI()
    }
    
    @IBAction func onTappedPre(_ sender: UIButton) {
        if pageIndex > 0 {
            pageIndex = pageIndex - 1
            print(pageIndex)
            collectionView.reloadData()
        }
        
        setupUI()
    }
    
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AssessmentVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if arrNewSection.count > 0 {
            return arrNewSection[pageIndex].count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNewSection[pageIndex][section].answers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"SubColCell", for: indexPath) as! SubColCell
        
        let answer = arrNewSection[pageIndex][indexPath.section].answers[indexPath.item]
        let selectedAnswer = arrNewSection[pageIndex][indexPath.section].selectedAnswer
        
        cell.lblRight.text = "\(answer)"
        cell.lblRight.font = Theme.fonts.montserratFont(ofSize: 18, weight: .regular)
        cell.lblTop.isHidden = true
        cell.lblRight.isHidden = false
        
        if selectedAnswer == answer {
            cell.btn.setImage(UIImage(named: "radio1"), for: .normal)
        } else {
            cell.btn.setImage(UIImage(named: "radio"), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        arrNewSection[pageIndex][indexPath.section].selectedAnswer = arrNewSection[pageIndex][indexPath.section].answers[indexPath.row]
        collectionView.reloadData()
        
        let question = arrNewSection[pageIndex][indexPath.section].Question
        let selectedAnswer = arrNewSection[pageIndex][indexPath.section].selectedAnswer
        
        for newQuestion in arrayQuetion {
            if newQuestion.Question == question {
                newQuestion.selectedAnswer = selectedAnswer
            }
        }
        
        dicAssessment?.Questions = arrayQuetion
        AssessmentDetailModel.current = dicAssessment
        
        setupUI()
        
        //userdefault for page index
        if arrPage.contains(pageIndex) {
            print(arrPage)
        } else {
            let page = UserDefaults.standard.array(forKey: "ArrayPage") as? [Int]
            if (page?.contains(pageIndex))! {
                arrPage = page ?? []
                print(arrPage)
            } else {
                arrPage.append(pageIndex)
            }
        }
        
        UserDefaults.standard.set(arrPage, forKey: "ArrayPage")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            sectionHeader.label.text = arrNewSection[pageIndex][indexPath.section].Question
            sectionHeader.label.textColor = .black
            return sectionHeader
        } else {
            // No footer in this case but can add option for that
            return UICollectionReusableView()
        }
    }
}

class SectionHeader: UICollectionReusableView {
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = Theme.fonts.montserratFont(ofSize: 18, weight: .bold)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
