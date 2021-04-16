//
//  CountryListVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class CountryListVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    
    
    // MARK:- VARIABLES
    var arrayCountry = [CountrylistDataModel]()
    var arrayCountrySearch = [CountrylistDataModel]()
    var didSelectCountry : ((CountrylistDataModel) -> Void)?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.callCountryListAPI()
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        btnClear.isHidden = true
        lblNoData.isHidden = true
        
        if checkInternet() == false {
            txtSearch.isUserInteractionEnabled = false
            showAlertToast(message: Theme.strings.alert_check_internet)
            lblNoData.isHidden = true
        } else {
            txtSearch.isUserInteractionEnabled = true
            lblNoData.isHidden = false
            lblNoData.text = "Search term not found please use another one"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewBackground.addGestureRecognizer(tapGesture)
        viewBackground.isUserInteractionEnabled = true
        
        tableView.register(nibWithCellClass: CountryCell.self)
        tableView.reloadData()
        
        txtSearch.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: UIControl.Event.editingChanged)
    }
    
    override func setupData() {
        arrayCountrySearch = arrayCountry
        tableView.reloadData()
        lblNoData.isHidden = arrayCountrySearch.count != 0
        tableView.isHidden = arrayCountrySearch.count == 0
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        btnClear.isHidden = textField.text?.count == 0
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func clearSearchClicked(sender: UIButton) {
        txtSearch.text = ""
        arrayCountrySearch = arrayCountry
        btnClear.isHidden = true
        lblNoData.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
}


// MARK:- UITextFieldDelegate
extension CountryListVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            arrayCountrySearch = arrayCountry.filter({ (model:CountrylistDataModel) -> Bool in
                return model.Name.lowercased().contains(updatedText.lowercased())
            })
            
            if updatedText.trim.count == 0 {
                arrayCountrySearch = arrayCountry
            }
            
            if arrayCountrySearch.count > 0 {
                lblNoData.isHidden = true
            } else {
                lblNoData.isHidden = false
                lblNoData.text = "Couldn't find " + updatedText + " Try searching again"
            }
            lblNoData.isHidden = arrayCountrySearch.count != 0
            tableView.isHidden = arrayCountrySearch.count == 0
            tableView.reloadData()
        }
        
        return true
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension CountryListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCountrySearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CountryCell.self)
        cell.configureCell(data: arrayCountrySearch[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCountry?(arrayCountrySearch[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}
