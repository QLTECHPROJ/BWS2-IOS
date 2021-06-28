//
//  ContactVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 28/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import ContactsUI

class ContactVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    //MARK:- Variables
    // MARK:- VARIABLES
    var arrayContactList = [CNContact]()
    var arrayContacts = [ContactModel]()
    var arrayContactsSearch = [ContactModel]()
    var arrayFavouriteContacts = [ContactModel]()
    var arrIndexSection  = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(nibWithCellClass: InviteFriendCell.self)
        btnClear.isHidden = true
        lblNoData.isHidden = true
        
        txtSearch.isUserInteractionEnabled = true
        lblNoData.isHidden = true
        lblNoData.text = "No contacts to display."
        lblNoData.textColor = Theme.colors.textColor
        
        setupUI()
        fetchContacts()
        setupData()

    }
    
    //MARK:- Functions
    override func setupUI() {
        txtSearch.delegate = self
        viewSearch.layer.cornerRadius = 25.0
        viewSearch.clipsToBounds = true
        
        //        txtSearch.clearButtonMode = .whileEditing
        txtSearch.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: UIControl.Event.editingChanged)
        
        tableView.register(nibWithCellClass: CountryCell.self)
        tableView.reloadData()
    }
    
    override func setupData() {
        arrayContacts = [ContactModel]()
        for contact in arrayContactList {
            let contactData = ContactModel()
            contactData.contactName = contact.givenName + " " + contact.familyName
            
            if let phoneNumber = contact.phoneNumbers.first?.value {
                contactData.contactNumber = phoneNumber.stringValue
            }
            
            if let imageData = contact.thumbnailImageData, let contactImage = UIImage(data: imageData) {
                contactData.contactImage = contactImage
            }
            else {
                contactData.contactImage = UIImage(named: "userIcon")
            }
                
            arrayContacts.append(contactData)
        }
        
        arrayContacts = arrayContacts.filter { $0.contactNumber.trim.count > 0 }
        
        arrayContactsSearch = arrayContacts
        // arrayFavouriteContacts = arrayContacts
        tableView.reloadData()
        lblNoData.isHidden = arrayContactsSearch.count != 0
        tableView.isHidden = arrayContactsSearch.count == 0
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        btnClear.isHidden = textField.text?.count == 0
    }
    
    func fetchContacts() {
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactThumbnailImageDataKey
            ] as [Any]

        let fetchRequest = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        fetchRequest.sortOrder = CNContactSortOrder.givenName
        let store = CNContactStore()
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, stop) -> Void in
                self.arrayContactList.append(contact)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // arrayContactList = arrayContactList.sorted(by: { $0.givenName > $1.givenName })
        self.setupData()
    }
    
    
    //MARK:- IBAction Methods
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearSearchClicked(sender: UIButton) {
        txtSearch.text = ""
        arrayContactsSearch = arrayContacts
        btnClear.isHidden = true
        lblNoData.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    @IBAction func onTappedContinue(_ sender: UIButton) {
        
        
    }
    
}

// MARK:- UITextFieldDelegate
extension ContactVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            print("Search text :- ",updatedText)
            
//            // Segment Tracking
//            let traits = ["userId":LoginDataModel.currentUser?.UserID ?? "",
//                          "searchKeyword":updatedText]
//            SegmentTracking.shared.trackEvent(name: "Contact Searched", traits: traits, trackingType: .track)
            
            arrayContactsSearch = arrayContacts.filter({ (model:ContactModel) -> Bool in
                return model.contactName.lowercased().contains(updatedText.lowercased())
            })
            
            if updatedText.trim.count == 0 {
                arrayContactsSearch = arrayContacts
            }
            if arrayContactsSearch.count > 0 {
                lblNoData.isHidden = true
            }
            else {
                lblNoData.isHidden = false
                lblNoData.text = "Couldn't find " + updatedText + " Try searching again"
            }
            
            lblNoData.isHidden = arrayContactsSearch.count != 0
            tableView.isHidden = arrayContactsSearch.count == 0
            tableView.reloadData()
        }
        
        return true
    }
    
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension ContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }
     func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.arrIndexSection
    }
     func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return index
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayContactsSearch.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrIndexSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withClass: InviteFriendCell.self)
        cell.configureCell(data: arrayContactsSearch[indexPath.row])

            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 68
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

         //For Header Background Color
         view.tintColor = .white

        // For Header Text Color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
        header.backgroundColor = .white
    }
    
    
    
}
