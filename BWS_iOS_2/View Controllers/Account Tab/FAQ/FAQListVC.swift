//
//  FAQListVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 28/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class FAQListVC: BaseViewController {
    
    //MARK:- UIOutlet
     @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var arrayFilter = [FAQDataModel]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableView.register(nibWithCellClass: FAQCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.reloadData()
      
    }
    
    override func setupData() {
        
    }
    
//    func fetchQuestions() {
//        arrayQuestions.removeAll()
//
//        for i in 1...10 {
//            let question = FAQDataModel()
//            if i % 3 == 0 {
//                question.Title = "\(i) - How can I cancel if I need to?"
//                question.Desc = "\(i) - How do I purchase a subscription?"
//            }
//            else if i % 2 == 0 {
//                question.Title = "\(i) - Is there a free trial?"
//                question.Desc = "\(i) - Yes. Every plan comes with a 30-day free trial option"
//            }
//            else {
//                question.Title = "\(i) - What are the benefits of signing up for the Membership Program"
//                question.Desc = "\(i) - What's the best way to use the Membership? Where do I start?"
//            }
//            arrayQuestions.append(question)
//        }
//    }
    
    //MARK:- IBAction Methods
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FAQListVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withClass: FAQCell.self)
        cell.configureCell(data: arrayFilter[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var isSelected = arrayFilter[indexPath.row].isSelected
        
        for question in arrayFilter {
            question.isSelected = false
        }
        
        isSelected.toggle()
        arrayFilter[indexPath.row].isSelected = isSelected
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
}
