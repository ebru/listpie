//
//  ListItemsCell.swift
//  Listpie
//
//  Created by Ebru on 03/11/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class ListItemsCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDescriptionLbl: UILabel!
    @IBOutlet weak var itemCompleteView: UIView!
    @IBOutlet weak var itemCheckImageView: UIImageView!
    
    func configureCell(itemNo: Int, item: Item) {
        self.itemNameLbl.text = "\(itemNo). \(item.name)"
        
        if item.description.isEmpty {
            self.itemDescriptionLbl.isHidden = true
        } else {
            self.itemDescriptionLbl.isHidden = false
            self.itemDescriptionLbl.text = item.description
        }
        
        if item.imageDownloadURL.isEmpty {
            self.itemImageView.isHidden = true
        } else {
            self.itemImageView.isHidden = false
            self.itemImageView.loadImageUsingCacheWithURLString(item.imageDownloadURL)
        }

        if item.isCompleted {
            self.itemCompleteView.isHidden = false
            self.itemCheckImageView.image = UIImage(named: "check-circle-true")
        } else {
            self.itemCompleteView.isHidden = true
            self.itemCheckImageView.image = UIImage(named: "check-circle")
        }
    }
}
