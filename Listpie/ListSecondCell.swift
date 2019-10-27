//
//  ListSecondCell.swift
//  Listpie
//
//  Created by Ebru on 03/11/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class ListSecondCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var authorBtn: UIButton!
    @IBOutlet weak var authorProfilePicture: RoundImageView!
    @IBOutlet weak var listCountLbl: UILabel!
    @IBOutlet weak var addListToFavoritesBtn: UIButton!
    
    func configureCell(authorName: String, authorProfilePicture: String, completedItemCount: Int , listCount: Int) {
        self.authorBtn.setTitle(authorName, for: .normal)
        self.authorProfilePicture.loadImageUsingCacheWithURLString(authorProfilePicture)
        self.listCountLbl.text = "\(completedItemCount)/\(listCount)"
    }
}
