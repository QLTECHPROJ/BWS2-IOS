//
//  SessionStartVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 20/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionStartVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblDesc: UILabel!
    
    //MARK:- Variables
    var movies: [String] = ["A movies array contains the filenames of the movies images. The frame is needed for the size of the images.","The page control needs to update its current page when the scroll view updates so first the view controller needs to conform to the UIScrollViewDelegate protocol. Change the class declaraion line in","hollywood"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = movies.count
    }
    
    //MARK:- Functions
    override func setupUI() {
        
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
  
    @IBAction func onTappedStart(_ sender: UIButton) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: BrainFeelingVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

