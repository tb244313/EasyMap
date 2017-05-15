//
//  HomeVC.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/11.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {
    
    // --- Object ---
    // 地图对象
    var mapView: MAMapView!
    // 定位管理
    let locationManager = AMapLocationManager()
    let traceManager = MATraceManager()
    // 记录轨迹管理
    var currentRecord: AMapRouteRecord?
    var polyline: MAPolyline?
    
    var tracedPolylines: [MAPolyline] = []
    var tempTraceLocations: [CLLocation] = []
    var locationsArray: [CLLocation] = []
    
    var totalTraceLength: Double = 0.0
    
    var isRecording = false
    var isSaving = false
    
    // ---  UI ---
    // 位置信息label
    let locationLabel = UILabel()
    let locationBtn = UIButton(type: .custom)
    let imageLocated = UIImage(named: "location_yes")
    let imageNotLocate = UIImage(named: "location_no")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config(leftStr: nil, leftHelpStr: nil, titleStr: "地图", rightHelpStr: nil, rightStr: nil)
        
        loadUI()
        configNav()
    }
    
    // MARK: 普通事件
    func actionRecordAndStop() {
        if isSaving {
            update(title: "保存结果中...")
            return
        }
        
        isRecording = !isRecording
        
        if isRecording {
            update(title: "正在记录")
            navigationItem.leftBarButtonItem?.image = UIImage(named: "icon_stop")
            
            if currentRecord == nil {
                currentRecord = AMapRouteRecord()
            }
            
            mapView.removeOverlays(tracedPolylines)
            setBackgroundMode(enable: true)
        } else {
            update(title: "记录结束,保存中")
            navigationItem.leftBarButtonItem?.image = UIImage(named: "icon_play")
            setBackgroundMode(enable: false)
            actionSave()
        }
    }
    
    func actionLoaction() {
        if mapView.userTrackingMode == .follow {
            mapView.userTrackingMode = .none
        } else {
            mapView.userTrackingMode = .follow
        }
    }
    
    func actionList() {
        let vc = RecordVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: 处理方法
    func actionSave() {
        if currentRecord == nil || currentRecord!.locationsArray.count < 2{
            update(title: "当前记录的轨迹点过少,保存失败")
            navigationItem.leftBarButtonItem?.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.68, execute: {
                self.update(title: "地图")
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            })
            return
        }
        
        isRecording = false
        isSaving = true
        locationsArray.removeAll()
        
        mapView.remove(polyline)
        polyline = nil
        
        // 全程请求trace
        mapView.removeOverlays(tracedPolylines)
        let name = currentRecord!.title()
        let path = FileHelper.filePath(withName: name)
        NSKeyedArchiver.archiveRootObject(currentRecord!, toFile: path)
        
        currentRecord = nil
        
        update(title: "地图")
        
        print("保存成功:",path)
    }
    
    func setBackgroundMode(enable: Bool) {
        mapView.pausesLocationUpdatesAutomatically = !enable
        mapView.allowsBackgroundLocationUpdates = enable
    }
    
    func addLocation(_ location: CLLocation?) {
        if currentRecord!.addLocation(location) {
            print("当前记录了\(currentRecord!.locationsArray.count)个点")
        }
    }
    
    // MARK: UI部分
    func configNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_play"), style: .plain, target: self, action: #selector(actionRecordAndStop))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_list"), style: .plain, target: self, action: #selector(actionList))
    }
    
    func initMapView() {
        let f = CGRect(x: 0, y: 30, width: SCREEN_W, height: SCREEN_H - 49 - 30)
        mapView = MAMapView(frame: f)
        mapView.delegate = self
        mapView.zoomLevel = 15
        // 比例尺
        mapView.showsScale = false
        // 室内地图
        mapView.isShowsIndoorMap = true
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
        
        initMapView()
        initLocationBtn()
    }
    
    func initLocationBtn() {
        locationBtn.frame = CGRect(x: 20, y: SCREEN_H - 20 - 49 - 40, width: 40, height: 40)
        locationBtn.autoresizingMask = .flexibleTopMargin
        locationBtn.backgroundColor = .white
        locationBtn.layer.cornerRadius = 3
        locationBtn.addTarget(self, action: #selector(actionLoaction), for: .touchUpInside)
        locationBtn.setImage(imageNotLocate, for: .normal)
        view.addSubview(locationBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: - MAMapViewDelegate
extension HomeVC: MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation {
            return
        }
        
        let location: CLLocation? = userLocation.location
        if location == nil {
            return
        }
        
        if isRecording {
            if userLocation.location.horizontalAccuracy < 100 && userLocation.location.horizontalAccuracy > 0.0 {
                addLocation(userLocation.location)
            }
        }
    }
    
    
    func mapView(_ mapView: MAMapView!, didChange mode: MAUserTrackingMode, animated: Bool) {
        if mode == .none {
            locationBtn.setImage(imageNotLocate, for: .normal)
        } else {
            locationBtn.setImage(imageLocated, for: .normal)
        }
    }
}


// MARK: - AMapLocationManagerDelegate
extension HomeVC: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy);};");
        
        if let reGe = reGeocode {
            NSLog("reGeocode:%@", reGe)
            locationLabel.text = reGe.formattedAddress
        }
    }
}
