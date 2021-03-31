//
//  PlaylistCategoryVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 31/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlaylistCategoryVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableHeaderView : UIView!
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
        tableView.register(nibWithCellClass: ManagePlaylistCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 240
        tableView.reloadData()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createPlaylistClicked(sender : UIButton) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: CreatePlaylistVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension PlaylistCategoryVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ManagePlaylistCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = (tableView.frame.width - 48) / 2
        height = height + 68
        return height
    }
    
}
