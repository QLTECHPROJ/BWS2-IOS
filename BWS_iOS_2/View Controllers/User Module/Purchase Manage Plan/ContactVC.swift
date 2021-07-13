//
//  ContactVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 28/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

class ContactVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    
    
    // MARK:- VARIABLES
    var arrayContactList = [CNContact]()
    var arrayContacts = [ContactModel]()
    var arrayContactsSearch = [ContactModel]()
    var strURL:String?
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let traits = ["userId":CoUserDataModel.currentUserId,
                      "MainAccountId":CoUserDataModel.currentMainAccountId,
                      "referLink":CoUserDataModel.currentMainAccountId]
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.invite_friend, traits: traits, trackingType: .screen)
        
        tableView.register(nibWithCellClass: InviteFriendCell.self)
        btnClear.isHidden = true
        lblNoData.isHidden = true
        
        txtSearch.isUserInteractionEnabled = true
        lblNoData.isHidden = true
        lblNoData.text = Theme.strings.no_contacts_to_display
        lblNoData.textColor = Theme.colors.textColor
        
        setupUI()
        fetchContacts()
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        txtSearch.delegate = self
        viewSearch.layer.cornerRadius = 10
        viewSearch.clipsToBounds = true
        
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
            } else {
                contactData.contactImage = UIImage(named: "userIcon")
            }
            
            arrayContacts.append(contactData)
        }
        
        arrayContacts = arrayContacts.filter { $0.contactNumber.trim.count > 0 }
        
        arrayContactsSearch = arrayContacts
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
    
    func sendSMS(contact : ContactModel) {
        callInviteUserAPI(contact: contact)
    }
    
    func sendMessage(contact : ContactModel) {
        if (MFMessageComposeViewController.canSendText()) {
           
            let shareText = String(format:"Hey, I am loving using the Brain Wellness App. You can develop yourself in the comfort of your home while you sleep and gain access to over 75 audio programs helping you to live inspired and improve your mental wellbeing. I would like to invite you to try it.  Sign up using the link %@",strURL ?? "")
            
            let controller = MFMessageComposeViewController()
            controller.body = shareText
            controller.recipients = [contact.contactNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
            
            // Segment Tracking
            let traits = ["userId":CoUserDataModel.currentUserId,
                          "MainAccountId":CoUserDataModel.currentMainAccountId,
                          "referLink":strURL ?? "",
                          "shareText":shareText,
                          "contactName":contact.contactName,
                          "contactNumber":contact.contactNumber]
            SegmentTracking.shared.trackEvent(name: SegmentTracking.eventNames.invite_friend_clicked, traits: traits, trackingType: .track)
        } else {
            showAlertToast(message: Theme.strings.alert_cannot_send_message)
        }
    }
    
    
    // MARK:- ACTIONS
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
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: UserListVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
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
            
            // Segment Tracking
            let traits = ["userId":CoUserDataModel.currentUserId,
                          "MainAccountId":CoUserDataModel.currentMainAccountId,
                          "searchKeyword":updatedText]
            SegmentTracking.shared.trackEvent(name: SegmentTracking.eventNames.contact_searched, traits: traits, trackingType: .track)
            
            arrayContactsSearch = arrayContacts.filter({ (model:ContactModel) -> Bool in
                return model.contactName.lowercased().contains(updatedText.lowercased())
            })
            
            if updatedText.trim.count == 0 {
                arrayContactsSearch = arrayContacts
            }
            
            if arrayContactsSearch.count > 0 {
                lblNoData.isHidden = true
            } else {
                lblNoData.isHidden = false
                lblNoData.text = Theme.strings.alert_search_term_not_found
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayContactsSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: InviteFriendCell.self)
        cell.configureCell(data: arrayContactsSearch[indexPath.row])
        cell.inviteClicked = {
            self.sendSMS(contact: self.arrayContactsSearch[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
}


// MARK:- MFMessageComposeViewControllerDelegate
extension ContactVC : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        switch result {
        case .cancelled:
            showAlertToast(message: "Message Sending Cancelled")
        case .sent:
            let aVC = AppStoryBoard.account.viewController(viewControllerClass:ManageUserVC.self)
            aVC.isCome = "SMS"
            self.navigationController?.pushViewController(aVC, animated: true)
        case .failed:
            showAlertToast(message: "Message Sening Failed")
        default:
            showAlertToast(message: "Message Sening Failed")
        }
    }
    
}
