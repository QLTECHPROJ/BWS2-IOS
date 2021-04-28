//
//  CategoryTableCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class CategoryTableCell: UITableViewCell {
    
    @IBOutlet weak var lblCategory : UILabel!
    @IBOutlet weak var collectionView : DynamicHeightCollectionView!
    
    var arrayCategories = [CategoryDataModel]()
    var categoryClicked : ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let layout = CollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        collectionView.collectionViewLayout = layout
        collectionView.register(nibWithCellClass: CategoryCollectionCell.self)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    // Configure Cell
    func configureCell(data : CategoryListModel) {
        lblCategory.text = data.View
        
        arrayCategories.removeAll()
        arrayCategories = data.Details
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
}

// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension CategoryTableCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CategoryCollectionCell.self, for: indexPath)
        cell.configureCell(data: arrayCategories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.categoryClicked?(indexPath.row)
    }
    
}
