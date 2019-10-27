//
//  ListSearchCell.swift
//  Listpie
//
//  Created by Ebru Kaya on 27.06.2018.
//  Copyright © 2018 Ebru Kaya. All rights reserved.
//

import UIKit

class ListSearchCell: UITableViewCell {
    
    @IBOutlet weak var searchListImageView: UIImageView!
    @IBOutlet weak var searchListTitleLbl: UILabel!
    @IBOutlet weak var searchListAuthorLbl: UILabel!
    
    func configureCell(searchList: List) {
        self.searchListImageView.loadImageUsingCacheWithURLString(searchList.imageDownloadURL)
        self.searchListTitleLbl.text = searchList.title
        self.searchListAuthorLbl.text = searchList.authorName
    }

}
