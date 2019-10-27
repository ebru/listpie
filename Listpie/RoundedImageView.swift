//
//  RoundedImageView.swift
//  Listpie
//
//  Created by Ebru on 03/11/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    override func awakeFromNib() {
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
