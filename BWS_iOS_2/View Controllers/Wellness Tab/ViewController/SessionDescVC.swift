//
//  SessionDescVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 20/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionDescVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var lblSessionName: UILabel!
    @IBOutlet weak var lblStepName: UILabel!
    @IBOutlet weak var lblStepDescription: UILabel!
    
    
    //MARK:- Variables
    var sessionStepData : SessionListDataMainModel?
    var sessionDescriptionData : SessionDescriptionDataModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupData()
        
        callSessionDescriptionAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: SelfDevCell.self)
    }
    
    override func setupData() {
        lblSessionName.text = sessionDescriptionData?.session_title ?? ""
        lblStepName.text = sessionDescriptionData?.step_title ?? ""
        lblStepDescription.text = sessionDescriptionData?.step_short_description ?? ""
        
        tableView.reloadData()
        tableViewHeightConst.constant = 0
        tableView.isHidden = true
        
        if let _ = sessionDescriptionData?.step_audio {
            tableViewHeightConst.constant = 70
            tableView.isHidden = false
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueClicked(sender: UIButton) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionStartVC.self)
        aVC.sessionDescriptionData = sessionDescriptionData
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension SessionDescVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = sessionDescriptionData?.step_audio {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelfDevCell.self)
        if let sessionAudio = sessionDescriptionData?.step_audio {
            cell.configureSessionAudioCell(data: sessionAudio)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

