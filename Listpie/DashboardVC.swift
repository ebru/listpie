//
//  DashboardVC.swift
//  Listpie
//
//  Created by Ebru on 14/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class DashboardVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyDataView: UIStackView!
    
    var listArray = [List]()
    let currentUserID = (Auth.auth().currentUser?.uid)!
    var refresher: UIRefreshControl!
    var activeRow = 0
    
    // Custom Functions
    @objc func refresh() {
        DataService.instance.getAllFollowedLists(forUID: currentUserID) { (returnedListArray) in
            self.listArray.removeAll()
            self.listArray = returnedListArray.reversed()
            
            if self.listArray.count >= 1 {
                self.tableView.isHidden = false
                self.emptyDataView.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.emptyDataView.isHidden = false
            }
        
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
        }
    }
    
    func reloadListData() {
        DataService.instance.getAllFollowedLists(forUID: currentUserID) { (returnedListArray) in
            self.listArray.removeAll()
            self.listArray = returnedListArray.reversed()
            
            if self.listArray.count >= 1 {
                self.tableView.isHidden = false
                self.emptyDataView.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.emptyDataView.isHidden = false
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dashboard"
        tableView.isHidden = true
        emptyDataView.isHidden = true
        
        SVProgressHUD.show(withStatus: "Loading...")
        
        DataService.instance.getAllFollowedLists(forUID: currentUserID) { (returnedListArray) in
            self.listArray.removeAll()
            self.listArray = returnedListArray.reversed()
            
            if self.listArray.count >= 1 {
                self.tableView.isHidden = false
                self.emptyDataView.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.emptyDataView.isHidden = false
            }
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(DashboardVC.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadListData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_LIST {
            let listVC = segue.destination as! ListVC
            listVC.list = listArray[activeRow]
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }
}
// Extensions
extension DashboardVC: UITableViewDataSource, UITableViewDelegate {
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
        performSegue(withIdentifier: TO_LIST, sender: self)
    }
}
