//
//  ManageVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ManageVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableHeaderView : UIView!
    @IBOutlet weak var playlistTopView : UIView!
    @IBOutlet weak var playlistBottomView : UIView!
    @IBOutlet weak var btnReminder : UIButton!
    @IBOutlet weak var btnPlay : UIButton!
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var lblPlaylistName : UILabel!
    @IBOutlet weak var lblPlaylistDirection : UILabel!
    
    @IBOutlet weak var tableView : UITableView!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.tableHeaderView = tableHeaderView
        tableView.register(nibWithCellClass: ManageAudioCell.self)
        tableView.register(nibWithCellClass: ManagePlaylistCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func searchClicked(sender : UIButton) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistCategoryVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func playClicked(sender : UIButton) {
        
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension ManageVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: ManagePlaylistCell.self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: ManageAudioCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            var height = (tableView.frame.width - 48) / 2
            height = height + 68
            return height
        } else  if indexPath.row == 3 {
            return 210
        } else {
            return 280
        }
    }
    
}
