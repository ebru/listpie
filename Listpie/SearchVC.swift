//
//  SearchVC.swift
//  Listpie
//
//  Created by Ebru on 14/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SearchVC: UIViewController {
    
    // Outlets

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var userTableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var notFoundView: UIStackView!
    @IBOutlet weak var typeSomethingView: UIStackView!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var userBtn: UIButton!
    
    // Actions
    @IBAction func listBtnWasPressed(_ sender: Any) {
        listBtn.setSelectedColor()
        userBtn.setDeselectedColor()
        selectedListBtn = true
        self.listTableView.isHidden = false
        self.userTableView.isHidden = true
        
        if (searchTextField!.text != "") {
            SVProgressHUD.show()
            
            DataService.instance.getSearchLists(forSearchQuery: searchTextField.text!, forUID: currentUserID) { (returnedListArray) in
                self.searchListArray.removeAll()
                self.searchListArray = returnedListArray
                
                if self.searchListArray.count >= 1 {
                    self.listTableView.isHidden = false
                    self.typeSomethingView.isHidden = false
                    self.notFoundView.isHidden = true
                } else {
                    self.listTableView.isHidden = true
                    self.typeSomethingView.isHidden = true
                    self.notFoundView.isHidden = false
                }
                
                SVProgressHUD.dismiss()
                self.listTableView.reloadData()
            }
        } else {
             self.listTableView.isHidden = true
        }
    }
    
    @IBAction func userBtnWasPressed(_ sender: Any) {
        userBtn.setSelectedColor()
        listBtn.setDeselectedColor()
        selectedListBtn = false
        self.listTableView.isHidden = true
        self.userTableView.isHidden = false
        
        if (searchTextField!.text != "") {
            SVProgressHUD.show()
            
            DataService.instance.getSearchUsers(forSearchQuery: searchTextField.text!, forUID: currentUserID) { (returnedUserArray) in
                self.searchUserArray.removeAll()
                self.searchUserArray = returnedUserArray
                
                if self.searchUserArray.count >= 1 {
                    self.userTableView.isHidden = false
                    self.typeSomethingView.isHidden = false
                    self.notFoundView.isHidden = true
                } else {
                    self.userTableView.isHidden = true
                    self.typeSomethingView.isHidden = true
                    self.notFoundView.isHidden = false
                }
                
                SVProgressHUD.dismiss()
                self.userTableView.reloadData()
            }
        } else {
            self.userTableView.isHidden = true
        }
    }
    
    var searchListArray = [List]()
    var searchUserArray = [User]()
    
    let currentUserID = (Auth.auth().currentUser?.uid)!
    var activeRow = 0
    
    var selectedListBtn = true

    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        userTableView.dataSource = self
        userTableView.delegate = self
        
        self.listTableView.isHidden = true
        self.userTableView.isHidden = true
        self.typeSomethingView.isHidden = false
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.navigationItem.title = "Search"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_LIST_FROM_SEARCH {
            let listVC = segue.destination as! ListVC
            listVC.list = searchListArray[activeRow]
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
        if segue.identifier == TO_PROFILE_FROM_SEARCH {
            let profileVC = segue.destination as! ProfileVC
            profileVC.userID = searchUserArray[activeRow].ID
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }
    
    // Custom Functions
    
    @objc func textFieldDidChange() {
        if searchTextField.text == "" {
            if selectedListBtn {
                searchListArray = []
                self.listTableView.isHidden = true
                self.typeSomethingView.isHidden = false
                self.notFoundView.isHidden = true
                
                listTableView.reloadData()
            } else {
                searchUserArray = []
                self.userTableView.isHidden = true
                self.typeSomethingView.isHidden = false
                self.notFoundView.isHidden = true
                
                userTableView.reloadData()
            }
        } else if selectedListBtn {
            DataService.instance.getSearchLists(forSearchQuery: searchTextField.text!, forUID: currentUserID) { (returnedListArray) in
                self.searchListArray.removeAll()
                self.searchListArray = returnedListArray
                
                if self.searchListArray.count >= 1 {
                    self.listTableView.isHidden = false
                    self.typeSomethingView.isHidden = false
                    self.notFoundView.isHidden = true
                } else {
                    self.listTableView.isHidden = true
                    self.typeSomethingView.isHidden = true
                    self.notFoundView.isHidden = false
                }
                
                self.listTableView.reloadData()
            }
        } else {
            DataService.instance.getSearchUsers(forSearchQuery: searchTextField.text!, forUID: currentUserID) { (returnedUserArray) in
                self.searchUserArray.removeAll()
                self.searchUserArray = returnedUserArray
                
                if self.searchUserArray.count >= 1 {
                    self.userTableView.isHidden = false
                    self.typeSomethingView.isHidden = false
                    self.notFoundView.isHidden = true
                } else {
                    self.userTableView.isHidden = true
                    self.typeSomethingView.isHidden = true
                    self.notFoundView.isHidden = false
                }
                
                self.userTableView.reloadData()
            }
        }
    }
}

// Extensions
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var count = Int()
        
        if tableView == listTableView {
            count = 1
        }
        
        if tableView == userTableView {
            count = 1
        }
        
        return count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = Int()
        
        if tableView == listTableView {
            count = searchListArray.count
        }
        
        if tableView == userTableView {
            count = searchUserArray.count
        }
        
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == listTableView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListSearchCell", for: indexPath) as? ListSearchCell {
            cell.configureCell(searchList: searchListArray[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        
        if tableView == userTableView,
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as? UserSearchCell {
            cell.configureCell(searchUser: searchUserArray[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == listTableView {
            activeRow = indexPath.row
            performSegue(withIdentifier: TO_LIST_FROM_SEARCH, sender: self)
        }
        if tableView == userTableView {
            activeRow = indexPath.row
            performSegue(withIdentifier: TO_PROFILE_FROM_SEARCH, sender: self)
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
