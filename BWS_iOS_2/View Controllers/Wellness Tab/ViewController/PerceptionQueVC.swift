//
//  PerceptionQueVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 10/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PerceptionQueVC: BaseViewController {
    
    //MARK:- UIOutlet
    // MARK:- OUTLETS
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var cvHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewheight: NSLayoutConstraint!
    
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        collectionView.register(UINib(nibName:"SubColCell", bundle: nil), forCellWithReuseIdentifier:"SubColCell")
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        //scrollview height manage with collectionview and mainView
        cvHeight.constant = CGFloat(6 * 100)
        mainViewheight.constant = CGFloat(6 * 100 + 250)
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
  
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PerceptionQueVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"SubColCell", for: indexPath) as! SubColCell
        
        
        
        cell.lblTop.text = "Frequently"
        cell.lblTop.font = Theme.fonts.montserratFont(ofSize: 8, weight: .regular)
        cell.lblTop.isHidden = false
        cell.lblRight.isHidden = true
        cell.backgroundColor = Theme.colors.off_white_F9F9F9
        cell.btn.setImage(UIImage(named: "radio1"), for: .normal)
        
//        if selectedAnswer == answer {
//            cell.btn.setImage(UIImage(named: "radio1"), for: .normal)
//        } else {
//            cell.btn.setImage(UIImage(named: "radio"), for: .normal)
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/5, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            sectionHeader.label.text = "1. Feelings of Loneliness"
            sectionHeader.label.textColor = .black
            sectionHeader.label.font = UIFont(name: Theme.fonts.MontserratMedium, size: 15)
            return sectionHeader
        } else {
            // No footer in this case but can add option for that
            return UICollectionReusableView()
        }
    }
}
