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
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var btnChangeUser: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    
    
    // MARK:- VARIABLES
    var suggstedPlaylist : PlaylistDetailsModel?
    var arrayPastIndexScore = [PastIndexScoreModel]()
    var arraySessionScore = [SessionScoreModel]()
    var arraySessionProgress = [SessionProgressModel]()
    var areaOfFocus = [String]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear All Downloads
        AccountVC.clearDownloadData()
        
        // Cancel All Downloads on launch
        SDDownloadManager.shared.cancelAllDownloads()
        
        // Fetch next audio to download on launch
        DJDownloadManager.shared.fetchNextDownload()
        
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callHomeAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: SuggestedPlaylistCell.self)
        tableView.register(nibWithCellClass: GraphCell.self)
        tableView.register(nibWithCellClass: AreaCell.self)
        tableView.register(nibWithCellClass: IndexScrorCell.self)
        tableView.register(nibWithCellClass: ProgressCell.self)
        
        lblUser.text = CoUserDataModel.currentUser?.Name ?? ""
    }
    
    override func setupData() {
        if let strAreaOfFocus = CoUserDataModel.currentUser?.AreaOfFocus {
            areaOfFocus = strAreaOfFocus.components(separatedBy: ",")
        }
        
        tableView.reloadData()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedChangeUser(_ sender: UIButton) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass:UserListPopUpVC.self)
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
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
            let cell = tableView.dequeueReusableCell(withClass: SuggestedPlaylistCell.self)
            cell.configureCell(data: self.suggstedPlaylist)
            return cell
        } else  if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withClass: AreaCell.self)
            cell.configureCell(data: areaOfFocus)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withClass: IndexScrorCell.self)
            cell.lblTitle.text = "Index Score"
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = true
            cell.imgBanner.isHidden = false
            return cell
        } else  if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withClass: IndexScrorCell.self)
            cell.imgBanner.isHidden = true
            cell.lblTitle.text = "Index Score"
            cell.viewScrore.isHidden = false
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = true
            return cell
        } else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withClass: IndexScrorCell.self)
            cell.imgBanner.isHidden = true
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = false
            cell.viewJoinNow.layer.cornerRadius = 16
            cell.viewJoinNow.clipsToBounds = true
            cell.viewGraph.isHidden = true
            return cell
        } else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withClass: IndexScrorCell.self)
            cell.lblTitle.text = "My activities "
            cell.imgBanner.isHidden = true
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = false
            return cell
        } else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withClass: ProgressCell.self)
            cell.backgroundColor = .white
            return cell
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withClass: GraphCell.self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && suggstedPlaylist != nil {
            return 390
        } else if indexPath.row == 1 {
            return UITableView.automaticDimension
        } else if indexPath.row == 2 ||  indexPath.row == 3 {
             return 150
        } else if indexPath.row == 7 {
             return 130
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 {
            return 310
        } else if indexPath.row == 8 {
            return 300
        } else if indexPath.row == 9 {
            return 200
        }
        return 0
    }
    
}

