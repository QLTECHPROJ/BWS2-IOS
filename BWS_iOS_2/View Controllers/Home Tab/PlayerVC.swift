//
//  PlayerVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlayerVC: BaseViewController {
    
    // MARK:- OUTLETS
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
    
    // MARK:- VARIABLES
    var audioDetails : AudioDetailsDataModel?
    var isComeFrom = "Audio"
    var sliderEvent : UITouch.Phase = .ended
    var sliderLastValue : Float?
    var shouldCallAPI : Bool = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        //
    }
    
    override func setupData() {
        //
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
