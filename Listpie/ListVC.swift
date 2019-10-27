//
//  ListVC.swift
//  Listpie
//
//  Created by Ebru on 02/11/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ListVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Actions
    @IBAction func addListToFavorites(_ sender: Any) {
        if list.isFavorited {
            DataService.instance.removeListFromFavorites(withListID: list.ID, forUID: currentUserID, completion: { (isRemoved) in
                self.reloadSecondSection()
            })
        } else {
            DataService.instance.addListToFavorites(withListID: list.ID, forUID: currentUserID) { (isAdded) in
                self.reloadSecondSection()
            }
        }
    }
    
    @IBAction func authorBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_USER_PROFILE_FROM_LIST, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_USER_PROFILE_FROM_LIST {
            let profileVC = segue.destination as! ProfileVC
            profileVC.userID = list.authorID
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }
    
    let currentUserID = (Auth.auth().currentUser?.uid)!
    var list = List()
    var itemArray = [Item]()
    
    var refresher: UIRefreshControl!

    // Custom Functions
    @objc func refresh() {
        DataService.instance.getList(forID: list.ID, forUID: currentUserID) { (returnedList) in
            self.list = returnedList
            self.itemArray = self.list.items
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
        }
    }
    func reloadListData(indexPath: [IndexPath]) {
        DataService.instance.getList(forID: list.ID, forUID: currentUserID) { (returnedList) in
            self.list = returnedList
            self.itemArray = self.list.items
            
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: indexPath, with: .none)
                self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
            }
        }
    }
    func reloadSecondSection() {
        DataService.instance.getList(forID: list.ID, forUID: currentUserID) { (returnedList) in
            self.list = returnedList
            self.itemArray = self.list.items
            
            DispatchQueue.main.async {
                self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
            }
        }
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List"

        let itemsLoadingIndicator = UIActivityIndicatorView()
        self.view.addActivityIndicatorToView(activityIndicator: itemsLoadingIndicator, shiftX: 0, shiftY: 80, style: .gray)
        
        DataService.instance.getItemsOfList(forIDs: list.itemIDs, forUID: currentUserID, handler: { (returnedItemArray) in
            self.itemArray = returnedItemArray
            
            DispatchQueue.main.async {
                itemsLoadingIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        })
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(ListVC.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadSecondSection()
    }
}
// Extensions
extension ListVC: UITableViewDataSource, UITableViewDelegate {
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
                return itemArray.count
            default:
                return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListHeaderCell") as? ListHeaderCell else { return UITableViewCell() }
             cell.configureCell(listTitle: list.title, listDescription: list.description, listImageDownloadURL: list.imageDownloadURL, listCategory: list.category, isPublic: list.isPublic)
             cell.selectionStyle = .none
             return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListSecondCell") as? ListSecondCell else { return UITableViewCell() }
            cell.configureCell(authorName: list.authorName, authorProfilePicture: list.authorProfilePicture, completedItemCount: list.completedItemCount ,listCount: list.itemIDs.count)
            
            if list.isFavorited {
                cell.addListToFavoritesBtn.setTitle("Favorited", for: .normal)
                cell.addListToFavoritesBtn.setTitleColor(UIColor(red:0.37, green:0.55, blue:0.16, alpha:1.0), for: .normal)
            } else {
                cell.addListToFavoritesBtn.setTitle("+ Add to Favorites", for: .normal)
                cell.addListToFavoritesBtn.setTitleColor(.black, for: .normal)
            }
            
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemsCell") as? ListItemsCell else { return UITableViewCell() }
            
            cell.configureCell(itemNo: indexPath.row + 1, item: itemArray[indexPath.row])
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
            let cell = self.tableView.cellForRow(at: indexPath) as! ListItemsCell
            let currentItem = itemArray[indexPath.row]
            
            if currentItem.isCompleted {
                cell.itemCompleteView.isHidden = true
                cell.itemCheckImageView.image = UIImage(named: "check-circle")
                
                DataService.instance.removeItemFromCompleted(withItemID: currentItem.ID, forUID: currentUserID, removingComplete: { (isRemoved) in
                    self.reloadListData(indexPath: [indexPath])
                })
            } else {
                cell.itemCompleteView.isHidden = false
                cell.itemCheckImageView.image = UIImage(named: "check-circle-true")
                
                DataService.instance.completeItem(withItemID: currentItem.ID, forUID: currentUserID, completion: { (isCompleted) in
                    self.reloadListData(indexPath: [indexPath])
                })
            }
        default:
            break
        }
    }
}
