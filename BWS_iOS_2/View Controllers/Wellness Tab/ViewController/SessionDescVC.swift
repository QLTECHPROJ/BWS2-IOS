//
//  SessionDescVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 20/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionDescVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: SelfDevCell.self)
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedContinue(_ sender: UIButton) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionStartVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension SessionDescVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelfDevCell.self)
        cell.backgroundColor = hexStringToUIColor(hex: "EEEEEE")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

