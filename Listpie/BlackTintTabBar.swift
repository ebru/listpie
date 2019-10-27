//
//  BlackTintTabBar.swift
//  Listpie
//
//  Created by Ebru on 14/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

@IBDesignable
class BlackTintTabBar: UITabBar {

    @IBInspectable var color: UIColor = UIColor.black {
        didSet {
            self.tintColor = color
        }
    }
    override func awakeFromNib() {
        self.tintColor = color
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
