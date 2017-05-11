//
//  Macros.swift
//  BWT_iOS
//
//  Created by Jonhory on 2017/3/2.
//  Copyright © 2017年 com.wujh. All rights reserved.
//  宏

import Foundation
import UIKit

let AMAP_KEY = "e8de6312a5da9f075f8701872e98c817"

let SCREEN = UIScreen.main.bounds.size
let SCREEN_W = SCREEN.width
let SCREEN_H = SCREEN.height

let BackImage = UIImage(named: "c_fanhuihei")
let CurrentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let SandboxVersion = UserDefaults.standard.object(forKey: "CFBundleShortVersionString") as? String ?? ""

