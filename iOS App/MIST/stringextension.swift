//
//  stringextension.swift
//  MIST
//
//  Created by Muhammad Doukmak on 2/25/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func image() -> UIImage? {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        print("String is \(self)")
        (self as NSString).draw(in: rect, withAttributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        if image == nil {
            print("Image not nil")
        } else {
            print("Image nil")
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
