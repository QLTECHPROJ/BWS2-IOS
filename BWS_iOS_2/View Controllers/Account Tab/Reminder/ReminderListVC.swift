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
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        callRemListAPI()
        setupUI()
       
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        
         callRemListAPI()
        tableView.register(nibWithCellClass: ReminderListCell.self)
        
    }
    
    override func setupData() {
         
        tableView.reloadData()
        
    }
    
    //MARK:-  IBAction
    @IBAction func onTappedDelete(_ sender: UIButton) {
        let strID =  (arrayRemDelete.map{String($0)}).joined(separator: ",")
        print(strID)
        callRemDeleteAPI(remID: strID)
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
        }else {
           
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
        if arrayRemList[sender.tag].IsLock == "1" {
            openInactivePopup(controller: self)
            sender.isOn.toggle()
        } else if arrayRemList[sender.tag].IsLock == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
            sender.isOn.toggle()
        }
        else {
            //  sender.isOn = !sender.isOn
            if (sender.isOn == true) {
                print("on")
                // sender.setOn(true, animated: true)
                sender.onTintColor = hexStringToUIColor(hex: "005BAA")
                sender.thumbTintColor = hexStringToUIColor(hex: "000000")
                self.strRemID = arrayRemList[sender.tag].PlaylistId
                self.strStatus = "1"

            }
            else{
                print("off")
                sender.setOn(false, animated: true)
                sender.onTintColor = hexStringToUIColor(hex: "EEEEEE")
                sender.thumbTintColor = .gray
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
         lblSelected.text = "\(sender.tag + 1)" + " Selected"
        }else {
         arrayRemDelete.removeAll(where: { $0 == arrayRemList[sender.tag].ReminderId })
         if arrayRemDelete.count == 0 {
            tableView.tableHeaderView = nil
            tableView.tableFooterView = nil
         }
         lblSelected.text = "\(sender.tag)" + " Selected"
        }
         tableView.reloadData()
    }
}
// MARK:- UITableViewDelegate, UITableViewDataSource
extension ReminderListVC:UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  arrayRemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ReminderListCell.self)
        cell.btnHeight.constant = 20
        cell.lblTitle.text = arrayRemList[indexPath.row].PlaylistName
        cell.lblSubTitle.text = arrayRemList[indexPath.row].ReminderDay

        cell.lblTime.text = arrayRemList[indexPath.row].ReminderTime
        cell.swtchReminder.set(width: 35, height: 20)
        cell.swtchReminder.tag = indexPath.row

        if arrayRemList[indexPath.row].IsCheck == "0" {
            cell.swtchReminder.isOn = false
            cell.swtchReminder.onTintColor = hexStringToUIColor(hex: "EEEEEE")
            cell.swtchReminder.thumbTintColor = .gray

        }else {
            cell.swtchReminder.isOn = true
            cell.swtchReminder.onTintColor = hexStringToUIColor(hex: "005BAA")
            cell.swtchReminder.thumbTintColor = hexStringToUIColor(hex: "000000")
        }
        cell.swtchReminder.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        if arrayRemDelete.contains(arrayRemList[indexPath.row].ReminderId){
            cell.btnSelect.setImage(UIImage(named: "Check"), for: .normal)
        }else {
            cell.btnSelect.setImage(UIImage(named: "Unckeck"), for: .normal)
        }
        cell.btnSelect.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
        cell.btnSelect.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: DayVC.self)
        aVC.arrayRemList = arrayRemList[indexPath.row]
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
