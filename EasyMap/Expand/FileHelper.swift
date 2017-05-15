//
//  FileHelper.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/15.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class FileHelper: NSObject {
    
    class func baseDir() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        path = path!.appending("/pathRecoreds")
        return path!
    }
    
    class func filePath(withName: String) -> String {
        let path = baseDir()
        var pathSuccess = FileManager.default.fileExists(atPath: path)
        if !pathSuccess {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                pathSuccess = true
            } catch  {
                print("创建文件夹失败：",error)
                pathSuccess = false
            }
        }
        let documentPath = path.appending("/\(withName)")
        return documentPath
    }
    
    class func deleteRecordFile() -> Bool {
        let path = baseDir()
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            print("删除文件失败",error)
            return false
        }
    }
    
    class func getRoutes() -> [AMapRouteRecord] {
        let list: [String]? = recordFileList()
        if list != nil {
            var routeList: [AMapRouteRecord] = []
            for file in list! {
                let path = filePath(withName: file)
                print("filePath:", path)
                if let route = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? AMapRouteRecord {
                    print("成功归档", route)
                    routeList.append(route)
                }
            }
            return routeList
        }
        return []
    }
    
    class func recordFileList() -> [String]? {
        let doc = baseDir()
        
        var resulte: [String]?
        do {
            resulte = try FileManager.default.contentsOfDirectory(atPath: doc)
            return resulte
        } catch  {
            print("读取错误：", error)
            resulte = nil
        }
        return  nil
    }
}
