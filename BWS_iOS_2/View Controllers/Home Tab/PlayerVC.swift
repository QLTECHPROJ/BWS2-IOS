//
//  PlayerVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlayerVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var lblAudioName: UILabel!
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblMinTime: UILabel!
    @IBOutlet weak var lblMaxTime: UILabel!
    
    //MARK:- Variable
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- Functions
    override func setupUI() {
        //
    }
    
    override func setupData() {
        //
    }
    
    //MARK:- IBAction
    @IBAction func onTappedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
