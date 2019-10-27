//
//  AddItemCell.swift
//  Listpie
//
//  Created by Ebru on 28/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class AddItemCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var itemNoLbl: UILabel!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    @IBOutlet weak var addImageBtn: UIButton!
    
    func configureCell(itemNo: Int, itemName: String, itemImage: UIImage, itemDescription: String) {
        self.itemNoLbl.text = "\(itemNo)."
        
        self.itemNameTextField.text = itemName
        
        if itemImage.size.equalTo(CGSize(width: 0, height: 0)) {
            self.itemImageView.image = UIImage(named: "imageUpload")
        } else {
            self.itemImageView.image = itemImage
        }
        
        self.itemDescriptionTextView.text = itemDescription
    }
}

