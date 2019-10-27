//
//  ListCell.swift
//  Listpie
//
//  Created by Ebru on 06/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var listAuthor: UILabel!
    @IBOutlet weak var listCount: UILabel!
    @IBOutlet weak var listCategoryBtn: UIButton!
    @IBOutlet weak var privateIcon: UIImageView!
    
    func configureCell(list: List) {
        self.listAuthor.text = list.authorName
        self.listImage.loadImageUsingCacheWithURLString(list.imageDownloadURL)
        self.listTitle.text = list.title
        self.listCount.text = "\(list.completedItemCount)/\(list.itemIDs.count)"
        self.listCategoryBtn.backgroundColor = getCategoryColor(categoryType: list.category)
        self.listCategoryBtn.setTitle(getCategoryName(categoryType: list.category), for: .normal)
        
        if list.isPublic {
            self.privateIcon.isHidden = true
        } else {
            self.privateIcon.isHidden = false
        }
    }
}
