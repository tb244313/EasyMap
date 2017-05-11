//
//  HomeVC.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/11.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {

    var mapView: MAMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config(leftStr: nil, leftHelpStr: nil, titleStr: "地图", rightHelpStr: nil, rightStr: nil)
        
        initMapView()
    }
    
    func initMapView() {
        let f = CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H - 49)
        mapView = MAMapView(frame: f)
        mapView.delegate = self
        mapView.zoomLevel = 15
        view.addSubview(mapView)
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 自定义定位小蓝点
        let r = MAUserLocationRepresentation()
        r.showsHeadingIndicator = false
        r.lineWidth = 0.5
        mapView.update(r)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeVC: MAMapViewDelegate {
    
}

