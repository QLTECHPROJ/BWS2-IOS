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
    var isFromEdit = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let normalString = "We're done with the first part. \n\nIn the next step, you will have to fill an assessment form which will help us assess your mental health."
        lblSubTitle.attributedText = normalString.attributedString(alignment: .left, lineSpacing: 10)
    }
    
    override func goNext() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: AssessmentVC.self)
        aVC.isFromEdit = isFromEdit
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    
    // MARK:- ACTIONS
    @IBAction func doTheAssessmentClicked(sender : UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: StepVC.self)
        aVC.strTitle = "Step 2"
        aVC.strSubTitle = "Let's assess how you are \ncurrently doing"
        aVC.imageMain = UIImage(named: "dass_form_image")
        aVC.viewTapped = {
            self.goNext()
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
    }
    
}
