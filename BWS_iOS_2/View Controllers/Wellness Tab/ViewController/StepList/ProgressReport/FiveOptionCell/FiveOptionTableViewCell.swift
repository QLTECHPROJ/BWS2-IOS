//
//  FiveOptionTableViewCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class FiveOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion : UILabel!
    @IBOutlet weak var objCollectionView : UICollectionView!
    
    var question = ""
    var question_options = [String]()
    var selectedAnswer = ""
    
    var didSelectOption : ((String) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        objCollectionView.register(nibWithCellClass: FiveOptionCollectionViewCell.self)
        objCollectionView.reloadData()
    }
    
    // Configure Cell
    func configureCell(data : ProgressReportQuestionModel) {
        question = data.question
        question_options = data.question_options
        selectedAnswer = data.selectedAnswer
        
        lblQuestion.text = question
        objCollectionView.reloadData()
    }
    
}


extension FiveOptionTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return question_options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FiveOptionCollectionViewCell.self, for: indexPath)
        cell.lblOption.text = question_options[indexPath.row]
        
        if selectedAnswer == question_options[indexPath.row] {
            cell.imgOption.image = UIImage(named: "radio_on_empower")
        } else {
            cell.imgOption.image = UIImage(named: "radio")
        }
        
        return cell
    }
    
}

extension FiveOptionTableViewCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectOption?(question_options[indexPath.row])
    }
    
}


extension FiveOptionTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / CGFloat(question_options.count)
        return CGSize(width: width, height: collectionView.frame.size.height)
    }
    
}
