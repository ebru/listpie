//
//  GradientView.swift
//  Listpie
//
//  Created by Ebru on 27/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override func awakeFromNib() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.opacity = 1
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
