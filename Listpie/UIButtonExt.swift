//
//  UIButtonExt.swift
//  Listpie
//
//  Created by Ebru on 06/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
    }
    func setDeselectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.8381014466, green: 0.8502607942, blue: 0.8503600955, alpha: 1)
    }
    func setSelectedFavoritesBtnStyle() {
        self.backgroundColor = #colorLiteral(red: 0.2559277117, green: 0.4879948497, blue: 0.1066756323, alpha: 1)
    }
    func setSelectedCreatedBtnStyle() {
        self.backgroundColor = #colorLiteral(red: 0.8135116696, green: 0.4808699489, blue: 0.1301125884, alpha: 1)
    }
    func setWatchSelectedColor() {
        self.backgroundColor = WATCH_COLOR
    }
    func setListenSelectedColor() {
        self.backgroundColor = LISTEN_COLOR
    }
    func setReadSelectedColor() {
        self.backgroundColor = READ_COLOR
    }
    func setTravelSelectedColor() {
        self.backgroundColor = TRAVEL_COLOR
    }
    func setFoodSelectedColor() {
        self.backgroundColor = FOOD_COLOR
    }
    func setActivitySelectedColor() {
        self.backgroundColor = ACTIVITY_COLOR
    }
}

