//
//  PlaylistAudiosVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlaylistAudiosVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var btnAddAudio: UIButton!
    @IBOutlet weak var viewAddAudio: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var moonView: UIView!
    @IBOutlet weak var moonView2: UIView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPlatlistName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    
    //MARK:- Variable
    var isCome:String = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addAudio()
        setupUI()
        
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableView.register(UINib(nibName:"SelfDevCell", bundle: nil), forCellReuseIdentifier:"SelfDevCell")
        collectionView.register(UINib(nibName:"tagCVCell", bundle: nil), forCellWithReuseIdentifier:"tagCVCell")
        tableView.tableHeaderView = viewHeader
    }
    
    func addAudio() {
        
        if isCome == "PlayList" {
            collectionView.isHidden = false
            lblTitle.isHidden = false
            btnEdit.isHidden = false
            moonView.isHidden = false
            moonView2.isHidden = false
             viewSearch.isHidden = false
            collectionHeight.constant = 100
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height:0)
            viewHeader.frame.size = CGSize(width: tableView.frame.width, height:600)
        }else if isCome == "Header" {
            collectionView.isHidden = true
            lblTitle.isHidden = true
            btnEdit.isHidden = true
            moonView.isHidden = true
            moonView2.isHidden = true
            viewSearch.isHidden = false
            collectionHeight.constant = 0
            viewHeader.frame.size = CGSize(width: tableView.frame.width, height:500)
        }
        else {
            collectionView.isHidden = true
            lblTitle.isHidden = true
            btnEdit.isHidden = true
            moonView.isHidden = true
            moonView2.isHidden = true
            viewSearch.isHidden = true
            collectionHeight.constant = 0
            tableView.tableFooterView = viewAddAudio
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height:200)
            viewHeader.frame.size = CGSize(width: tableView.frame.width, height:500)
        }
    }
    
    //MARK:- IBAction
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlaylistAudiosVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCome == "PlayList" || isCome == "Header"{
            return 10
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier:"SelfDevCell", for: indexPath) as!  SelfDevCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "sapna"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Notification Times"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.backgroundColor = .white
        headerView.addSubview(label)
        
        return headerView
    }
    
}

extension PlaylistAudiosVC : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell:tagCVCell = (collectionView.dequeueReusableCell(withReuseIdentifier:"tagCVCell", for: indexPath) as? tagCVCell)!
        return cell
        
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width/3, height: 150)
    }
    
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
