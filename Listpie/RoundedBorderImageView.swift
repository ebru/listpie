//
//  RoundedBorderImageView.swift
//  Listpie
//
//  Created by Ebru Kaya on 17.08.2018.
//  Copyright © 2018 Ebru Kaya. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedBorderImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
