//
//  DataService.swift
//  Listpie
//
//  Created by Ebru on 27/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_LISTS = DB_BASE.child("lists")
    private var _REF_ITEMS = DB_BASE.child("items")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_LISTS: DatabaseReference {
        return _REF_LISTS
    }
    var REF_ITEMS: DatabaseReference {
        return _REF_ITEMS
    }
    
    func getLoginCredential(forInput input: String, handler: @escaping (_ email: String) -> ()) {
        if isEmail(input: input) {
            handler(input)
        } else {
            let query = REF_USERS.queryOrdered(byChild: "username").queryEqual(toValue: input)
            query.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    for userSnap in userSnapshot {
                        let userDict = userSnap.value as! [String:AnyObject]
                        handler(userDict["email"] as! String)
                    }
                } else {
                    handler("noUser")
                }
            }
        }
    }
    func createList(withTitle title: String, withDescription description: String, withVisibility isPublic: Bool, withImage image: UIImage, withCategory category: String, withCreationDate date: String, forUID uid: String, withItemNames itemNames: [String], withItemDescriptions itemDescriptions: [String], withItemImages itemImages: [UIImage], creationComplete: @escaping (_ status: Bool) -> ()) {
        
        let itemCount = itemNames.count
        var itemIDs = [String]()
        
        let group = DispatchGroup()
        
        for i in 0 ..< itemCount {
            group.enter()
            
            var downloadItemImageURL = String()
            let size = CGSize(width: 0, height: 0)
            
            if itemImages[i].size.width == size.width {
                let newItemRef = self.REF_ITEMS.childByAutoId()
                newItemRef.updateChildValues(["name": itemNames[i], "description": itemDescriptions[i], "image": downloadItemImageURL])
                itemIDs.append(newItemRef.key)
                group.leave()
            } else {
                let randomItemImageName = randomString(length: 9)
                let uploadItemImageRef = STORAGE_BASE.child("images/items/\(randomItemImageName).jpg")
                let itemImageData = UIImageJPEGRepresentation(itemImages[i], 0.8)
                
                uploadItemImageRef.putData(itemImageData!, metadata: nil) { (metaData,error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        downloadItemImageURL = metaData!.downloadURL()!.absoluteString
                        let newItemRef = self.REF_ITEMS.childByAutoId()
                        newItemRef.updateChildValues(["name": itemNames[i], "description": itemDescriptions[i], "image": downloadItemImageURL])
                        itemIDs.append(newItemRef.key)
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: .main) {
            var downloadListImageURL = DEFAULT_LIST_BACKGROUND_URL
            let size = CGSize(width: 0, height: 0)
            
            if image.size.width == size.width {
                self.REF_LISTS.childByAutoId().updateChildValues(["title": title, "description": description, "isPublic": isPublic, "image": downloadListImageURL, "category": category, "creationDate": date, "authorID": uid, "itemIDs": itemIDs])
                creationComplete(true)
            } else {
                let randomListImageName = randomString(length: 9)
                let uploadListImageRef = STORAGE_BASE.child("images/lists/\(randomListImageName).jpg")
                let listImageData = UIImageJPEGRepresentation(image, 0.8)
                
                uploadListImageRef.putData(listImageData!, metadata: nil) { (metaData,error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        downloadListImageURL = metaData!.downloadURL()!.absoluteString
                        
                        self.REF_LISTS.childByAutoId().updateChildValues(["title": title, "description": description, "isPublic": isPublic, "image": downloadListImageURL, "category": category, "creationDate": date, "authorID": uid, "itemIDs": itemIDs])
                        creationComplete(true)
                    }
                }
            }
        }
    }
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "username").value as! String)
                }
            }
        }
    }
    func getUserProfilePicture(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        var profilePicture: String!
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if user.key == uid {
                    
                    if user.childSnapshot(forPath: "profilePicture").exists() {
                        profilePicture = user.childSnapshot(forPath: "profilePicture").value as? String
                    } else {
                        profilePicture = NO_PROFILE_PICTURE_URL
                    }
                
                    handler(profilePicture)
                }
            }
        }
    }
    func getUser(forUID uid: String, forCID cid: String, handler: @escaping (_ user: User) -> ()) {
        var userToReturn: User!
        
        let group = DispatchGroup()
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if user.key == uid {
                    
                    group.enter()
                    let email = user.childSnapshot(forPath: "email").value as! String
                    let username = user.childSnapshot(forPath: "username").value as! String
                    let fullname = user.childSnapshot(forPath: "name").value as! String
                    
                    var bioDescription: String
                    
                    if user.childSnapshot(forPath: "bioDescription").exists() {
                        bioDescription = user.childSnapshot(forPath: "bioDescription").value as! String
                    } else {
                        bioDescription = String()
                    }
                    
                    var profilePictureDownloadURL: String
                    
                    if user.childSnapshot(forPath: "profilePicture").exists() {
                        profilePictureDownloadURL = user.childSnapshot(forPath: "profilePicture").value as! String
                    } else {
                        profilePictureDownloadURL = String()
                    }
                    
                    var isFollowed = Bool()
                    
                    self.REF_USERS.child(cid).child("follows").observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.hasChild(uid){
                            isFollowed = true
                        } else {
                            isFollowed = false
                        }
                    }
                    
                    var followerIDs = [String]()
                    
                    var followIDs = [String]()
                    
                    self.REF_USERS.child(uid).child("followers").observeSingleEvent(of: .value) { (followerSnapshot) in
                        guard let followerSnapshot = followerSnapshot.children.allObjects as? [DataSnapshot] else { return }
                        
                        for follower in followerSnapshot {
                            followerIDs.append(follower.key)
                        }
                    }
                    
                    self.REF_USERS.child(uid).child("follows").observeSingleEvent(of: .value) { (followSnapshot) in
                        guard let followSnapshot = followSnapshot.children.allObjects as? [DataSnapshot] else { return }
                        
                        for follow in followSnapshot {
                            followIDs.append(follow.key)
                        }
                    }
                    
                    var lists = [List]()
                    
                    self.getUserProfileLists(forUID: uid, forCID: cid) { (returnedListArray) in
                        lists = returnedListArray.reversed()
                        
                        userToReturn = User(ID: uid, email: email, username: username, fullname: fullname, bioDescription: bioDescription, profilePictureDownloadURL: profilePictureDownloadURL, lists: lists, isFollowed: isFollowed, followerIDs: followerIDs, followIDs: followIDs)
                        
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                handler(userToReturn)
            }
        }
    }
    func getList(forID id: String, forUID uid: String, handler: @escaping (_ list: List) -> ()) {
        var listToReturn = List()
        
        let group = DispatchGroup()
        
        REF_LISTS.observeSingleEvent(of: .value) { (listSnapshot) in
            guard let listSnapshot = listSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for list in listSnapshot {
                if list.key == id {
                    
                    group.enter()
                    let ID = list.key as String
                    let title = list.childSnapshot(forPath: "title").value as! String
                    let description = list.childSnapshot(forPath: "description").value as! String
                    let isPublic = list.childSnapshot(forPath: "isPublic").value as! Bool
                    let imageDownloadURL = list.childSnapshot(forPath: "image").value as! String
                    let category = list.childSnapshot(forPath: "category").value as! String
                    let creationDate = list.childSnapshot(forPath: "creationDate").value as! String
                    let itemIDs = list.childSnapshot(forPath: "itemIDs").value as! [String]
                    let authorID = list.childSnapshot(forPath: "authorID").value as! String
                    
                    var completedItemCount = 0
                    
                    for itemID in itemIDs {
                        self.REF_ITEMS.observeSingleEvent(of: .value) { (itemSnapshot) in
                            guard let itemSnapshot = itemSnapshot.children.allObjects as? [DataSnapshot] else { return }
                            
                            for item in itemSnapshot {
                                if item.key == itemID {
                                    if (item.childSnapshot(forPath: "users/\(uid)").value as? Bool) != nil {
                                        completedItemCount += 1
                                    }
                                }
                            }
                        }
                    }
                    var isFavorited = Bool()
                    
                    self.REF_USERS.child(uid).child("lists").observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.hasChild(ID){
                            isFavorited = true
                        } else {
                            isFavorited = false
                        }
                    }
                    
                    self.getUsername(forUID: authorID, handler: { (returnedAuthorName) in
                        self.getItemsOfList(forIDs: itemIDs, forUID: uid, handler: { (returnedItemArray) in
                            self.getUserProfilePicture(forUID: authorID, handler: { (returnedUserProfilePicture) in
                                listToReturn = List(ID: ID, title: title, description: description, isPublic: isPublic, imageDownloadURL: imageDownloadURL, category: category, authorID: authorID, authorName: returnedAuthorName, authorProfilePicture: returnedUserProfilePicture, creationDate: creationDate, itemIDs: itemIDs, items: returnedItemArray, completedItemCount: completedItemCount, isFavorited: isFavorited)
                                
                                group.leave()
                            })
                        })
                    })
                }
            }
            group.notify(queue: .main) {
                handler(listToReturn)
            }
        }
    }
    func getItemsOfList(forIDs ids: [String], forUID uid: String, handler: @escaping (_ items: [Item]) -> ()) {
        var itemArray = [Item]()
        
        REF_ITEMS.observeSingleEvent(of: .value) { (itemSnapshot) in
            for id in ids {
                guard let itemSnapshot = itemSnapshot.children.allObjects as? [DataSnapshot] else { return }
                
                for item in itemSnapshot {
                    if item.key == id {
                        let ID = item.key as String
                        let name = item.childSnapshot(forPath: "name").value as! String
                        
                        var description: String
                        
                        if item.childSnapshot(forPath: "description").exists() {
                            description = item.childSnapshot(forPath: "description").value as! String
                        } else {
                            description = String()
                        }
                        
                        var imageDownloadURL: String
                        
                        if item.childSnapshot(forPath: "image").exists() {
                            imageDownloadURL = item.childSnapshot(forPath: "image").value as! String
                        } else {
                            imageDownloadURL = String()
                        }
                        
                        var isCompleted = Bool()
                        
                        if (item.childSnapshot(forPath: "users/\(uid)").value as? Bool) != nil {
                            isCompleted = true
                        } else {
                            isCompleted = false
                        }
                        
                        let item = Item(ID: ID, name: name, description: description, imageDownloadURL: imageDownloadURL, isCompleted: isCompleted)
                        itemArray.append(item)
                    }
                }
            }
            handler(itemArray)
        }
    }
    func getAllFollowedLists(forUID uid: String, handler: @escaping (_ lists: [List]) -> ()) {
        var listArray = [List]()
        
        let group = DispatchGroup()
        
        REF_LISTS.observeSingleEvent(of: .value) { (listSnapshot) in
            guard let listSnapshot = listSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for list in listSnapshot {
                
                self.REF_USERS.child(uid).child("follows").observeSingleEvent(of: .value) { (snapshot) in
                    
                    let isFollowed = list.childSnapshot(forPath: "isPublic").value as! Bool && snapshot.hasChild(list.childSnapshot(forPath: "authorID").value as! String)
                    
                    if isFollowed {
                        
                        group.enter()
                        let ID = list.key as String
                        let title = list.childSnapshot(forPath: "title").value as! String
                        let description = list.childSnapshot(forPath: "description").value as! String
                        let isPublic = list.childSnapshot(forPath: "isPublic").value as! Bool
                        let imageDownloadURL = list.childSnapshot(forPath: "image").value as! String
                        let category = list.childSnapshot(forPath: "category").value as! String
                        let creationDate = list.childSnapshot(forPath: "creationDate").value as! String
                        let itemIDs = list.childSnapshot(forPath: "itemIDs").value as! [String]
                        let authorID = list.childSnapshot(forPath: "authorID").value as! String
                        
                        var completedItemCount = 0
                        
                        for itemID in itemIDs {
                            self.REF_ITEMS.observeSingleEvent(of: .value) { (itemSnapshot) in
                                guard let itemSnapshot = itemSnapshot.children.allObjects as? [DataSnapshot] else { return }
                                
                                for item in itemSnapshot {
                                    if item.key == itemID {
                                        if (item.childSnapshot(forPath: "users/\(uid)").value as? Bool) != nil {
                                            completedItemCount += 1
                                        }
                                    }
                                }
                            }
                        }
                        
                        self.getUsername(forUID: authorID, handler: { (returnedAuthorName) in
                            let list = List(ID: ID, title: title, description: description, isPublic: isPublic, imageDownloadURL: imageDownloadURL, category: category, authorID: authorID, authorName: returnedAuthorName, authorProfilePicture: String(), creationDate: creationDate, itemIDs: itemIDs, items: [Item](), completedItemCount: completedItemCount, isFavorited: true)
                            
                            listArray.append(list)
                            group.leave()
                        })
                    }
                    group.notify(queue: .main) {
                        handler(listArray)
                    }
                }
            }
        }
    }
    func getUserProfileLists(forUID uid: String, forCID cid: String, handler: @escaping (_ lists: [List]) -> ()) {
        var listArray = [List]()
        
        let group = DispatchGroup()
        
        REF_LISTS.observeSingleEvent(of: .value) { (listSnapshot) in
            guard let listSnapshot = listSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for list in listSnapshot {
                
                if list.childSnapshot(forPath: "authorID").value as! String == uid {
                    
                    group.enter()
                    let ID = list.key as String
                    let title = list.childSnapshot(forPath: "title").value as! String
                    let description = list.childSnapshot(forPath: "description").value as! String
                    let isPublic = list.childSnapshot(forPath: "isPublic").value as! Bool
                    let imageDownloadURL = list.childSnapshot(forPath: "image").value as! String
                    let category = list.childSnapshot(forPath: "category").value as! String
                    let creationDate = list.childSnapshot(forPath: "creationDate").value as! String
                    let itemIDs = list.childSnapshot(forPath: "itemIDs").value as! [String]
                    let authorID = list.childSnapshot(forPath: "authorID").value as! String
                    
                    var completedItemCount = 0
                    
                    for itemID in itemIDs {
                        self.REF_ITEMS.observeSingleEvent(of: .value) { (itemSnapshot) in
                            guard let itemSnapshot = itemSnapshot.children.allObjects as? [DataSnapshot] else { return }
                            
                            for item in itemSnapshot {
                                if item.key == itemID {
                                    if (item.childSnapshot(forPath: "users/\(uid)").value as? Bool) != nil {
                                        completedItemCount += 1
                                    }
                                }
                            }
                        }
                    }
                    
                    var isFavorited = Bool()
                    
                    self.REF_USERS.child(uid).child("lists").observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.hasChild(ID){
                            isFavorited = true
                        } else {
                            isFavorited = false
                        }
                    }
                    
                    self.getUsername(forUID: authorID, handler: { (returnedAuthorName) in
                        if isPublic {
                            let list = List(ID: ID, title: title, description: description, isPublic: isPublic, imageDownloadURL: imageDownloadURL, category: category, authorID: authorID, authorName: returnedAuthorName, authorProfilePicture: String(), creationDate: creationDate, itemIDs: itemIDs, items: [Item](), completedItemCount: completedItemCount, isFavorited: isFavorited)
                            
                            listArray.append(list)
                        } else if uid == cid {
                            let list = List(ID: ID, title: title, description: description, isPublic: isPublic, imageDownloadURL: imageDownloadURL, category: category, authorID: authorID, authorName: returnedAuthorName, authorProfilePicture: String(), creationDate: creationDate, itemIDs: itemIDs, items: [Item](), completedItemCount: completedItemCount, isFavorited: isFavorited)
                            
                            listArray.append(list)
                        }
                        group.leave()
                    })
                }
            }
            group.notify(queue: .main) {
                handler(listArray)
            }
        }
    }
    func getAllCreatedLists(forUID uid: String, handler: @escaping (_ lists: [List]) -> ()) {
        var listArray = [List]()
        
        let group = DispatchGroup()
        
        REF_LISTS.observeSingleEvent(of: .value) { (listSnapshot) in
            guard let listSnapshot = listSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for list in listSnapshot {
                
                if list.childSnapshot(forPath: "authorID").value as! String == uid {
                    
                    group.enter()
                    let ID = list.key as String
                    let title = list.childSnapshot(forPath: "title").value as! String
                    let description = list.childSnapshot(forPath: "description").value as! String
                    let isPublic = list.childSnapshot(forPath: "isPublic").value as! Bool
                    let imageDownloadURL = list.childSnapshot(forPath: "image").value as! String
                    let category = list.childSnapshot(forPath: "category").value as! String
                    let creationDate = list.childSnapshot(forPath: "creationDate").value as! String
                    let itemIDs = list.childSnapshot(forPath: "itemIDs").value as! [String]
                    let authorID = list.childSnapshot(forPath: "authorID").value as! String
                    
                    var completedItemCount = 0
                    
                    for itemID in itemIDs {
                        self.REF_ITEMS.observeSingleEvent(of: .value) { (itemSnapshot) in
                            guard let itemSnapshot = itemSnapshot.children.allObjects as? [DataSnapshot] else { return }
                            
                            for item in itemSnapshot {
                                if item.key == itemID {
                                    if (item.childSnapshot(forPath: "users/\(uid)").value as? Bool) != nil {
                                        completedItemCount += 1
                                    }
                                }
                            }
                        }
                    }
                    
                    var isFavorited = Bool()
                    
                    self.REF_USERS.child(uid).child("lists").observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.hasChild(ID){
                            isFavorited = true
                        } else {
                            isFavorited = false
                        }
                    }
                    
                    self.getUsername(forUID: authorID, handler: { (returnedAuthorName) in
                        let list = List(ID: ID, title: title, description: description, isPublic: isPublic, imageDownloadURL: imageDownloadURL, category: category, authorID: authorID, authorName: returnedAuthorName, authorProfilePicture: String(), creationDate: creationDate, itemIDs: itemIDs, items: [Item](), completedItemCount: completedItemCount, isFavorited: isFavorited)
                        
                        listArray.append(list)
                        group.leave()
                    })
                }
            }
            group.notify(queue: .main) {
                handler(listArray)
            }
        }
    }
    func getAllFavoritedLists(forUID uid: String, handler: @escaping (_ lists: [List]) -> ()) {
        var listArray = [List]()
        
        let group = DispatchGroup()
        
        REF_LISTS.observeSingleEvent(of: .value) { (listSnapshot) in
            guard let listSnapshot = listSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for list in listSnapshot {

                self.REF_USERS.child(uid).child("lists").observeSingleEvent(of: .value) { (snapshot) in
                    
                    if snapshot.hasChild(list.key as String){
                        
                        if list.childSnapshot(forPath: "isPublic").value as! Bool || list.childSnapshot(forPath: "authorID").value as! String == uid {
                            
                            group.enter()
                            let ID = list.key as String
                            let title = list.childSnapshot(forPath: "title").value as! String
                            let description = list.childSnapshot(forPath: "description").value as! String
                            let isPublic = list.childSnapshot(forPath: "isPublic").value as! Bool
                            let imageDownloadURL = list.childSnapshot(forPath: "image").value as! String
                            let category = list.childSnapshot(forPath: "category").value as! String
                            let creationDate = list.childSnapshot(forPath: "creationDate").value as! String
                            let itemIDs = list.childSnapshot(forPath: "itemIDs").value as! [String]
                            let authorID = list.childSnapshot(forPath: "authorID").value as! String
                            
                            var completedItemCount = 0
                            
                            for itemID in itemIDs {
                                self.REF_ITEMS.observeSingleEvent(of: .value) { (itemSnapshot) in
                                    guard let itemSnapshot = itemSnapshot.children.allObjects as? [DataSnapshot] else { return }
                                    
                                    for item in itemSnapshot {
                                        if item.key == itemID {
                                            if (item.childSnapshot(forPath: "users/\(uid)").value as? Bool) != nil {
                                                completedItemCount += 1
                                            }
                                        }
                                    }
                                }
                            }
                            
                            self.getUsername(forUID: authorID, handler: { (returnedAuthorName) in
                                let list = List(ID: ID, title: title, description: description, isPublic: isPublic, imageDownloadURL: imageDownloadURL, category: category, authorID: authorID, authorName: returnedAuthorName, authorProfilePicture: String(), creationDate: creationDate, itemIDs: itemIDs, items: [Item](), completedItemCount: completedItemCount, isFavorited: true)
                                
                                listArray.append(list)
                                group.leave()
                            })
                        }
                    }
                    group.notify(queue: .main) {
                        handler(listArray)
                    }
                }
            }
        }
    }
    func completeItem(withItemID itemID: String, forUID uid: String, completion: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("items").updateChildValues([itemID: true])
        REF_ITEMS.child(itemID).child("users").updateChildValues([uid: true])
        
        completion(true)
    }
    func removeItemFromCompleted(withItemID itemID: String, forUID uid: String, removingComplete: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("items").child(itemID).removeValue()
        REF_ITEMS.child(itemID).child("users").child(uid).removeValue()
        
        removingComplete(true)
    }
    func addListToFavorites(withListID listID: String, forUID uid: String, completion: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("lists").updateChildValues([listID: true])
        REF_LISTS.child(listID).child("users").updateChildValues([uid: true])
        
        completion(true)
    }
    func removeListFromFavorites(withListID listID: String, forUID uid: String, completion: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("lists").child(listID).removeValue()
        REF_LISTS.child(listID).child("users").child(uid).removeValue()
        
        completion(true)
    }
    
    func followUser(withUserID userID: String, forUID uid: String, completion: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(userID).child("followers").updateChildValues([uid: true])
        REF_USERS.child(uid).child("follows").updateChildValues([userID: true])
        
        completion(true)
    }
    
    func removeUserFromFollowings(withUserID userID: String, forUID uid: String, completion: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child(userID).child("followers").child(uid).removeValue()
        REF_USERS.child(uid).child("follows").child(userID).removeValue()
        
        completion(true)
    }
    
    // Search Functions
    func getSearchLists(forSearchQuery query: String, forUID uid: String, handler: @escaping (_ searchListArray: [List]) -> ()) {
        var searchListArray = [List]()
        
        let group = DispatchGroup()
        
        REF_LISTS.observeSingleEvent(of: .value) { (listSnapshot) in
            guard let listSnapshot = listSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for list in listSnapshot {
                
                let title = list.childSnapshot(forPath: "title").value as! String
                
                if list.childSnapshot(forPath: "isPublic").value as! Bool && title.lowercased().contains(query.lowercased()) {
                    
                    group.enter()
                    
                    let ID = list.key as String
                    let title = list.childSnapshot(forPath: "title").value as! String
                    let description = list.childSnapshot(forPath: "description").value as! String
                    let isPublic = list.childSnapshot(forPath: "isPublic").value as! Bool
                    let imageDownloadURL = list.childSnapshot(forPath: "image").value as! String
                    let category = list.childSnapshot(forPath: "category").value as! String
                    let creationDate = list.childSnapshot(forPath: "creationDate").value as! String
                    let itemIDs = list.childSnapshot(forPath: "itemIDs").value as! [String]
                    let authorID = list.childSnapshot(forPath: "authorID").value as! String
                    
                    var completedItemCount = 0
                    
                    for itemID in itemIDs {
                        self.REF_ITEMS.observeSingleEvent(of: .value) { (itemSnapshot) in
                            guard let itemSnapshot = itemSnapshot.children.allObjects as? [DataSnapshot] else { return }
                            
                            for item in itemSnapshot {
                                if item.key == itemID {
                                    if (item.childSnapshot(forPath: "users/\(uid)").value as? Bool) != nil {
                                        completedItemCount += 1
                                    }
                                }
                            }
                        }
                    }
                    
                    self.getUsername(forUID: authorID, handler: { (returnedAuthorName) in
                        let list = List(ID: ID, title: title, description: description, isPublic: isPublic, imageDownloadURL: imageDownloadURL, category: category, authorID: authorID, authorName: returnedAuthorName, authorProfilePicture: String(), creationDate: creationDate, itemIDs: itemIDs, items: [Item](), completedItemCount: completedItemCount, isFavorited: true)
                        
                        searchListArray.append(list)
                        group.leave()
                    })
                }
            }
            group.notify(queue: .main) {
                handler(searchListArray)
            }
        }
    }
    func getSearchUsers(forSearchQuery query: String, forUID uid: String, handler: @escaping (_ searchUserArray: [User]) -> ()) {
        var searchUserArray = [User]()
        
        let group = DispatchGroup()
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                
                let cid = user.key
                
                let username = user.childSnapshot(forPath: "username").value as! String
                let fullname = user.childSnapshot(forPath: "name").value as! String
                
                if username.lowercased().contains(query.lowercased()) || fullname.lowercased().contains(query.lowercased()) {
                    
                    group.enter()
                    
                    let email = user.childSnapshot(forPath: "email").value as! String
                    let username = user.childSnapshot(forPath: "username").value as! String
                    let fullname = user.childSnapshot(forPath: "name").value as! String
                    
                    var bioDescription: String
                    
                    if user.childSnapshot(forPath: "bioDescription").exists() {
                        bioDescription = user.childSnapshot(forPath: "bioDescription").value as! String
                    } else {
                        bioDescription = String()
                    }
                    
                    var profilePictureDownloadURL: String
                    
                    if user.childSnapshot(forPath: "profilePicture").exists() {
                        profilePictureDownloadURL = user.childSnapshot(forPath: "profilePicture").value as! String
                    } else {
                        profilePictureDownloadURL = String()
                    }
                    
                    var isFollowed = Bool()
                    
                    self.REF_USERS.child(cid).child("follows").observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.hasChild(uid){
                            isFollowed = true
                        } else {
                            isFollowed = false
                        }
                    }
                    
                    var followerIDs = [String]()
                    
                    var followIDs = [String]()
                    
                    self.REF_USERS.child(uid).child("followers").observeSingleEvent(of: .value) { (followerSnapshot) in
                        guard let followerSnapshot = followerSnapshot.children.allObjects as? [DataSnapshot] else { return }
                        
                        for follower in followerSnapshot {
                            followerIDs.append(follower.key)
                        }
                    }
                    
                    self.REF_USERS.child(uid).child("follows").observeSingleEvent(of: .value) { (followSnapshot) in
                        guard let followSnapshot = followSnapshot.children.allObjects as? [DataSnapshot] else { return }
                        
                        for follow in followSnapshot {
                            followIDs.append(follow.key)
                        }
                    }
                    
                    var lists = [List]()
                    
                    self.getUserProfileLists(forUID: uid, forCID: cid) { (returnedListArray) in
                        lists = returnedListArray.reversed()
                        
                        let user = User(ID: cid, email: email, username: username, fullname: fullname, bioDescription: bioDescription, profilePictureDownloadURL: profilePictureDownloadURL, lists: lists, isFollowed: isFollowed, followerIDs: followerIDs, followIDs: followIDs)
                        
                        searchUserArray.append(user)
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                handler(searchUserArray)
            }
        }
    }
    
    // Update User Function
    func updateUser(forUID uid: String, withFullName fullname: String, withUsername username: String, withBio bioDescription: String, withProfilePicture profilePicture: UIImage, completion: @escaping (_ status: Bool) -> ()) {
        
        let size = CGSize(width: 0, height: 0)
        
        if profilePicture.size.width == size.width {
            self.REF_USERS.child(uid).updateChildValues(["name": fullname, "username": username, "bioDescription": bioDescription])
            completion(true)
        } else {
            let randomProfilePictureName = randomString(length: 9)
            let uploadProfilePictureRef = STORAGE_BASE.child("images/users/\(randomProfilePictureName).jpg")
            let profilePictureData = UIImageJPEGRepresentation(profilePicture, 0.8)
            var downloadProfilePictureURL = String()
            
            uploadProfilePictureRef.putData(profilePictureData!, metadata: nil) { (metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    downloadProfilePictureURL = metaData!.downloadURL()!.absoluteString
                    self.REF_USERS.child(uid).updateChildValues(["name": fullname, "username": username, "bioDescription": bioDescription, "profilePicture": downloadProfilePictureURL])
                }
                completion(true)
            }
        }
    }
}
