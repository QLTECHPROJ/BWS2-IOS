//
//  DassAssessmentVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 15/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class DassAssessmentVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblQuestionCount : UILabel!
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var lblQuestion : UILabel!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var tableViewHeightConst : NSLayoutConstraint!
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    
    
    // MARK:- VARIABLES
    var selectedIndex = 0
    var arrayQuestions = [QuestionModel]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: OptionsCell.self)
        tableView.reloadData()
        
        if selectedIndex < arrayQuestions.count {
            tableViewHeightConst.constant = CGFloat(96 * arrayQuestions[selectedIndex].options.count)
            self.view.layoutIfNeeded()
        }
        else {
            tableViewHeightConst.constant = 0
            self.view.layoutIfNeeded()
        }
        
        
        progressView.progress = Float(selectedIndex + 1) / Float(arrayQuestions.count)
        
        if arrayQuestions.count > 0 && selectedIndex > 0 {
            btnPrev.isEnabled = true
        }
        else {
            btnPrev.isEnabled = false
        }
        
        lblQuestionCount.text = "\(selectedIndex + 1) / \(arrayQuestions.count)"
        
        btnNext.isEnabled = false
        if selectedIndex < arrayQuestions.count {
            lblQuestion.text = arrayQuestions[selectedIndex].question
            
            let selectedValue = arrayQuestions[selectedIndex].selectedValue
            let options = arrayQuestions[selectedIndex].options
            if selectedValue.trim.count > 0 {
                if options.contains(selectedValue) {
                    btnNext.isEnabled = true
                }
            }
        }
    }
    
    override func goNext() {
        if selectedIndex < (arrayQuestions.count - 1) {
            selectedIndex = selectedIndex + 1
            setupUI()
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func prevClicked(sender : UIButton) {
        if selectedIndex > 0 {
            selectedIndex = selectedIndex - 1
            setupUI()
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        if selectedIndex == arrayQuestions.count - 1 {
            print(arrayQuestions)
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            goNext()
        }
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension DassAssessmentVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex < arrayQuestions.count {
            return arrayQuestions[selectedIndex].options.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: OptionsCell.self)
        let optionValue = arrayQuestions[selectedIndex].options[indexPath.row]
        let selectedValue = arrayQuestions[selectedIndex].selectedValue
        cell.buttonOption.setTitle(optionValue, for: .normal)
        
        if optionValue == selectedValue {
            cell.buttonOption.borderColor = Theme.colors.orange_F1646A
            cell.buttonOption.setTitleColor(Theme.colors.orange_F1646A, for: .normal)
        } else {
            cell.buttonOption.borderColor = Theme.colors.gray_DDDDDD
            cell.buttonOption.setTitleColor(Theme.colors.textColor, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrayQuestions[selectedIndex].selectedValue = arrayQuestions[selectedIndex].options[indexPath.row]
        self.setupUI()
        
        saveAssessmentQuestions(arrayQuestions: self.arrayQuestions)
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goNext()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
}

