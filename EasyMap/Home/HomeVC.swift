//
//  HomeVC.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/11.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {

    // 地图对象
    var mapView: MAMapView!
    let locationManager = AMapLocationManager()
    
    // 位置信息label
    let locationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config(leftStr: nil, leftHelpStr: nil, titleStr: "地图", rightHelpStr: nil, rightStr: nil)
        
        initMapView()
        loadUI()
    }
    
    func initMapView() {
        let f = CGRect(x: 0, y: 30, width: SCREEN_W, height: SCREEN_H - 49 - 30)
        mapView = MAMapView(frame: f)
        mapView.delegate = self
        mapView.zoomLevel = 15
        mapView.showsScale = false
        view.addSubview(mapView)
        
        // 开启定位
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 自定义定位小蓝点
        let r = MAUserLocationRepresentation()
        r.showsHeadingIndicator = false
        r.lineWidth = 0.5
        mapView.update(r)
        
        // 定位相关
        locationManager.delegate = self
        locationManager.distanceFilter = 200
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
    }
    
    func loadUI() {
        locationLabel.textColor = Red
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textAlignment = .center
        locationLabel.frame = CGRect(x: 0, y: 0, width: SCREEN_W, height: 30)
        locationLabel.backgroundColor = BackGray
        
        view.addSubview(locationLabel)
        
        locationLabel.text = "正在定位中..."
        locationLabel.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: - MAMapViewDelegate
extension HomeVC: MAMapViewDelegate {
    
}


// MARK: - AMapLocationManagerDelegate
extension HomeVC: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy);};");
        
        if let reGeocode = reGeocode {
            NSLog("reGeocode:%@", reGeocode)
            locationLabel.text = reGeocode.formattedAddress
        }
    }
}
