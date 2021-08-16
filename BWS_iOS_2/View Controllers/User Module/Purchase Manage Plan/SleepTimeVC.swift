//
//  SleepTimeVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SleepTimeVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var collectionViewSleepTime : UICollectionView!
    
    
    // MARK:- VARIABLES
    var arrayTimes = [AverageSleepTimeDataModel]()
    var isFromEdit = false
    var isForAreaOfFocus = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.sleepTime)
        
        collectionViewSleepTime.register(nibWithCellClass: SleepTimeCell.self)
        
        if isForAreaOfFocus {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: AreaOfFocusVC.self)
            aVC.isFromEdit = self.isFromEdit
            aVC.isFromEditSleepTime = self.isFromEdit
            aVC.averageSleepTime = CoUserDataModel.currentUser?.AvgSleepTime ?? ""
            self.navigationController?.pushViewController(aVC, animated: false)
        }
        
        callSleepTimetAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func goNext() {
        if let selectedSleepTime = arrayTimes.filter({ $0.isSelected == true }).first {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: AreaOfFocusVC.self)
            aVC.isFromEdit = self.isFromEdit
            aVC.isFromEditSleepTime = self.isFromEdit
            aVC.averageSleepTime = selectedSleepTime.Name
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension SleepTimeVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: SleepTimeCell.self, for: indexPath)
        cell.configureCell(data:arrayTimes[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for timeData in arrayTimes {
            timeData.isSelected = false
        }
        
        arrayTimes[indexPath.row].isSelected = true
        collectionView.reloadData()
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goNext()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - 56) / 2
        let height = (50 * width) / 159
        return CGSize(width: width, height: height)
    }
    
}
