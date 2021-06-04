//
//  NotificatonVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class NotificatonVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    // MARK:- VARIABLES
    var arrayNotifications = [NotificationListDataModel]()
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.notificationList)
        
        lblNoData.isHidden = true
        lblNoData.font = Theme.fonts.montserratFont(ofSize: 17, weight: .regular)
        lblNoData.text = "Welcome \(CoUserDataModel.currentUser?.Name ?? "") hope you're doing great!!"
        
        setupUI()
        
        if checkInternet() {
            lblNoData.isHidden = true
            callNotificationListAPI()
        } else {
            lblNoData.isHidden = false
            tableView.isHidden = true
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: NotificationCell.self)
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
    }
    
    override func setupData() {
        if arrayNotifications.count > 0 {
            lblNoData.isHidden = true
            tableView.isHidden = false
        } else {
            lblNoData.isHidden = false
            tableView.isHidden = true
        }
    }
    
    // Pull To Refresh Screen Data
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        if checkInternet() {
            lblNoData.isHidden = true
            callNotificationListAPI()
        } else {
            lblNoData.isHidden = false
            tableView.isHidden = true
        }
        refreshControl.endRefreshing()
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension NotificatonVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: NotificationCell.self)
        cell.configureCell(data: arrayNotifications[indexPath.row])
        return cell
    }
    
}
