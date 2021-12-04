//
//  FiveOptionVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

enum OptionTypes : String {
    case textfield = "textfield"
    case twooptions = "twooptions"
    case fiveoptions = "fiveoptions"
    case tenoptions = "tenoptions"
}

class FiveOptionVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSectionCount : UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    
    
    // MARK:- VARIABLES
    var optionType : OptionTypes = .twooptions
    var pageIndex = 0
    var sessionStepData : SessionListDataMainModel?
    var questionData : ProgressReportDataModel?
    var arrayQuestions = [ProgressReportQuestionModel]()
    var arrayNewQuestions = [[ProgressReportQuestionModel]]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        progressView.progress = 0
        
        tableView.register(nibWithCellClass: TitleDescriptionCell.self)
        tableView.register(nibWithCellClass: TwoOptionTableViewCell.self)
        tableView.register(nibWithCellClass: FiveOptionTableViewCell.self)
        tableView.register(nibWithCellClass: TenOptionTableViewCell.self)
        
        setupData()
    }
    
    // MARK:- FUNCTIONS
    override func setupData() {
        lblTitle.text = questionData?.section_subtitle
        lblSectionCount.text = "Section \(questionData?.current_section ?? "") / \(questionData?.total_section ?? "")"
        
        optionType = OptionTypes(rawValue: questionData?.option_type ?? "") ?? .twooptions
        
        let chunkSize = Int(questionData?.chunk_size ?? "1") ?? 1
        
        arrayQuestions = questionData?.questions ?? []
        arrayNewQuestions = arrayQuestions.chunked(into: chunkSize)
        
        tableView.reloadData()
        
        setupUI()
    }
    
    override func setupUI() {
        tableView.reloadData()
        buttonEnableDisable()
        
        if arrayNewQuestions.count > 0 {
            if btnNext.isEnabled {
                progressView.progress = Float(pageIndex + 1) / Float(arrayNewQuestions.count)
            } else {
                progressView.progress = Float(pageIndex) / Float(arrayNewQuestions.count)
            }
        }
    }
    
    override func buttonEnableDisable() {
        btnPre.isHidden = pageIndex == 0
        
        btnNext.isEnabled = false
        
        if arrayNewQuestions.count > pageIndex {
            let arraySelectedData = arrayNewQuestions[pageIndex].filter({ $0.selectedAnswer.trim.count > 0 })
            if arraySelectedData.count == arrayNewQuestions[pageIndex].count && arraySelectedData.count > 0 {
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
        if pageIndex < (arrayNewQuestions.count - 1) {
            pageIndex = pageIndex + 1
            print(pageIndex)
            tableView.reloadData()
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
        if pageIndex > 0 {
            pageIndex = pageIndex - 1
            print(pageIndex)
            tableView.reloadData()
        }
        
        setupUI()
    }
    
}


extension FiveOptionVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if arrayNewQuestions.count > 0 {
            return arrayNewQuestions[pageIndex].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: TitleDescriptionCell.self)
            cell.lblTitle.text = questionData?.question_title ?? ""
            cell.lblDescription.text = questionData?.question_description ?? ""
            
            cell.lblTitle.isHidden = (cell.lblTitle.text?.trim.count ?? 0) == 0
            cell.lblDescription.isHidden = (cell.lblDescription.text?.trim.count ?? 0) == 0
            
            return cell
        }
        
        if optionType == .fiveoptions {
            let cell = tableView.dequeueReusableCell(withClass: FiveOptionTableViewCell.self)
            cell.configureCell(data: arrayNewQuestions[pageIndex][indexPath.row])
            cell.didSelectOption = { selectedOption in
                self.setSelectedOption(row: indexPath.row, selectedOption: selectedOption)
            }
            return cell
        } else if optionType == .tenoptions {
            let cell = tableView.dequeueReusableCell(withClass: TenOptionTableViewCell.self)
            cell.configureCell(data: arrayNewQuestions[pageIndex][indexPath.row])
            cell.didSelectOption = { selectedOption in
                self.setSelectedOption(row: indexPath.row, selectedOption: selectedOption)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: TwoOptionTableViewCell.self)
        cell.configureCell(data: arrayNewQuestions[pageIndex][indexPath.row])
        cell.didSelectOption = { selectedOption in
            self.setSelectedOption(row: indexPath.row, selectedOption: selectedOption)
        }
        return cell
    }
    
    func setSelectedOption(row : Int, selectedOption : String) {
        arrayNewQuestions[pageIndex][row].selectedAnswer = selectedOption
        tableView.reloadData()
        
        let question = arrayNewQuestions[pageIndex][row].question
        let selectedAnswer = arrayNewQuestions[pageIndex][row].selectedAnswer
        
        for newQuestion in arrayQuestions {
            if newQuestion.question == question {
                newQuestion.selectedAnswer = selectedAnswer
            }
        }
        
        questionData?.questions = arrayQuestions
        
        setupUI()
    }
    
}

extension FiveOptionVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
