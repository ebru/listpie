//
//  ListHeaderCell.swift
//  Listpie
//
//  Created by Ebru on 02/11/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class ListHeaderCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var listCategoryBtn: UIButton!
    @IBOutlet weak var listTitleLbl: UILabel!
    @IBOutlet weak var listDescriptionLbl: UILabel!
    @IBOutlet weak var privateIcon: UIImageView!
    
    func configureCell(listTitle: String, listDescription: String, listImageDownloadURL: String, listCategory: String, isPublic: Bool) {
        self.listCategoryBtn.backgroundColor = getCategoryColor(categoryType: listCategory)
        self.listCategoryBtn.setTitle(getCategoryName(categoryType: listCategory), for: .normal)
        self.listTitleLbl.text = listTitle
        self.listImageView.loadImageUsingCacheWithURLString(listImageDownloadURL)
        
        if listDescription.isEmpty {
            self.listDescriptionLbl.isHidden = true
        } else {
            self.listDescriptionLbl.isHidden = false
            self.listDescriptionLbl.text = listDescription
        }
        
        if isPublic {
            self.privateIcon.isHidden = true
        } else {
            self.privateIcon.isHidden = false
        }
    }
}
