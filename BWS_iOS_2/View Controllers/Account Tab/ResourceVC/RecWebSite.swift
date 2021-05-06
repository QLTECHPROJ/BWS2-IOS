//
//  RecWebSite.swift
//  BWS
//
//  Created by Sapu on 24/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class RecWebSite: BaseViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData   : UILabel!
    
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.font = UIFont.systemFont(ofSize: 17)
        tableView.register(nibWithCellClass: WebsiteCell.self)
        tableView.rowHeight = 85
        //tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        //tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        tableView.reloadData()
        lblNoData.isHidden = ResourceVC.websiteData.count != 0
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension RecWebSite : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResourceVC.websiteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: WebsiteCell.self)
        cell.configureCell(data: ResourceVC.websiteData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: ResourceDetailVC.self)
        aVC.objDetail = ResourceVC.websiteData[indexPath.row]
        aVC.screenTitle = self.title ?? "Resources"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
