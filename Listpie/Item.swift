//
//  Item.swift
//  Listpie
//
//  Created by Ebru on 03/11/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import Foundation
import UIKit

class Item {
    private var _ID: String
    private var _name: String
    private var _description: String
    private var _imageDownloadURL: String
    private var _isCompleted: Bool
    
    var ID: String {
        return _ID
    }
    var name: String {
        return _name
    }
    var description: String {
        return _description
    }
    var imageDownloadURL: String {
        return _imageDownloadURL
    }
    var isCompleted: Bool {
        return _isCompleted
    }
    
    init(ID: String, name: String, description: String, imageDownloadURL: String, isCompleted: Bool) {
        self._ID = ID
        self._name = name
        self._description = description
        self._imageDownloadURL = imageDownloadURL
        self._isCompleted = isCompleted
    }
}

