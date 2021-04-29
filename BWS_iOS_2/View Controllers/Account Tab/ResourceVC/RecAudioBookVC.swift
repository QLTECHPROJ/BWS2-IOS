//
//  RecAudioBookVC.swift
//  BWS
//
//  Created by Sapu on 24/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class RecAudioBookVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var lblNoData   : UILabel!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(nibWithCellClass: AppsCollectionCell.self)
        lblNoData.isHidden = true
        lblNoData.font = UIFont.systemFont(ofSize: 17)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        collectionView.reloadData()
        lblNoData.isHidden = ResourceVC.audioData.count != 0
    }
    
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension RecAudioBookVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AppsCollectionCell.self, for: indexPath)
        //cell.configureCell(data: ResourceVC.audioData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: ResourceDetailVC.self)
        aVC.objDetail = ResourceVC.audioData[indexPath.row]
//        aVC.screenTitle = self.title ?? "Resource"
        aVC.screenTitle = "Audio Books"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2
        let height = width + 75
        return CGSize(width: width, height: height)
    }
    
}
