//
//  Tool.swift
//  BWT_iOS
//
//  Created by Jonhory on 2017/3/6.
//  Copyright © 2017年 com.wujh. All rights reserved.
//  小工具

import Foundation
import UIKit

func WLog<T>(_ messsage: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):(\(lineNum))======>>>>>>\n\(messsage)")
    #endif
}

/// 快速输入富文本
///
/// - Parameters:
///   - str: 文本
///   - f: 字号
///   - c: 颜色
/// - Returns: 富文本
func text(string str:String?, font f:CGFloat, color c:UIColor) -> NSAttributedString? {
    if str == nil { return nil }
    let att = [NSFontAttributeName: UIFont.systemFont(ofSize: f), NSForegroundColorAttributeName: c]
    return  NSAttributedString(string: str!, attributes: att)
}

/// 字符串长度
func count(_ string: String?) -> Int {
    if string == nil { return 0 }
    return string!.characters.count
}

/// 字符串高度
func height(ofText : String, font: CGFloat, maxWidth: CGFloat) -> CGFloat {
    let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: font)]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let size = CGSize(width: maxWidth, height: 0)
    let rect:CGRect = ofText.boundingRect(with: size, options: option, attributes: attributes, context: nil)
    return rect.size.height
}

/// 限制文本输入长度的方法，因为用了NS，所以单独抽出来方便以后修改
func wtextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, maxLength max: Int) -> Bool {
    let currentString: NSString = textField.text! as NSString
    let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    return newString.length <= max
}

func iPhone5() -> Bool {
    return SCREEN_W < 375
}

func iPhonePlus() -> Bool {
    return SCREEN_W > 375
}

/// 比例适配高度 6s为基准
///
/// - Parameter height:
/// - Returns: 适配后的高度
func autoHeight(_ height:CGFloat) -> CGFloat {
    return height / 375.0 * SCREEN_W;
}


func rgb(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    return rgba(r, g, b, 1.0)
}

func rgba(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

//MARK: 当前版本是否是第一次启动
func currentVersionIsFirstOpen() -> Bool {
    return !UserDefaults.standard.bool(forKey: "currentVersionIsFirstOpen" + CurrentVersion)
}

func saveCurrentVersion() {
    UserDefaults.standard.set(true, forKey: "currentVersionIsFirstOpen" + CurrentVersion)
}

