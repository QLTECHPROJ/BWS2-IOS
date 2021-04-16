//
//  HomeVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    // UserInfo
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var btnChangeUser: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(UINib(nibName:"PlayerBannerCell", bundle: nil), forCellReuseIdentifier:"PlayerBannerCell")
        tableView.register(UINib(nibName:"AreaCell", bundle: nil), forCellReuseIdentifier:"AreaCell")
        tableView.register(UINib(nibName:"IndexScrorCell", bundle: nil), forCellReuseIdentifier:"IndexScrorCell")
        tableView.register(UINib(nibName:"ProgressCell", bundle: nil), forCellReuseIdentifier:"ProgressCell")
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedChangeUser(_ sender: UIButton) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass:UserListPopUpVC.self)
        aVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(aVC, animated: true, completion: nil)
        
    }
    
    @IBAction func onTappedNotification(_ sender: UIButton) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass:NotificatonVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"PlayerBannerCell", for: indexPath) as!  PlayerBannerCell
            cell.viewGraph.isHidden = true
            cell.viewPlayer.isHidden = false
            cell.backgroundColor = .clear
            cell.wavyImage.isHidden = false
            return cell
        } else  if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"AreaCell", for: indexPath) as!  AreaCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"IndexScrorCell", for: indexPath) as!  IndexScrorCell
            cell.lblTitle.text = "Index Score"
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = true
            cell.imgBanner.isHidden = false
            cell.backgroundColor = .white
            return cell
        } else  if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"IndexScrorCell", for: indexPath) as!  IndexScrorCell
            cell.imgBanner.isHidden = true
            cell.lblTitle.text = "Index Score"
            cell.viewScrore.isHidden = false
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = true
            cell.backgroundColor = .white
            return cell
        } else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"IndexScrorCell", for: indexPath) as!  IndexScrorCell
            cell.imgBanner.isHidden = true
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = false
            cell.viewJoinNow.layer.cornerRadius = 16
            cell.viewJoinNow.clipsToBounds = true
            cell.viewGraph.isHidden = true
            cell.backgroundColor = .white
            return cell
        } else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"IndexScrorCell", for: indexPath) as!  IndexScrorCell
            cell.lblTitle.text = "My activities "
            cell.imgBanner.isHidden = true
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = false
            cell.viewGraph.backgroundColor = .black
            cell.backgroundColor = .white
            return cell
        } else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"ProgressCell", for: indexPath) as!  ProgressCell
            cell.backgroundColor = .white
            return cell
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"PlayerBannerCell", for: indexPath) as!  PlayerBannerCell
            cell.viewGraph.isHidden = false
            cell.viewPlayer.isHidden = true
            cell.wavyImage.isHidden = true
            cell.backgroundColor = .white
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 8 {
            return 300
        } else if indexPath.row == 1 {
            return 100
        } else if indexPath.row == 2 ||  indexPath.row == 3 {
             return 150
        } else if indexPath.row == 7 {
             return 130
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 {
            return 280
        } else if indexPath.row == 9 {
            return 200
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        if indexPath.row == 0 {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass:PlaylistAudiosVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 2 {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass:PlaylistAudiosVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 4 {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass:AddAudioVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 5 {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass:PlaylistAudiosVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass:AddToPlaylistVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
         */
    }
    
}

