//
//  AddAudioVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AddAudioVC: BaseViewController {
    
     //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func setupUI() {
         tableView.register(UINib(nibName:"SelfDevCell", bundle: nil), forCellReuseIdentifier:"SelfDevCell")
    }
    
    //MARK:- IBAction
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddAudioVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier:"SelfDevCell", for: indexPath) as!  SelfDevCell
        cell.btnChangePosition.setImage(UIImage(named: "Add"), for: .normal)
        cell.btnDownload.isHidden = true
        cell.btnDelete.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass:PlayerVC.self)
        self.navigationController?.present(aVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    
}
