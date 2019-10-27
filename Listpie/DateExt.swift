//
//  DateExt.swift
//  Listpie
//
//  Created by Ebru on 27/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import Foundation

extension Date {
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        
        return formatter.string(from: yourDate!)
    }
}
