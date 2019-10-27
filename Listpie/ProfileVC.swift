//
//  ProfileVC.swift
//  Listpie
//
//  Created by Ebru on 14/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileVC: UIViewController {
    
    var userID = String()
    var isCurrentUser = Bool()
    let currentUserID = (Auth.auth().currentUser?.uid)!
    var profileID = String()
    var user = User()
    var refresher: UIRefreshControl!
    var activeRow = 0
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var emptyDataView: UIStackView!
    
    // Actions
    @IBAction func logout(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Log out of the account?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Log Out", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
                do {
                    try Auth.auth().signOut()
                    self.performSegue(withIdentifier: LOGOUT_SEGUE, sender: self)
                } catch {
                    print(error)
                }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func followOrEditBtnWasPressed(_ sender: Any) {
        if isCurrentUser {
            performSegue(withIdentifier: TO_EDIT_PROFILE, sender: self)
        } else {
            if user.isFollowed {
                DataService.instance.removeUserFromFollowings(withUserID: profileID, forUID: currentUserID) { (isRemoved) in
                    self.reloadUserData()
                }
            } else {
                DataService.instance.followUser(withUserID: profileID, forUID: currentUserID) { (isFollowed) in
                    self.reloadUserData()
                }
            }
        }
    }
    
    // Custom Functions
    @objc func refresh() {
        DataService.instance.getUser(forUID: profileID, forCID: currentUserID) { (returnedUser) in
            self.user = returnedUser
            
            if self.user.lists.count >= 1 {
                self.emptyDataView.isHidden = true
            } else {
                self.emptyDataView.isHidden = false
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
        }
    }
    
    func reloadUserData() {
        DataService.instance.getUser(forUID: profileID, forCID: currentUserID) { (returnedUser) in
            self.user = returnedUser
            self.navigationItem.title = self.user.username
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
    }

    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataView.isHidden = true
        
        SVProgressHUD.show()
        
        if userID.isEmpty {
            profileID = currentUserID
            logoutButton.isEnabled = true
            logoutButton.tintColor = .black
            isCurrentUser = true
        } else if userID == currentUserID {
            profileID = currentUserID
            logoutButton.isEnabled = false
            logoutButton.tintColor = .clear
            isCurrentUser = true
        } else {
            profileID = userID
            logoutButton.isEnabled = false
            logoutButton.tintColor = .clear
            isCurrentUser = false
        }
        
        DataService.instance.getUser(forUID: profileID, forCID: currentUserID) { (returnedUser) in
            self.user = returnedUser
            self.navigationItem.title = self.user.username
            
            if self.user.lists.count >= 1 {
                self.emptyDataView.isHidden = true
            } else {
                self.emptyDataView.isHidden = false
            }
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(ProfileVC.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadUserData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_EDIT_PROFILE {
            let editProfileVC = segue.destination as! EditProfileVC
            editProfileVC.user = user
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
        if segue.identifier == TO_LIST_FROM_PROFILE {
            let listVC = segue.destination as! ListVC
            
            if !user.lists.isEmpty {
                listVC.list = user.lists[activeRow]
            } else {
                listVC.list = List()
            }
            
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }
}
// Extensions
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return user.lists.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell") as? UserProfileCell else { return UITableViewCell() }
            
            cell.configureCell(user: user, isCurrentUser: isCurrentUser)
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileListsLabelCell") as? UserProfileListsLabelCell else { return UITableViewCell() }
            
            cell.listsLbl.text = "Lists"
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileListsCell") as? UserProfileListsCell else { return UITableViewCell() }
            
            cell.configureCell(list: user.lists[indexPath.row])
            cell.selectionStyle = .none
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            activeRow = indexPath.row
            performSegue(withIdentifier: TO_LIST_FROM_PROFILE, sender: self)
        default:
            break
        }
    }
}
