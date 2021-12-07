//
//  TwoOptionTableViewCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 26/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class TwoOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion : UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var tableViewHeightConst : NSLayoutConstraint!
    
    var question = ""
    var question_options = [String]()
    var selectedAnswer = ""
    
    var didSelectOption : ((String) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.register(nibWithCellClass: TwoOptionCell.self)
        tableView.reloadData()
        tableViewHeightConst.constant = 0
        self.layoutIfNeeded()
    }
    
    // Configure Cell
    func configureCell(data : ProgressReportQuestionModel) {
        question = data.question
        question_options = data.question_options
        selectedAnswer = data.selectedAnswer
                
        tableViewHeightConst.constant = 52 * CGFloat(question_options.count)
        self.layoutIfNeeded()
        
        lblQuestion.text = question
        tableView.reloadData()
    }
    
}


extension TwoOptionTableViewCell : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question_options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TwoOptionCell.self)
        cell.lblOption.text = question_options[indexPath.row]
        
        if selectedAnswer == question_options[indexPath.row] {
            cell.imgOption.image = UIImage(named: "radio_on_empower")
        } else {
            cell.imgOption.image = UIImage(named: "radio")
        }
        
        return cell
    }
    
}


extension TwoOptionTableViewCell : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectOption?(question_options[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}
