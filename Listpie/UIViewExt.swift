//
//  UIViewExt.swift
//  Listpie
//
//  Created by Ebru on 06/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

extension UIView {
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let startingFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endingFrame.origin.y - startingFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
    func addActivityIndicatorToView(activityIndicator: UIActivityIndicatorView, shiftX: CGFloat, shiftY: CGFloat, style: UIActivityIndicatorViewStyle){
        activityIndicator.activityIndicatorViewStyle = style
        activityIndicator.center = CGPoint(x: self.bounds.size.width/2 + shiftX, y: self.bounds.size.height/2 + shiftY)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
