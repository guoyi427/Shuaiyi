//
//  UIColor+Custom.swift
//  Cinephile
//
//  Created by kokozu on 2017/2/14.
//  Copyright © 2017年 Kokozu. All rights reserved.
//

import UIKit

let Height_Line:CGFloat = 1

extension UIColor {
    
    static let cp_grayBF = {
        return UIColor(hex: "#bfbfbf")!
    }()
    
    static func cp_red() -> UIColor {
        return UIColor(hex: "#ff6000")
    }
    
    static let cp_orange = {
        return UIColor(hex: "#ff8500")!
    }()
    
    static func cp_yellow() -> UIColor {
        return UIColor(hex: "#ffdd00")
    }
    
    static func cp_black() -> UIColor {
        return UIColor(hex: "#333333")
    }
    
    static func cp_gray() -> UIColor {
        return UIColor(hex: "#999999")
    }
    
    static func cp_grayLine() -> UIColor {
        return UIColor(hex: "#eeeeee")
    }
}
