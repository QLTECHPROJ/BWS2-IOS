//
//  FAQVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 28/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class FAQVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    //MARK:- Variables
    var arrTitle = ["Audio","Playlist","Help"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableView.register(nibWithCellClass:AccountCell.self)
        tableView.tableFooterView = headerView
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FAQVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AccountCell.self)
        cell.imgHeight.constant = 0
        cell.imgLeading.constant = 0
        cell.lblTitle.text = arrTitle[indexPath.section]
        cell.lblLine.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: FAQListVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
