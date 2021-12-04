//
//  TextQuestionVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 01/12/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class TextQuestionVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSectionCount : UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var lblQuestion : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var lblPlaceholder : UILabel!
    @IBOutlet weak var textView : UITextView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    
    
    // MARK:- VARIABLES
    var optionType : OptionTypes = .textfield
    var pageIndex = 0
    var sessionStepData : SessionListDataMainModel?
    var questionData : ProgressReportDataModel?
    var arrayQuestions = [ProgressReportQuestionModel]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        progressView.progress = 0
        
        setupData()
    }
    
    // MARK:- FUNCTIONS
    override func setupData() {
        lblTitle.text = questionData?.section_subtitle
        lblSectionCount.text = "Section \(questionData?.current_section ?? "") / \(questionData?.total_section ?? "")"
        
        arrayQuestions = questionData?.questions ?? []
        
        setupUI()
    }
    
    override func setupUI() {
        lblQuestion.text = arrayQuestions[pageIndex].question
        
        lblDescription.text = ""
        lblDescription.isHidden = true
        
        textView.text = arrayQuestions[pageIndex].selectedAnswer
        lblPlaceholder.isHidden = (textView.text.trim.count != 0)
        
        buttonEnableDisable()
        
        if arrayQuestions.count > 0 {
            if btnNext.isEnabled {
                progressView.progress = Float(pageIndex + 1) / Float(arrayQuestions.count)
            } else {
                progressView.progress = Float(pageIndex) / Float(arrayQuestions.count)
            }
        }
    }
    
    override func buttonEnableDisable() {
        btnPre.isHidden = pageIndex == 0
        
        btnNext.isEnabled = false
        
        if arrayQuestions.count > pageIndex {
            if arrayQuestions[pageIndex].selectedAnswer.trim.count > 0 {
                btnNext.isEnabled = true
            }
        }
    }
    
    func fetchNextForm() {
        callProgressReportStatus(data: sessionStepData) { (resposeData) in
            if let nextForm = resposeData?.next_form, nextForm.trim.count > 0 {
                callSessionProgressReportAPI(data: self.sessionStepData, formType: nextForm) { (questionData) in
                    self.handleProgressReportStatus(sessionStepData: self.sessionStepData, questionData: questionData)
                }
            } else {
                callSessionStepStatusUpdateAPI(sessionId: self.sessionStepData?.session_id ?? "", stepId: self.sessionStepData?.step_id ?? "")
                self.popViewController(viewController: SessionDetailVC.self)
            }
        }
    }
    
    func handleProgressReportStatus(sessionStepData : SessionListDataMainModel?, questionData : ProgressReportDataModel?) {
        guard let sessionStepData = sessionStepData else {
            return
        }
        
        guard let questionData = questionData else {
            return
        }
        
        print("option_type :- \(questionData.option_type)")
        
        if questionData.option_type.trim.count > 0 {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass:EmpowerStepVC.self)
            aVC.strSectionTitle = questionData.section_title
            aVC.strSubTitle = questionData.section_subtitle
            aVC.strDescription = questionData.section_description
            aVC.imageUrl = questionData.section_image
            aVC.color = Theme.colors.purple_9A86BB
            aVC.viewTapped = {
                if questionData.option_type == OptionTypes.textfield.rawValue {
                    let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: TextQuestionVC.self)
                    aVC.sessionStepData = sessionStepData
                    aVC.questionData = questionData
                    self.navigationController?.pushViewController(aVC, animated: false)
                } else {
                    let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: FiveOptionVC.self)
                    aVC.sessionStepData = sessionStepData
                    aVC.questionData = questionData
                    self.navigationController?.pushViewController(aVC, animated: false)
                }
            }
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: false, completion: nil)
        } else {
            self.popViewController(viewController: SessionDetailVC.self)
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func nextClicked(sender: UIButton) {
        self.view.endEditing(true)
        arrayQuestions[pageIndex].selectedAnswer = textView.text ?? ""
        
        if pageIndex < (arrayQuestions.count - 1) {
            pageIndex = pageIndex + 1
            print(pageIndex)
        } else {
            let arrayOldQuetion = questionData?.questions ?? []
            var arrayAnswers = [[String:Any]]()
            for question in arrayOldQuetion {
                let ansData = ["question_id":question.question_id,
                               "answer":question.selectedAnswer]
                arrayAnswers.append(ansData)
            }
            
            callSaveProgressReportAPI(arrayAnswers: arrayAnswers, data: self.sessionStepData, formType: self.questionData?.formType ?? "") { resposeData in
                self.fetchNextForm()
            }
        }
        
        setupUI()
    }
    
    @IBAction func prevClicked(sender: UIButton) {
        self.view.endEditing(true)
        arrayQuestions[pageIndex].selectedAnswer = textView.text ?? ""
        
        if pageIndex > 0 {
            pageIndex = pageIndex - 1
            print(pageIndex)
        }
        
        setupUI()
    }
    
}


// MARK:- UITextViewDelegate
extension TextQuestionVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("Text :- ",textView.text!)
        lblPlaceholder.isHidden = (textView.text.trim.count != 0)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        arrayQuestions[pageIndex].selectedAnswer = textView.text ?? ""
        setupUI()
    }
    
}
