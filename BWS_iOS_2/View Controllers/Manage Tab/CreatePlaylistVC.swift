//
//  CreatePlaylistVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 31/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

protocol CreatePlayListVCDelegate {
    func didCreateNewPlaylist(createdPlaylistID : String)
}

class CreatePlaylistVC: BaseViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    
    
    //MARK:- VARIABLE
    var objPlaylist : PlaylistDetailsModel?
    var audioToAdd = ""
    var playlistToAdd = ""
    var delegate : CreatePlayListVCDelegate?
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        if let details = objPlaylist {
            lblTitle.text = "Rename your playlist."
            txtName.text = details.PlaylistName
            btnCreate.setTitle("SAVE", for: UIControl.State.normal)
        }
    }
    
    override func setupUI() {
        txtName.delegate = self
        if txtName.text == "" {
            buttonEnableDisable(shouldEnable: false)
        } else {
            if let details = objPlaylist, details.PlaylistName == txtName.text {
                buttonEnableDisable(shouldEnable: false)
            } else {
                buttonEnableDisable(shouldEnable: true)
            }
        }
    }
    
    func buttonEnableDisable(shouldEnable : Bool) {
        DispatchQueue.main.async {
            if shouldEnable {
                self.btnCreate.isUserInteractionEnabled = true
                self.btnCreate.backgroundColor = Theme.colors.white
                self.btnCreate.setTitleColor(Theme.colors.textColor, for: .normal)
            } else {
                self.btnCreate.isUserInteractionEnabled = false
                self.btnCreate.backgroundColor = Theme.colors.gray_7E7E7E
                self.btnCreate.setTitleColor(Theme.colors.white, for: .normal)
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func createClicked(sender : UIButton) {
        self.view.endEditing(true)
        if let name = txtName.text, name.trim.count > 0 {
            if objPlaylist != nil {
                callRenamePlaylistAPI(PlaylistName: name)
            } else {
                callCreatePlaylistAPI(PlaylistName: name)
            }
        } else {
            showAlertToast(message: Theme.strings.alert_blank_playlist_name)
        }
    }
    
    @IBAction func cancelClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITextFieldDelegate
extension CreatePlaylistVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            
            if let details = objPlaylist, details.PlaylistName.trim == updatedText {
                buttonEnableDisable(shouldEnable: false)
            } else if updatedText.trim.count > 0 {
                buttonEnableDisable(shouldEnable: true)
            } else {
                buttonEnableDisable(shouldEnable: false)
            }
        }
        
        return true
    }
    
}

