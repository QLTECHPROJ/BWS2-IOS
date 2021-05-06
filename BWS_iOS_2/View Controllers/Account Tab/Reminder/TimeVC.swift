//
//  TimeVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 01/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class TimeVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var pickerView: UIPickerView!
    
    //MARK:- Variable
    var arrDays = [Int]()
    var arrAmPm = ["AM","PM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func setupUI() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .clear
        pickerView.showsSelectionIndicator = false
       
    }

    @IBAction func onTappedClose(_ sender: UIButton) {
    }
    @IBAction func onTappedSave(_ sender: UIButton) {
        
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
}

extension TimeVC : UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 12
        }else if component == 1 {
            return 60
        }else {
            return arrAmPm.count
        }
    }

//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0 {
//            return "First \(row)"
//        } else {
//            return "Second \(row)"
//        }
//    }
    
   
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            var attributedString: NSAttributedString!
            attributedString = NSAttributedString(string:"\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            return attributedString
        }else  if component == 1{
            var attributedString: NSAttributedString!
            attributedString = NSAttributedString(string:"\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            return attributedString
        }else {
            var attributedString: NSAttributedString!
            attributedString = NSAttributedString(string:arrAmPm[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            return attributedString
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//            let pickerLabel = UILabel()
//            let titleData = "First \(row)"
//            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Montserrat-Medium", size: 26.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
//            pickerLabel.backgroundColor = .white
//            pickerLabel.layer.cornerRadius = 16
//            pickerLabel.clipsToBounds = true
//            pickerLabel.attributedText = myTitle
//            return pickerLabel
//
//
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel?
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
           
            pickerLabel?.backgroundColor = .clear
        }
        var titleData = ""
        if component == 0 || component == 1 {
             titleData = " \(row)"
        }else {
             titleData = arrAmPm[row]
        }
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Montserrat-Medium", size: 20)!,NSAttributedString.Key.foregroundColor:UIColor.black])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .center
        pickerLabel?.backgroundColor = .white
        return pickerLabel!
        
    }
    

    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        print(row)
    }
    
    
    
}
