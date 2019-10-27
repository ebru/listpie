//
//  UIImageViewExt.swift
//  Listpie
//
//  Created by Ebru on 27/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import SDWebImage

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithURLString(_ urlString: String) {
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        //otherwise fire off a new download
        self.sd_setShowActivityIndicatorView(true)
        self.sd_setIndicatorStyle(.gray)
        self.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "placeholder"))
    }
    func convertImageToGrayScale() {
        let image = self.image
        let imageRect = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        let colorSpace = CGColorSpaceCreateDeviceGray();
        
        let width = UInt((image?.size.width)!)
        let height = UInt((image?.size.height)!)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0);
        context?.draw((image?.cgImage!)!, in: imageRect)
        
        let cgImage: CGImage = context!.makeImage()!
        self.image = UIImage(cgImage: cgImage)
    }
}
