//
//  Common.swift
//  CIASMovie
//
//  Created by avatar on 2017/5/8.
//  Copyright © 2017年 cias. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width  //整个APP屏幕的宽度
let kScreenHeight = UIScreen.main.bounds.size.height //整个APP屏幕的高度

//以6的比例设置
let kRatioToIP6W = kScreenWidth/375.0
let kRatioToIP6H = kScreenHeight/667.0



//MARK: -颜色方法
func UIColor_RGBA (_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)-> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

//MARK: 不透明颜色
func UIColor_RGBColor (_ r:CGFloat,g:CGFloat,b:CGFloat)-> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}


//MARK: IOS 8以上
func IS_IOS8() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0 }


// MARK:- 自定义打印方法
func LGJLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):(\(lineNum))-\(message)")
        
    #endif
}


extension UIColor {
    
    static func cs_f60red() -> UIColor {
        return UIColor(hex: "#ff6000")
    }
    
    static func cs_fc0yellow() -> UIColor {
        return UIColor(hex: "#ffcc00")
    }
    
    static func cs_33black() -> UIColor {
        return UIColor(hex: "#333333")
    }
    
    static func cs_b2Line() -> UIColor {
        return UIColor(hex: "#b2b2b2")
    }
    
    static func cs_e0Line() -> UIColor {
        return UIColor(hex: "#e0e0e0")
    }
    
    static func colorWithHexString(hex:String) ->UIColor {
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.red
        }
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}


public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    static func getImageRedrawed(image: UIImage, scale:CGFloat) -> UIImage {
        let imageSize:CGSize = image.size
        let imageWidth: CGFloat = imageSize.width
        let imageHeight: CGFloat = imageSize.height
        
        let scaleWidth = imageWidth * scale
        let scaleHeight = imageHeight * scale
        
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let scaleImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return scaleImage
    }
    
}

class CSSearchBar: UISearchBar {
    var contentInset: UIEdgeInsets? {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // view是searchBar中的唯一的直接子控件
        for view in self.subviews {
            // UISearchBarBackground与UISearchBarTextField是searchBar的简介子控件
            for subview in view.subviews {
                
                // 找到UISearchBarTextField
//                subview.isKindOfClass(UITextField.classForCoder())
                if subview .isKind(of: UITextField.classForCoder()) {
                    
                    subview.backgroundColor = UIColor.colorWithHexString(hex: "f2f4f5")
                    
                    if let textFieldContentInset = contentInset { // 若contentInset被赋值
                        // 根据contentInset改变UISearchBarTextField的布局
                        subview.frame = CGRect(x: textFieldContentInset.left, y: textFieldContentInset.top, width: self.bounds.width - textFieldContentInset.left - textFieldContentInset.right, height: self.bounds.height - textFieldContentInset.top - textFieldContentInset.bottom)
                    } else { // 若contentSet未被赋值
                        // 设置UISearchBar中UISearchBarTextField的默认边距
                        let top: CGFloat = (self.bounds.height - 28.0) / 2.0//高默认是28
                        let bottom: CGFloat = top
                        let left: CGFloat = 0.0//默认为8
                        let right: CGFloat = left
                        contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
                    }
                    
                }
            }
        }
    }
    
}

