//
//  EMNetwork.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/16.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator

/// 网络状态监听回调
typealias networkListen = (_ status:NetworkReachabilityManager.NetworkReachabilityStatus) -> Void

class EMNetwork {
    static let shared = EMNetwork()
    private init() {}
    
    /// 当前网络状态，默认WIFI，开启网络状态监听后有效
    var networkStatus = NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi)
    let listen = NetworkReachabilityManager()
    
    /// 监听网络状态
    ///
    /// - Parameter networkListen: 网络状态回调
    func listenNetworkReachabilityStatus(networkListen:@escaping networkListen) {
        listen?.startListening()
        listen?.listener = { status in
            self.networkStatus = status
            
            WLog("*** <<<Network Status Changed>>> ***:\(status)")
            
            networkListen(status)
        }
        if listen?.isReachable == false {
            networkStatus = .notReachable
            networkListen(networkStatus)
        }
    }
}
