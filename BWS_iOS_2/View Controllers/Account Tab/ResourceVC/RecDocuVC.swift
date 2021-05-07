//
//  RecDocuVC.swift
//  BWS
//
//  Created by Sapu on 24/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class RecDocuVC: BaseViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData   : UILabel!
    
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.font = Theme.fonts.montserratFont(ofSize: 17, weight: .regular)
        tableView.register(nibWithCellClass: DocumentryCell.self)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        tableView.reloadData()
        lblNoData.isHidden = ResourceVC.documentariesData.count != 0
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension RecDocuVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResourceVC.documentariesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: DocumentryCell.self)
        cell.configureCell(data: ResourceVC.documentariesData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: ResourceDetailVC.self)
        aVC.objDetail = ResourceVC.documentariesData[indexPath.row]
        aVC.screenTitle = self.title ?? "Resources"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
