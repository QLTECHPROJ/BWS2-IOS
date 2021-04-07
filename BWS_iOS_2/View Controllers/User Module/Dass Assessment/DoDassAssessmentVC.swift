//
//  DoDassAssessmentVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 15/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import EVReflection

class QuestionData: EVObject {
    var arrayQuestions = [QuestionModel]()
}

func fetchAssessmentQuestions() -> [QuestionModel]? {
    if let questions = UserDefaults.standard.data(forKey: "assessmentQuestions") {
        return QuestionData(data: questions).arrayQuestions
    } else {
        return nil
    }
}

func saveAssessmentQuestions(arrayQuestions : [QuestionModel]) {
    let questionData = QuestionData()
    questionData.arrayQuestions = arrayQuestions
    UserDefaults.standard.setValue(questionData.toJsonData(), forKey: "assessmentQuestions")
}

class QuestionModel : EVObject {
    var key = ""
    var selectedValue = ""
    var question = ""
    var details = ""
    var options = [String]()
}

class DoDassAssessmentVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblSubTitle : UILabel!
    
    
    // MARK:- VARIABLES
    var selectedIndex = 0
    var arrayQuestions = [QuestionModel]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let normalString = "We're done with the first part. \n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore. \n\nAt vero eos et accusam et justo duo dolores et ea"
        lblSubTitle.attributedText = normalString.attributedString(alignment: .left, lineSpacing: 10)
        
        fetchQuestions()
    }
    
    func fetchQuestions() {
        arrayQuestions.removeAll()
        
        if let allQuestions = fetchAssessmentQuestions(), allQuestions.count > 0 {
            self.arrayQuestions = allQuestions
            if let lastQue = (arrayQuestions.filter { $0.selectedValue.trim.count == 0 }.first), let queIndex = arrayQuestions.firstIndex(of: lastQue) {
                self.selectedIndex = queIndex
            } else {
                selectedIndex = (arrayQuestions.count - 1)
            }
        } else {
            for i in 1...5 {
                let question = QuestionModel()
                question.question = "Question \(i)"
                question.options = ["Never", "Sometimes", "Often", "Always"]
                arrayQuestions.append(question)
            }
        }
    }
    
    override func goNext() {
        if selectedIndex == (arrayQuestions.count - 1) {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
        else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: AssessmentVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            
            //            let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentVC.self)
            //            aVC.arrayQuestions = self.arrayQuestions
            //            aVC.selectedIndex = self.selectedIndex
            //            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func doTheAssessmentClicked(sender : UIButton) {
        // let aVC = AppStoryBoard.main.viewController(viewControllerClass: StartDassAssessmentVC.self)
        // self.navigationController?.pushViewController(aVC, animated: true)
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: StepVC.self)
        aVC.strTitle = "Step 2"
        aVC.strSubTitle = "Let's assess how you are \ncurrently doing"
        aVC.imageMain = UIImage(named: "dass_form_image")
        aVC.viewTapped = {
            self.goNext()
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: true, completion: nil)
    }
    
}
