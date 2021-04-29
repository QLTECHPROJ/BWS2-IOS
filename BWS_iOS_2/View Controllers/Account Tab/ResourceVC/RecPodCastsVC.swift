//
//  RecPodCastsVC.swift
//  BWS
//
//  Created by Sapu on 24/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class RecPodCastsVC: BaseViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData   : UILabel!
    
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.font = UIFont.systemFont(ofSize: 17)
        tableView.register(nibWithCellClass: PodcastCell.self)
        tableView.rowHeight = 70
        //tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        //tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        tableView.reloadData()
        lblNoData.isHidden = ResourceVC.podcastData.count != 0
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension RecPodCastsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PodcastCell.self)
       // cell.configureCell(data: ResourceVC.podcastData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: ResourceDetailVC.self)
        aVC.objDetail = ResourceVC.podcastData[indexPath.row]
        aVC.screenTitle = self.title ?? "Resources"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
