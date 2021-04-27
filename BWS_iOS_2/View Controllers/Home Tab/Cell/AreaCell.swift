//
//  AreaCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 26/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit

class AreaCell: UITableViewCell {
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: DynamicHeightCollectionView!
    
    var arrayCategories = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = CollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        collectionView.collectionViewLayout = layout
        collectionView.register(nibWithCellClass: AreaOfFocusCell.self)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        btnEdit.isHidden = ( arrayCategories.count == 0 )
    }
    
    func configureCell(data : [String]) {
        arrayCategories.removeAll()
        arrayCategories = data
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        btnEdit.isHidden = ( arrayCategories.count == 0 )
    }
    
    @IBAction func onTappedEdit(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AreaOfFocusVC.self)
        self.parentViewController?.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension AreaCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AreaOfFocusCell.self, for: indexPath)
        cell.configureCell(data: arrayCategories[indexPath.row], index: indexPath.row)
        return cell
    }
    
}
