//
//  UserListsVC.swift
//  Listpie
//
//  Created by Ebru on 14/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class UserListsVC: UIViewController {
    
    var selectedCreatedBtn = true
    
    var listArray = [List]()
    let currentUserID = (Auth.auth().currentUser?.uid)!
    var refresher: UIRefreshControl!
    var activeRow = 0
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesBtn: UIButton!
    @IBOutlet weak var createdBtn: UIButton!
    @IBOutlet weak var emptyFavoritedDataView: UIStackView!
    @IBOutlet weak var emptyCreatedDataView: UIStackView!
    
    @IBOutlet var addListBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var goToSearchBtn: UIButton!
    
    // Actions
    @IBAction func unwindToUserLists(segue: UIStoryboardSegue) { }
    
    @IBAction func favoritesBtnWasPressed(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = nil
        favoritesBtn.setSelectedColor()
        createdBtn.setDeselectedColor()
        selectedCreatedBtn = false
        reloadListData()
    }
    
    @IBAction func createdBtnWasPressed(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = self.addListBarBtn
        createdBtn.setSelectedColor()
        favoritesBtn.setDeselectedColor()
        selectedCreatedBtn = true
        reloadListData()
    }
    
    @IBAction func goToSearchBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_SEARCH_FROM_FAVORITES, sender: self)
    }
    
    // Custom Functions
    @objc func refresh() {
        if selectedCreatedBtn {
            DataService.instance.getAllCreatedLists(forUID: currentUserID) { (returnedListArray) in
                self.listArray.removeAll()
                self.listArray = returnedListArray.reversed()
                
                if self.listArray.count >= 1 {
                    self.tableView.isHidden = false
                    self.emptyCreatedDataView.isHidden = true
                    self.emptyFavoritedDataView.isHidden = false
                } else {
                    self.tableView.isHidden = true
                    self.emptyCreatedDataView.isHidden = false
                    self.emptyFavoritedDataView.isHidden = true
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                }
            }
        } else {
            DataService.instance.getAllFavoritedLists(forUID: currentUserID) { (returnedListArray) in
                self.listArray.removeAll()
                self.listArray = returnedListArray.reversed()
                
                if self.listArray.count >= 1 {
                    self.tableView.isHidden = false
                    self.emptyFavoritedDataView.isHidden = true
                    self.emptyCreatedDataView.isHidden = false
                } else {
                    self.tableView.isHidden = true
                    self.emptyFavoritedDataView.isHidden = false
                    self.emptyCreatedDataView.isHidden = true
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                }
            }
        }
    }
    func reloadListData() {
        SVProgressHUD.show()
        
        if selectedCreatedBtn {
            DataService.instance.getAllCreatedLists(forUID: currentUserID) { (returnedListArray) in
                self.listArray.removeAll()
                self.listArray = returnedListArray.reversed()
                
                if self.listArray.count >= 1 {
                    self.tableView.isHidden = false
                    self.emptyCreatedDataView.isHidden = true
                    self.emptyFavoritedDataView.isHidden = false
                } else {
                    self.tableView.isHidden = true
                    self.emptyCreatedDataView.isHidden = false
                    self.emptyFavoritedDataView.isHidden = true
                }
                
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
            }
        } else {
            DataService.instance.getAllFavoritedLists(forUID: currentUserID) { (returnedListArray) in
                self.listArray.removeAll()
                self.listArray = returnedListArray.reversed()
                
                if self.listArray.count >= 1 {
                    self.tableView.isHidden = false
                    self.emptyFavoritedDataView.isHidden = true
                    self.emptyCreatedDataView.isHidden = false
                } else {
                    self.tableView.isHidden = true
                    self.emptyFavoritedDataView.isHidden = false
                    self.emptyCreatedDataView.isHidden = true
                }
                
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        emptyCreatedDataView.isHidden = true
        emptyFavoritedDataView.isHidden = true

        self.title = "Library"
        
        createdBtn.setSelectedColor()
        favoritesBtn.setDeselectedColor()
        
        self.goToSearchBtn.backgroundColor = .clear
        self.goToSearchBtn.setTitleColor(FOLLOW_BTN_COLOR, for: .normal)
        self.goToSearchBtn.layer.borderWidth = 1
        self.goToSearchBtn.layer.borderColor = FOLLOW_BTN_COLOR.cgColor
        
        SVProgressHUD.show(withStatus: "Loading...")
        
        if selectedCreatedBtn {
            DataService.instance.getAllCreatedLists(forUID: currentUserID) { (returnedListArray) in
                self.listArray.removeAll()
                self.listArray = returnedListArray.reversed()
                
                if self.listArray.count >= 1 {
                    self.tableView.isHidden = false
                    self.emptyCreatedDataView.isHidden = true
                    self.emptyFavoritedDataView.isHidden = false
                } else {
                    self.tableView.isHidden = true
                    self.emptyCreatedDataView.isHidden = false
                    self.emptyFavoritedDataView.isHidden = true
                }
                
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
            }
        } else {
            self.navigationItem.rightBarButtonItem = nil
            
            DataService.instance.getAllFavoritedLists(forUID: currentUserID) { (returnedListArray) in
                self.listArray.removeAll()
                self.listArray = returnedListArray.reversed()
                
                if self.listArray.count >= 1 {
                    self.tableView.isHidden = false
                    self.emptyFavoritedDataView.isHidden = true
                    self.emptyCreatedDataView.isHidden = false
                } else {
                    self.tableView.isHidden = true
                    self.emptyFavoritedDataView.isHidden = false
                    self.emptyCreatedDataView.isHidden = true
                }
                
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
            }
            
        }
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(UserListsVC.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_LIST_FROM_USER_LISTS {
            let listVC = segue.destination as! ListVC
            listVC.list = listArray[activeRow]
        }
        let barBtn = UIBarButtonItem()
        barBtn.title = ""
        navigationItem.backBarButtonItem = barBtn
    }
    override func viewWillAppear(_ animated: Bool) {
        if selectedCreatedBtn {
            createdBtn.setSelectedColor()
            favoritesBtn.setDeselectedColor()
        } else {
            createdBtn.setDeselectedColor()
            favoritesBtn.setSelectedColor()
        }
        
        reloadListData()
    }
    
}

// Extensions
extension UserListsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell() }
        
        let list = listArray[indexPath.row]
        cell.configureCell(list: list)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activeRow = indexPath.row
        performSegue(withIdentifier: TO_LIST_FROM_USER_LISTS, sender: self)
    }
}
