//
//  Extension.swift
//  BWT_iOS
//
//  Created by Jonhory on 2017/3/2.
//  Copyright © 2017年 com.wujh. All rights reserved.
//  扩展

import Foundation
import UIKit

extension String {
    // url encode
    var urlEncode:String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    // url decode
    var urlDecode :String? {
        return self.removingPercentEncoding
    }
    
    func sizeWidth(btn: UIButton) -> Double {
        return Double(self.size(attributes: [NSFontAttributeName:
            UIFont(name: (btn.titleLabel?.font.fontName)!, size: (btn.titleLabel?.font.pointSize)!)!]).width)
    }
    
    /**
     生成随机字符串,
     
     - parameter length: 生成的字符串的长度
     
     - returns: 随机生成的字符串
     */
    static func randomStr(length: Int) -> String {
        var ranStr = ""
        let randomStr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(randomStr.characters.count)))
            ranStr.append(randomStr[randomStr.index(randomStr.startIndex, offsetBy: index)])
        }
        return ranStr
    }

}

extension UIColor {
    //返回随机颜色
    open class var randomColor:UIColor{
        get{
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

//MARK: - UIDevice延展
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}


extension Optional {
    var orNil : String {
        if self == nil {
            return ""
        }
        if "\(Wrapped.self)" == "String" {
            return "\(self!)"
        }
        return "\(self!)"
    }
}


extension UILabel {
    func setLineSpace(_ space: CGFloat, withText: String, withFontSize: CGFloat, textSpace: Double, indentationNum: Int) {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = space
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = withFontSize * CGFloat(indentationNum)
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0.0
        paraStyle.tailIndent = 0.0
        
        var dic: [String: Any]?
        if textSpace == 0.0 {
            dic = [NSFontAttributeName: UIFont.systemFont(ofSize: withFontSize), NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: NSNumber(value: 1.5)]
        } else {
            dic = [NSFontAttributeName: UIFont.systemFont(ofSize: withFontSize), NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: NSNumber(value: textSpace)]
        }
        let attributeStr = NSAttributedString(string: withText, attributes: dic!)
        self.attributedText = attributeStr
    }
}
