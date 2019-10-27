//
//  UserSearchCell.swift
//  Listpie
//
//  Created by Ebru Kaya on 5.09.2018.
//  Copyright © 2018 Ebru Kaya. All rights reserved.
//

import UIKit

class UserSearchCell: UITableViewCell {
    
    @IBOutlet weak var searchUserImageView: RoundImageView!
    @IBOutlet weak var searchUserNameLbl: UILabel!
    @IBOutlet weak var searchUserFullNameLbl: UILabel!
    
    func configureCell(searchUser: User) {
        
        var userProfilePicture: String
        
        if searchUser.profilePictureDownloadURL.isEmpty {
            userProfilePicture = NO_PROFILE_PICTURE_URL
        } else {
            userProfilePicture = searchUser.profilePictureDownloadURL
        }
        self.searchUserImageView.loadImageUsingCacheWithURLString(userProfilePicture)
        
        self.searchUserNameLbl.text = searchUser.username
        self.searchUserFullNameLbl.text = searchUser.fullname
    }
}
