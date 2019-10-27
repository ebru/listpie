//
//  List.swift
//  Listpie
//
//  Created by Ebru on 14/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import Foundation
import UIKit

class List {
    private var _ID: String
    private var _title: String
    private var _description: String
    private var _isPublic: Bool
    private var _imageDownloadURL: String
    private var _category: String
    private var _authorID: String
    private var _authorName: String
    private var _authorProfilePicture: String
    private var _creationDate: String
    private var _itemIDs: [String]
    private var _items: [Item]
    private var _completedItemCount: Int
    private var _isFavorited: Bool
    
    var ID: String {
        return _ID
    }
    var title: String {
        return _title
    }
    var description: String {
        return _description
    }
    var isPublic: Bool {
        return _isPublic
    }
    var imageDownloadURL: String {
        return _imageDownloadURL
    }
    var category: String {
        return _category
    }
    var authorID: String {
        return _authorID
    }
    var authorName: String {
        return _authorName
    }
    var authorProfilePicture: String {
        return _authorProfilePicture
    }
    var creationDate: String {
        return _creationDate
    }
    var itemIDs: [String] {
        return _itemIDs
    }
    var items: [Item] {
        return _items
    }
    var completedItemCount: Int {
        return _completedItemCount
    }
    var isFavorited: Bool {
        return _isFavorited
    }
    
    init(ID: String, title: String, description: String, isPublic: Bool, imageDownloadURL: String, category: String,  authorID: String, authorName: String, authorProfilePicture: String, creationDate: String, itemIDs: [String], items: [Item], completedItemCount: Int, isFavorited: Bool) {
        self._ID = ID
        self._title = title
        self._description = description
        self._isPublic = isPublic
        self._imageDownloadURL = imageDownloadURL
        self._category = category
        self._authorID = authorID
        self._authorName = authorName
        self._authorProfilePicture = authorProfilePicture
        self._creationDate = creationDate
        self._itemIDs = itemIDs
        self._items = items
        self._completedItemCount = completedItemCount
        self._isFavorited = isFavorited
    }
    
    convenience init() {
        self.init(ID: String(), title: String(), description: String(), isPublic: Bool(), imageDownloadURL: String(), category: String(),  authorID: String(), authorName: String(), authorProfilePicture: String(), creationDate: String(), itemIDs: [String](), items: [Item](), completedItemCount: Int(), isFavorited: Bool())
    }
}
