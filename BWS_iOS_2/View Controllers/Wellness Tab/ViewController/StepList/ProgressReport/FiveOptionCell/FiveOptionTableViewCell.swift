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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        objCollectionView.register(nibWithCellClass: FiveOptionCollectionViewCell.self)
        objCollectionView.reloadData()
    }
    
    // Configure Cell
    func configureCell(data : GeneralModel) {
        objCollectionView.reloadData()
    }
    
}


extension FiveOptionTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FiveOptionCollectionViewCell.self, for: indexPath)
        cell.lblOption.text = "\(indexPath.row)"
        return cell
    }
    
}

extension FiveOptionTableViewCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index :- ",indexPath.row)
    }
    
}


extension FiveOptionTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 4
        return CGSize(width: width, height: collectionView.frame.size.height)
    }
    
}
