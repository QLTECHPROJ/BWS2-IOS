//
//  UserListPopUpVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class UserListPopUpVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewFooter: UIView!
    
    //MARK:- Variables
     var tapGesture = UITapGestureRecognizer()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableView.register(UINib(nibName:"UserListCell", bundle: nil), forCellReuseIdentifier:"UserListCell")
        tableView.tableFooterView = viewFooter
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewFooter.addGestureRecognizer(tapGesture)
        viewFooter.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTappedback(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewBack.addGestureRecognizer(tapGesture)
        viewBack.isUserInteractionEnabled = true
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AddProfileVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @objc func viewTappedback(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension UserListPopUpVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier:"UserListCell", for: indexPath) as!  UserListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

