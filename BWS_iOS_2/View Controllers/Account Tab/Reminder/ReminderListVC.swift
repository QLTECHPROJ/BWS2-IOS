//
//  ReminderListVC.swift
//  BWS
//
//  Created by Sapu on 23/09/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class ReminderListVC: BaseViewController{
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var lblSelected: UILabel!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    // MARK:- VARIABLES
    var arrayRemList = [ReminderListDataModel]()
    var strStatus:String?
    var strRemID:String?
    var arrayRemDelete = [String]()
    var shouldTrackScreen = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshData, object: nil)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callRemListAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: ReminderListCell.self)
    }
    
    override func setupData() {
        tableView.reloadData()
    }
    
    // MARK:- FUNCTIONS
    @objc func refreshData() {
        tableView.reloadData()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedDelete(_ sender: UIButton) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
        aVC.modalPresentationStyle = .overFullScreen
        aVC.delegate = self
        aVC.titleText = Theme.strings.delete_reminder
        aVC.detailText = Theme.strings.alert_delete_remidner
        aVC.firstButtonTitle = Theme.strings.delete
        aVC.secondButtonTitle = Theme.strings.close
        self.present(aVC, animated: false, completion: nil)
    }
    
    //    @IBAction func onTappedAll(_ sender: Any) {
    //        var intArray = [String]()
    //        for i in arrayRemList {
    //            intArray.append(i.ReminderId)
    //        }
    //        arrayRemDelete = intArray
    //        tableView.reloadData()
    //    }
    
    @IBAction func onTappedDelALL(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected{
            var intArray = [String]()
            for i in arrayRemList {
                intArray.append(i.ReminderId)
            }
            arrayRemDelete = intArray
            lblSelected.text = "\(intArray.count )" +  " Selected"
            tableView.reloadData()
        } else {
            arrayRemDelete = []
            lblSelected.text = "\(arrayRemDelete.count)" + " Selected"
            tableView.reloadData()
        }
    }
    
    @IBAction func onTappedClose(_ sender: UIButton) {
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        arrayRemDelete = []
        tableView.reloadData()
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        if checkInternet(showToast: true) == false {
            sender.isOn.toggle()
            return
        }
        
        checkNotificationStatus { (notificationAllowed) in
            DispatchQueue.main.async {
                self.setReminderOnOff(sender: sender, notificationAllowed: notificationAllowed)
            }
        }
    }
    
    func setReminderOnOff(sender: UISwitch, notificationAllowed : Bool) {
        if notificationAllowed == false && sender.isOn {
            sender.isOn.toggle()
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.modalPresentationStyle = .overFullScreen
            aVC.popUpTag = 1
            aVC.delegate = self
            aVC.titleText = Theme.strings.alert_title_allow_notifications
            aVC.detailText = Theme.strings.alert_subtitle_allow_notifications
            aVC.firstButtonTitle = Theme.strings.settings
            aVC.secondButtonTitle = Theme.strings.cancel_small
            self.present(aVC, animated: false, completion: nil)
            return
        }
        
        if lockDownloads == "1" {
            openInactivePopup(controller: self)
            sender.isOn.toggle()
        } else {
            if (sender.isOn == true) {
                print("on")
                sender.onTintColor = Theme.colors.green_008892
                sender.thumbTintColor = Theme.colors.gray_313131
                self.strRemID = arrayRemList[sender.tag].PlaylistId
                self.strStatus = "1"
            } else {
                print("off")
                sender.setOn(false, animated: true)
                sender.onTintColor = Theme.colors.gray_EEEEEE
                sender.thumbTintColor = Theme.colors.gray_7E7E7E
                self.strRemID = arrayRemList[sender.tag].PlaylistId
                self.strStatus = "0"
            }
            
            callRemSatusAPI(status:strStatus ?? "")
        }
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkboxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if !arrayRemDelete.contains(arrayRemList[sender.tag].ReminderId){
            arrayRemDelete.append(arrayRemList[sender.tag].ReminderId)
            tableView.tableHeaderView = viewHeader
            tableView.tableFooterView = viewFooter
            lblSelected.text = "\(arrayRemDelete.count)" + " Selected"
        }else {
            arrayRemDelete.removeAll(where: { $0 == arrayRemList[sender.tag].ReminderId })
            if arrayRemDelete.count == 0 {
                tableView.tableHeaderView = nil
                tableView.tableFooterView = nil
            }
            lblSelected.text = "\(arrayRemDelete.count)" + " Selected"
        }
        tableView.reloadData()
    }
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension ReminderListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrayRemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ReminderListCell.self)
        cell.btnSelect.isUserInteractionEnabled = true
        cell.btnHeight.constant = 20
        cell.lblTitle.text = arrayRemList[indexPath.row].PlaylistName
        cell.lblSubTitle.text = arrayRemList[indexPath.row].ReminderDay
       let time =  arrayRemList[indexPath.row].ReminderTime.UTCToLocal(incomingFormat: "h:mm a", outGoingFormat: "h:mm a")
        cell.lblTime.text = time
        cell.swtchReminder.set(width: 35, height: 20)
        cell.swtchReminder.tag = indexPath.row
        
        DispatchQueue.main.async {
            if self.arrayRemList[indexPath.row].IsCheck == "0" {
                cell.swtchReminder.isOn = false
                cell.swtchReminder.onTintColor = Theme.colors.gray_EEEEEE
                cell.swtchReminder.thumbTintColor = Theme.colors.gray_7E7E7E
            } else {
                cell.swtchReminder.isOn = true
                cell.swtchReminder.onTintColor = Theme.colors.green_008892
                cell.swtchReminder.thumbTintColor = Theme.colors.gray_313131
            }
        }
        
        if checkInternet() {
            cell.swtchReminder.isUserInteractionEnabled = true
            cell.swtchReminder.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        } else {
            cell.swtchReminder.isUserInteractionEnabled = false
        }
        
        if arrayRemDelete.contains(arrayRemList[indexPath.row].ReminderId) {
            cell.btnSelect.setImage(UIImage(named: "Check"), for: .normal)
        } else {
            cell.btnSelect.setImage(UIImage(named: "Unckeck"), for: .normal)
        }
        
        cell.btnSelect.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
        cell.btnSelect.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if lockDownloads == "1" {
            openInactivePopup(controller: self)
            return
        }
        
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: DayVC.self)
        aVC.objReminder = arrayRemList[indexPath.row]
        aVC.isCome = "ReminderList"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}

extension UISwitch {
    
    func set(width: CGFloat, height: CGFloat) {
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension ReminderListVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if popUpTag == 1 {
            if sender.tag == 0 {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                }
            }
        } else {
            if sender.tag == 0 {
                let strID =  (arrayRemDelete.map{String($0)}).joined(separator: ",")
                print(strID)
                callRemDeleteAPI(remID: strID)
            }
        }
    }
    
}
