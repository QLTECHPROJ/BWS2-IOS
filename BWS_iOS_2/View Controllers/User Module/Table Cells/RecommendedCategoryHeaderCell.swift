//
//  RecommendedCategoryHeaderCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 26/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class RecommendedCategoryHeaderCell: UITableViewCell {
    
    @IBOutlet weak var lblSubTitle : UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var arrayCategories = [AreaOfFocusModel]()
    var backClicked : (() -> Void)?
    var searchText : ((String) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblSubTitle.attributedText = Theme.strings.recommended_category_subtitle.attributedString(alignment: .left, lineSpacing: 10)
        
        txtSearch.delegate = self
        btnClear.isHidden = true
        // txtSearch.isEnabled = false
        txtSearch.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: UIControl.Event.editingChanged)
        
        let layout = CollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        collectionView.collectionViewLayout = layout
        collectionView.register(nibWithCellClass: AreaOfFocusCell.self)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    // Configure Cell
    func configureCell(data : [AreaOfFocusModel]) {
        arrayCategories.removeAll()
        arrayCategories = data
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        btnClear.isHidden = textField.text?.count == 0
    }
    
    @IBAction func backClicked(sender : UIButton) {
        backClicked?()
    }
    
    @IBAction func clearSearchClicked(sender: UIButton) {
        txtSearch.text = ""
        btnClear.isHidden = true
        searchText?("")
    }
    
}

// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension RecommendedCategoryHeaderCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AreaOfFocusCell.self, for: indexPath)
        cell.configureCell(data: arrayCategories[indexPath.row], index: indexPath.row)
        return cell
    }
    
}

// MARK:- UITextFieldDelegate
extension RecommendedCategoryHeaderCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        if let text = textField.text,
        //            let textRange = Range(range, in: text) {
        //            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
        //            // self.searchText?(updatedText)
        //        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.searchText?(textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
