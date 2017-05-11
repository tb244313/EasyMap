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

        config(leftStr: nil, leftHelpStr: nil, titleStr: "主页", rightHelpStr: nil, rightStr: nil)
        
        initMapView()
    }
    
    func initMapView() {
        let f = CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H - 64)
        mapView = MAMapView(frame: f)
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeVC: MAMapViewDelegate {
    
}

