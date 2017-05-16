//
//  DisplayVC.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/15.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class DisplayVC: BaseViewController {

    var route: AMapRouteRecord?
    var mapView: MAMapView?
    var myLocation: MAAnimatedAnnotation?
    let traceManager = MATraceManager()
    var polyline: MAPolyline?
    
    var isPlaying = false
    var traceCoordinates: [CLLocationCoordinate2D] = []
    var duration: Double = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config(leftStr: backImage, leftHelpStr: nil, titleStr: "轨迹展示", rightHelpStr: nil, rightStr: nil)
        
        initMapView()
        
        showRoute()
        
        handleNav()
        
//        handleLocations()
    }
    
    // MARK: 点击事件
    override func leftBtnClicked(btn: UIButton) {
        mapView?.showsUserLocation = false
        mapView?.removeAnnotations(mapView?.annotations)
        mapView?.remove(polyline)
        mapView?.delegate = nil
        super.leftBtnClicked(btn: btn)
    }
    
    func playAndStop() {
        if route == nil { return }
        
        isPlaying = !isPlaying
        
        if isPlaying {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icon_stop")
            
            if myLocation == nil {
                myLocation = MAAnimatedAnnotation()
                myLocation?.title = "AAAMap"
                myLocation?.coordinate = route!.startLocation()!.coordinate
                
                mapView!.addAnnotation(myLocation)
            }
            
            myLocation!.addMoveAnimation(withKeyCoordinates: &traceCoordinates, count: UInt(traceCoordinates.count), withDuration: CGFloat(duration), withName: "showTime", completeCallback: {[weak self] (isFinished) in
                if isFinished {
                    self?.playAndStop()
                }
            })
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icon_play")
            
            for animation in myLocation!.allMoveAnimations() {
                animation.cancel()
            }
            
            myLocation?.coordinate = traceCoordinates.first!
            myLocation?.movingDirection = 0.0
        }
    }
    
    // MARK: 处理方法
    func showRoute() {
        if route == nil || route!.locationsArray.count == 0 {
            print("轨迹为空")
            return
        }
        
        let startPoint = MAPointAnnotation()
        startPoint.coordinate = route!.startLocation()!.coordinate
        startPoint.title = "开始"
        
        mapView!.addAnnotation(startPoint)
        
        let endPoint = MAPointAnnotation()
        endPoint.coordinate = route!.endLocation()!.coordinate
        endPoint.title = "结束"
        
        mapView!.addAnnotation(endPoint)
        
        var coordiantes: [CLLocationCoordinate2D] = route!.coordinates()
        
        polyline = MAPolyline(coordinates: &coordiantes, count: UInt(coordiantes.count))
        polyline?.title = "mmm"
        
        mapView!.add(polyline)
        
        mapView!.showAnnotations(mapView!.annotations, animated: true)
        
        traceCoordinates = route!.coordinates()
//        duration = route!.totalDuration() / 2.0
    }
    
//    轨迹纠偏，效果不理想
//    func handleLocations() {
//        var traceLocations: [MATraceLocation] = []
//        for cl2D in traceCoordinates {
//            let traceLocation = MATraceLocation()
//            traceLocation.loc = cl2D
//            traceLocations.append(traceLocation)
//        }
//        
//        let queryOperation = traceManager.queryProcessedTrace(with: traceLocations, type: AMapCoordinateType(rawValue: .max)!, processingCallback: { (index, arr) in
//            print("第", index, "组:", arr)
//        }, finishCallback: { (arr: [MATracePoint]?, distance) in
//            self.addTrace(points: arr)
//        }) { (errCode, errDesc) in
//            print("error: ", errCode, errDesc.orNil)
//        }
//    }
//    
//    func addTrace(points: [MATracePoint]?) {
//        if points == nil { return }
//        var newCoordinates: [CLLocationCoordinate2D] = []
//        for point in points! {
//            var cl = CLLocationCoordinate2D()
//            cl.latitude = point.latitude
//            cl.longitude = point.longitude
//            newCoordinates.append(cl)
//        }
//        let polyline = MAPolyline(coordinates: &newCoordinates, count: UInt(newCoordinates.count))
//        
//        mapView!.add(polyline)
//        mapView!.showAnnotations(mapView?.annotations, animated: true)
//    }
    
    // MARK: UI
    func initMapView() {
        mapView = MAMapView(frame: view.bounds)
        mapView?.delegate = self
        view.addSubview(mapView!)
    }
    
    func handleNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_play"), style: .plain, target: self, action: #selector(playAndStop))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
}

extension DisplayVC: MAMapViewDelegate {
    
    // MARK: 绘制小车
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isEqual(myLocation) {
            let annotationID = "myLocationID"
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID)
            if poiAnnotationView == nil {
                poiAnnotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
            }
            poiAnnotationView?.image = UIImage(named: "icon_car")
            poiAnnotationView?.canShowCallout = false
            return poiAnnotationView!
        }
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationID = "locationID"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID) as? MAPinAnnotationView
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
            }
            poiAnnotationView?.animatesDrop = true
            poiAnnotationView?.canShowCallout = true
            return poiAnnotationView!
        }
        return nil
    }
    
    // MARK: 绘制路线
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.strokeColor = rgba(187, 187, 193, 0.6)
            renderer.lineWidth = 3
            renderer.lineJoinType = kMALineJoinRound
            renderer.lineCapType = kMALineCapArrow
            return renderer
        }
        return nil
    }
}
