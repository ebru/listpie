//
//  UserProfileListsCell.swift
//  Listpie
//
//  Created by Ebru Kaya on 18.08.2018.
//  Copyright © 2018 Ebru Kaya. All rights reserved.
//

import UIKit

class UserProfileListsCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var listTitleLbl: UILabel!
    @IBOutlet weak var listAuthorLbl: UILabel!
    @IBOutlet weak var privateIcon: UIImageView!
    
    func configureCell(list: List) {
        self.listImageView.loadImageUsingCacheWithURLString(list.imageDownloadURL)
        self.listTitleLbl.text = list.title
        self.listAuthorLbl.text = list.authorName
        
        if list.isPublic {
            self.privateIcon.isHidden = true
        } else {
            self.privateIcon.isHidden = false
        }
    }
    
}
