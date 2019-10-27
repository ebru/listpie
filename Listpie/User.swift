//
//  User.swift
//
//  Created by Ebru Kaya on 4.03.2018.
//  Copyright © 2018 Ebru Kaya. All rights reserved.
//

import Foundation
import UIKit

class User {
    private var _ID: String
    private var _email: String
    private var _username: String
    private var _fullname: String
    private var _bioDescription: String
    private var _profilePictureDownloadURL: String
    private var _lists: [List]
    private var _isFollowed: Bool
    private var _followerIDs: [String]
    private var _followIDs: [String]
    
    var ID: String {
        return _ID
    }
    var email: String {
        return _email
    }
    var username: String {
        return _username
    }
    var fullname: String {
        return _fullname
    }
    var bioDescription: String {
        return _bioDescription
    }
    var profilePictureDownloadURL: String {
        return _profilePictureDownloadURL
    }
    var lists: [List] {
        return _lists
    }
    var isFollowed: Bool {
        return _isFollowed
    }
    var followerIDs: [String] {
        return _followerIDs
    }
    var followIDs: [String] {
        return _followIDs
    }
    
    init(ID: String, email: String, username: String, fullname: String, bioDescription: String, profilePictureDownloadURL: String, lists: [List], isFollowed: Bool, followerIDs: [String], followIDs: [String]) {
        self._ID = ID
        self._username = username
        self._email = email
        self._fullname = fullname
        self._bioDescription = bioDescription
        self._lists = lists
        self._profilePictureDownloadURL = profilePictureDownloadURL
        self._isFollowed = isFollowed
        self._followerIDs = followerIDs
        self._followIDs = followIDs
    }
    
    convenience init() {
        self.init(ID: String(), email: String(), username: String(), fullname: String(), bioDescription: String(), profilePictureDownloadURL: String(), lists: [List](), isFollowed: Bool(), followerIDs: [String](), followIDs: [String]())
    }
}
