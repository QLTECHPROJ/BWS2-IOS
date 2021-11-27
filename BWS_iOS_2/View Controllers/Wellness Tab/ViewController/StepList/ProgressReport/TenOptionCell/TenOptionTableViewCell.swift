//
//  TenOptionTableViewCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 26/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class TenOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion : UILabel!
    @IBOutlet weak var objCollectionView : UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        objCollectionView.register(nibWithCellClass: TenOptionCollectionViewCell.self)
        objCollectionView.reloadData()
    }
    
    // Configure Cell
    func configureCell(data : GeneralModel) {
        objCollectionView.reloadData()
    }
    
}


extension TenOptionTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: TenOptionCollectionViewCell.self, for: indexPath)
        cell.lblOption.text = "\(indexPath.row)"
        return cell
    }
    
}

extension TenOptionTableViewCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index :- ",indexPath.row)
    }
    
}


extension TenOptionTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 3
        return CGSize(width: width, height: 50)
    }
    
}
