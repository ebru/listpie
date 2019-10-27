//
//  Functions.swift
//  Listpie
//
//  Created by Ebru on 25/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

func isEmail(input: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: input)
}
func isValidUsername(username: String) -> Bool {
    let usernameRegex = "^[a-zA-Z0-9_]+$(?:[^\\ş\\Ş\\ı\\İ\\ç\\Ç\\ö\\Ö\\ü\\Ü\\Ğ\\ğ]*)"
    return NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
}
func randomString(length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}
func getCategoryName(categoryType: String) -> String {
    var categoryName = String()
    switch (categoryType) {
    case ("watch"):
        categoryName = "watch"
    case ("listen"):
        categoryName = "listen"
    case ("read"):
        categoryName = "read"
    case ("travel"):
        categoryName = "travel"
    case ("food"):
        categoryName = "food"
    case ("activity"):
        categoryName = "activity"
    default:
        categoryName = "other"
    }
    return categoryName
}
func getCategoryColor(categoryType: String) -> UIColor {
    var categoryColor = UIColor()
    switch (categoryType) {
    case ("watch"):
        categoryColor = WATCH_COLOR
    case ("listen"):
        categoryColor = LISTEN_COLOR
    case ("read"):
        categoryColor = READ_COLOR
    case ("travel"):
        categoryColor = TRAVEL_COLOR
    case ("food"):
        categoryColor = FOOD_COLOR
    case ("activity"):
        categoryColor = ACTIVITY_COLOR
    default:
        categoryColor = .black
    }
    return categoryColor
}
