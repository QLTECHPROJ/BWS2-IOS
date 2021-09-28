//
//  DayVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 01/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class DayVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPlaylist: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var lblSelected: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK:- VARIABLES
    var arrSelectDays = [Int]()
    var arrayWeek = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var toolBar = UIToolbar()
    var strPlaylistID:String?
    var objPlaylist : PlaylistDetailsModel?
    var objReminder : ReminderListDataModel?
    var isCome:String?
    var isfromPopUp:Bool?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        if let reminder = objReminder {
            SegmentTracking.shared.trackReminderDetails(name: SegmentTracking.screenNames.editReminder, reminder: reminder, trackingType: .screen)
        } else if let playlist = objPlaylist {
            SegmentTracking.shared.trackReminderDetails(name: SegmentTracking.screenNames.editReminder, playlist: playlist, trackingType: .screen)
        }
        
        setupUI()
        setupData()
        buttonEnableDisable()
        
        viewDate.isHidden = true
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: ReminderListCell.self)
        tableView.tableHeaderView = footerView
    }
    
    override func setupData() {
        if isCome == "ReminderList" {
            if let playlistData = objReminder {
                strPlaylistID = playlistData.PlaylistId
                let time =  playlistData.ReminderTime.UTCToLocal(incomingFormat: "h:mm a", outGoingFormat: "h:mm a")
                lblTime.text = time
                lblPlaylist.text = playlistData.PlaylistName
                let listItems = playlistData.RDay.components(separatedBy: ",")
                let myIntArrSafe = listItems.map { Int($0) ?? 0 }
                arrSelectDays = myIntArrSafe
            }
        } else {
            if let playlistData = objPlaylist {
                if objPlaylist?.ReminderDay != "" {
                    strPlaylistID = playlistData.PlaylistID
                    let time =  playlistData.ReminderTime.UTCToLocal(incomingFormat: "h:mm a", outGoingFormat: "h:mm a")
                    lblTime.text = time
                    lblPlaylist.text = playlistData.PlaylistName
                    let listItems = playlistData.ReminderDay.components(separatedBy: ",")
                    let myIntArrSafe = listItems.map { Int($0) ?? 0 }
                    arrSelectDays = myIntArrSafe
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .short
                    let date = Date()
                    lblTime.text = "\(dateFormatter.string(from: date))"
                    lblPlaylist.text = playlistData.PlaylistName
                    strPlaylistID = playlistData.PlaylistID
                }
                
            }
        }
        if objPlaylist?.Created == "2" || objReminder?.Created == "2"{
            lblDesc.text = Theme.strings.reminder_suggestedplaylist
        }else {
            lblDesc.text = ""
            lblDesc.numberOfLines = 0
        }
        
        if arrSelectDays.count == 7 {
            allButtonSelect(isSelected:true)
        }
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if arrSelectDays.count == 0 || lblTime.text == "" || lblTime.text == nil ||  strPlaylistID == "" || strPlaylistID == nil || isCome == "Update" {
            shouldEnable = false
        } else {
            shouldEnable = true
        }
        
        if shouldEnable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.btnSave.isUserInteractionEnabled = true
                self.btnSave.backgroundColor = Theme.colors.white
                self.btnSave.setTitleColor( Theme.colors.green_008892, for: .normal)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.btnSave.isUserInteractionEnabled = false
                self.btnSave.backgroundColor = Theme.colors.gray_7E7E7E
                self.btnSave.setTitleColor(Theme.colors.white, for: .normal)
            }
        }
    }
    
    func adddatePicker() {
        viewDate.isHidden = false
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .time
        datePicker.autoresizingMask = .flexibleWidth
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    func setReminder(notificationAllowed : Bool) {
        if notificationAllowed == false {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            aVC.titleText = Theme.strings.alert_title_allow_notifications
            aVC.detailText = Theme.strings.alert_subtitle_allow_notifications
            aVC.firstButtonTitle = Theme.strings.settings
            aVC.secondButtonTitle = Theme.strings.cancel_small
            self.present(aVC, animated: false, completion: nil)
            return
        }
        
        if arrSelectDays.count == 0 || lblTime.text == "" || lblTime.text == nil || strPlaylistID == "" || strPlaylistID == nil {
            showAlertToast(message: Theme.strings.alert_select_day_and_time)
        } else {
            callSetRemAPI()
        }
    }
    
    func allButtonSelect(isSelected:Bool){
        if isSelected == true {
            btnAll.isSelected = true
            btnAll.setTitle("        " + "UnSelect All", for: .selected)
            btnAll.setTitleColor(.white, for: .selected)
        }else {
            btnAll.isSelected = false
            btnAll.setTitle("       " + "Select All", for: .normal)
            btnAll.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedSave(_ sender: Any) {
        checkNotificationStatus { (notificationAllowed) in
            DispatchQueue.main.async {
                
                if lockDownloads == "1" {
                    openInactivePopup(controller: self)
                    return
                } else if lockDownloads == "2" {
                    showAlertToast(message: Theme.strings.alert_reactivate_plan)
                    return
                }
                
                self.setReminder(notificationAllowed: notificationAllowed)
            }
        }
    }
    
    @IBAction func onTappedALL(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected{
            var intArray = [Int]()
            for i in 0...arrayWeek.count - 1 {
                intArray.append(i)
            }
            arrSelectDays = intArray
            tableView.reloadData()
            allButtonSelect(isSelected:sender.isSelected)
            buttonEnableDisable()
        } else {
            arrSelectDays = []
            tableView.reloadData()
            allButtonSelect(isSelected:sender.isSelected)
        }
    }
    
    @IBAction func onTappedClose(_ sender: UIButton) {
        if isfromPopUp == true {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onTappedTime(_ sender: UIButton) {
        adddatePicker()
    }
    
    @IBAction func OnTappedChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        let date = sender.date
        print("Picked the date \(dateFormatter.string(from: date))")
        lblTime.text = "\(dateFormatter.string(from: date))"
        buttonEnableDisable()
    }
    
    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    @IBAction func onTappedCancel(_ sender: UIButton) {
        viewDate.isHidden = true
    }
    
    @IBAction func onTappedDone(_ sender: UIButton) {
        viewDate.isHidden = true
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension DayVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ReminderListCell.self)
        
        cell.lblSubTitle.text = arrayWeek[indexPath.row]
        cell.lblSubTitle.textColor = .white
        cell.backgroundColor = .clear
        cell.lblTime.isHidden = true
        cell.lblTitle.isHidden = true
        cell.swtchReminder.isHidden = true
        cell.lblLine.isHidden = true
        cell.btnHeight.constant = 20
        
        if arrSelectDays.contains(indexPath.row) {
            cell.lblSubTitle.font = Theme.fonts.montserratFont(ofSize: 15, weight: .bold)
            cell.btnSelect.setImage(UIImage(named: "WhiteCheck"), for: .normal)
        } else {
            cell.lblSubTitle.font = Theme.fonts.montserratFont(ofSize: 15, weight: .regular)
            cell.btnSelect.setImage(UIImage(named: "WhiteUnCheck"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !arrSelectDays.contains(indexPath.row) {
            arrSelectDays.append(indexPath.row)
            isCome = ""
            if arrSelectDays.count == 7 {
                allButtonSelect(isSelected:true)
            }
        } else {
            arrSelectDays.removeAll(where: { $0 == indexPath.row })
        }
        
        buttonEnableDisable()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension DayVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
}
