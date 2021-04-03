//
//  NotificatonVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class NotificatonVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
         tableView.register(UINib(nibName:"NotificationCell", bundle: nil), forCellReuseIdentifier:"NotificationCell")
    }
    
    //MARK:- IBAction
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
}

extension NotificatonVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier:"NotificationCell", for: indexPath) as!  NotificationCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}
