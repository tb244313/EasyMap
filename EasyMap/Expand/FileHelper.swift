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
    
    class func downloadMap(cityCode: String,_ vc: UIViewController) {
        
        let queue = DispatchQueue(label: "downloadMapQueue")
        queue.async {
            
            let map = MAOfflineMap.shared()
            
            let provinces = map!.provinces as! [MAOfflineProvince]
            if provinces.isEmpty { return }
            
            var allCitys: [MAOfflineCity] = []
            for province in provinces {
                let citys: [MAOfflineCity] = province.cities as! [MAOfflineCity]
                citys.forEach({ (city) in
                    allCitys.append(city)
                })
            }
            
            let municipalities = map!.municipalities as! [MAOfflineCity]
            municipalities.forEach({ (city) in
                allCitys.append(city)
            })
            
            var item: MAOfflineCity?
            for city in allCitys {
                if city.cityCode == cityCode {
                    if city.itemStatus != .installed {
                        item = city
                    }
                    print("匹配到城市：",city, "字节:", city.size, "M:", city.size / 1024 / 1024)
                    
                    break
                }
            }
            
            if item == nil { return }
            
            var msg = "是否下载\(item!.name)离线地图资源"
            if EMNetwork.shared.networkStatus == .reachable(.ethernetOrWiFi) {
                msg = "检测到您当前处于WiFi环境,是否下载\(item!.name!)离线地图资源"
            } else if EMNetwork.shared.networkStatus == .reachable(.wwan) {
                let m: Double = Double(item!.size) / 1024.0 / 1024.0
                msg = "检测到您当前处于移动网络环境,是否下载\(item!.name!)离线地图资源,该操作将消耗您大约"
                let mStr = String.init(format: "%.2fM流量", m)
                msg += mStr
            }
        
            let alert = UIAlertController(title: "注意", message: msg, preferredStyle: .alert)
            let sure = UIAlertAction(title: "好的", style: .default, handler: { (ac) in
                print("开始下载:",item!.name)
                MAOfflineMap.shared().downloadItem(item, shouldContinueWhenAppEntersBackground: true) { _ in }
            })
            let cancel = UIAlertAction(title: "不必了", style: .cancel)
            alert.addAction(cancel)
            alert.addAction(sure)
            vc.present(alert, animated: true)
        }
    }
}
