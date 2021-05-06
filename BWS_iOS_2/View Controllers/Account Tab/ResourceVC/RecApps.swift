//
//  RecApps.swift
//  BWS
//
//  Created by Sapu on 24/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class RecApps: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var lblNoData   : UILabel!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.font = UIFont.systemFont(ofSize: 17)
        collectionView.register(nibWithCellClass: AppsCollectionCell.self)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        collectionView.reloadData()
        lblNoData.isHidden = ResourceVC.appsData.count != 0
    }
    
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension RecApps : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ResourceVC.appsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AppsCollectionCell.self, for: indexPath)
        cell.configureCell(data: ResourceVC.appsData[indexPath.row])
        cell.lblSubTitle.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: ResourceDetailVC.self)
        aVC.objDetail = ResourceVC.appsData[indexPath.row]
        aVC.screenTitle = self.title ?? "Resources"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2
        let height = width + 55
        return CGSize(width: width, height: height)
    }
    
}
