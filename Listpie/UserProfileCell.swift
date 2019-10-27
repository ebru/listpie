//
//  UserProfileCell.swift
//  Listpie
//
//  Created by Ebru Kaya on 5.03.2018.
//  Copyright © 2018 Ebru Kaya. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var profilePictureImageView: RoundImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var bioDescriptionLbl: UILabel!
    @IBOutlet weak var listCountBtn: UIButton!
    @IBOutlet weak var followerCountBtn: UIButton!
    @IBOutlet weak var followsCountBtn: UIButton!
    @IBOutlet weak var followOrEditBtn: RoundedButton!
    
    func configureCell(user: User, isCurrentUser: Bool) {

        self.usernameLbl.text = user.fullname
        
        if user.fullname.isEmpty {
            self.usernameLbl.text = user.username
        } else {
            self.usernameLbl.text = user.fullname
        }
        
        if user.bioDescription.isEmpty {
            self.bioDescriptionLbl.isHidden = true
        } else {
            self.bioDescriptionLbl.isHidden = false
            self.bioDescriptionLbl.text = user.bioDescription
        }
        
        var userProfilePicture: String
        
        if user.profilePictureDownloadURL.isEmpty {
            userProfilePicture = NO_PROFILE_PICTURE_URL
        } else {
            userProfilePicture = user.profilePictureDownloadURL
        }
        
        self.profilePictureImageView.loadImageUsingCacheWithURLString(userProfilePicture)
        
        var userListCount: Int
        
        if !user.lists.isEmpty {
            userListCount = user.lists.count
        } else {
            userListCount = 0
        }
        
        var followerListCount: Int
        
        if !user.followerIDs.isEmpty {
            followerListCount = user.followerIDs.count
        } else {
            followerListCount = 0
        }
        
        var followListCount: Int
        
        if !user.followIDs.isEmpty {
            followListCount = user.followIDs.count
        } else {
            followListCount = 0
        }
        
        self.listCountBtn.setTitle(String(userListCount), for: .normal)
        self.followerCountBtn.setTitle(String(followerListCount), for: .normal)
        self.followsCountBtn.setTitle(String(followListCount), for: .normal)
       
        if isCurrentUser {
            self.followOrEditBtn.setTitle("Edit Profile", for: .normal)
            self.followOrEditBtn.setTitleColor(DARK_GRAY_BTN_TEXT_COLOR, for: .normal)
            self.followOrEditBtn.backgroundColor = LIGHT_GRAY_BTN_BACKGROUND_COLOR
            self.followOrEditBtn.layer.borderWidth = 0
        } else {
            if user.isFollowed {
                self.followOrEditBtn.setTitle("Following", for: .normal)
                self.followOrEditBtn.setTitleColor(DARK_GRAY_BTN_TEXT_COLOR, for: .normal)
                self.followOrEditBtn.backgroundColor = LIGHT_GRAY_BTN_BACKGROUND_COLOR
                self.followOrEditBtn.layer.borderWidth = 0
            } else {
                self.followOrEditBtn.setTitle("Follow", for: .normal)
                self.followOrEditBtn.backgroundColor = .clear
                self.followOrEditBtn.setTitleColor(FOLLOW_BTN_COLOR, for: .normal)
                self.followOrEditBtn.layer.borderWidth = 1
                self.followOrEditBtn.layer.borderColor = FOLLOW_BTN_COLOR.cgColor
            }
        }
    }
}
