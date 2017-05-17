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
    var polyline: MAPolyline?//MAMultiPolyline?
    
    var isPlaying = false
    var traceCoordinates: [CLLocationCoordinate2D] = []
    var lineColors: [UIColor] = []
    var indexToColorDict: [Int: UIColor] = [:]
    var speedToCLArr: [[String: Any]] = []
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
        
        // 子线程排序 绘制路线
        let queue = DispatchQueue(label: "quickSortQueue")
        queue.async {
//            var indexss: [Int] = []
//            for i in 0...(self.route!.locationsArray.count - 1) {
//                let cl = self.route!.locationsArray[i]
//                self.indexToColorDict[i] = Blue
//                var speedToCLDic: [String: Any] = [:]
//                speedToCLDic["speed"] = cl.speed
//                speedToCLDic["cl"] = cl
//                self.speedToCLArr.append(speedToCLDic)
//                if i != 0 {
//                    indexss.append(i)
//                }
//            }
//            print("排序前", self.speedToCLArr)
//            self.speedToCLArr = self.quickSort(data: self.speedToCLArr)
//            print("排序后", self.speedToCLArr)
//            let count = self.speedToCLArr.count
//            
//            if count >= 6 {
//                let key: Double = 1/6
//                for i in 0..<self.speedToCLArr.count {
//                    let currentValue: Double = Double(i) / Double(count)
//                    if currentValue < key {
//                        self.handle(i: i, colorIndex: 5)
//                    } else if currentValue >= key && currentValue < 2*key {
//                        self.handle(i: i, colorIndex: 4)
//                    } else if currentValue >= 2*key && currentValue < 3*key {
//                        self.handle(i: i, colorIndex: 3)
//                    } else if currentValue >= 3*key && currentValue < 4*key {
//                        self.handle(i: i, colorIndex: 2)
//                    } else if currentValue >= 4*key && currentValue < 5*key {
//                        self.handle(i: i, colorIndex: 1)
//                    } else if currentValue >= 5*key {
//                        self.handle(i: i, colorIndex: 0)
//                    }
//                }
//            } else {
//                for i in 0..<self.speedToCLArr.count {
//                    self.handle(i: i, colorIndex: i)
//                }
//            }
//            
//            
//            for dic in self.indexToColorDict {
//                self.lineColors.append(dic.value)
//            }
//            print("颜色分段数组",indexss)
//            print("颜色数组", self.lineColors)
//            
            var coordiantes: [CLLocationCoordinate2D] = self.route!.coordinates()
//            self.polyline = MAMultiPolyline(coordinates: &coordiantes, count: UInt(coordiantes.count), drawStyleIndexes: indexss)
            
            self.polyline = MAPolyline(coordinates: &coordiantes, count: UInt(coordiantes.count))
            
            self.polyline?.title = "多段线"
            
            self.mapView!.add(self.polyline)
            
            self.mapView!.showAnnotations(self.mapView!.annotations, animated: true)
            
            self.traceCoordinates = self.route!.coordinates()
        }
    }
    
    let lineSpeedColors: [UIColor] = [UIColor("#ff0000"),UIColor("#ff33ff"),UIColor("#ff6600"),UIColor("#ff9900"),UIColor("#ffcc00"),UIColor("#ffff00")]

    func handle(i: Int, colorIndex: Int) {
        for j in 0..<self.route!.locationsArray.count {
            let cl = self.route!.locationsArray[j]
            let dic: [String: Any] = speedToCLArr[i]
            if let speed: CLLocationSpeed = dic["speed"] as? CLLocationSpeed, let dicCL: CLLocation = dic["cl"] as? CLLocation {
                if speed == cl.speed && dicCL.coordinate.latitude == cl.coordinate.latitude && dicCL.coordinate.longitude == cl.coordinate.longitude {
                    indexToColorDict[j] = lineSpeedColors[colorIndex]
                    print("No. ", j, "sppeed" ,speed , "colorIndex = ", colorIndex)
                    break
                }
            }
        }
    }
    
    func quickSort(data:[[String: Any]]) -> [[String: Any]] {
        if data.count <= 1 {
            return data
        }
        
        var left:[[String: Any]] = []
        var right:[[String: Any]] = []
        let pivot:[String: Any] = data[data.count-1]
        for index in 0..<data.count-1 {
            let indexV1: [String : Any] = data[index]
            if let indexV2: CLLocationSpeed = indexV1["speed"] as? CLLocationSpeed , let pivotV2: CLLocationSpeed = pivot["speed"] as? CLLocationSpeed {
                if indexV2 < pivotV2 {
                    left.append(indexV1)
                } else {
                    right.append(indexV1)
                }
            }
        }
        
        var result = quickSort(data: left)
        result.append(pivot)
        let rightResult = quickSort(data: right)
        result.append(contentsOf: rightResult)
        return result
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
    
    // MARK: 绘制小车/ 起点终点
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
            if annotation.title == "开始" {
                poiAnnotationView?.image = UIImage(named: "manBegin")
            } else if annotation.title == "结束" {
                poiAnnotationView?.image = UIImage(named: "manEnd")
            }
            
            poiAnnotationView?.animatesDrop = true
            poiAnnotationView?.canShowCallout = true
            return poiAnnotationView!
        }
        return nil
    }
    
    // MARK: 绘制路线
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
//        if overlay.isKind(of: MAMultiPolyline.self) {
//            let r = MAMultiColoredPolylineRenderer(overlay: overlay)
//            r!.strokeColors = lineColors
//            r!.lineWidth = 3
//            r!.lineJoinType = kMALineJoinRound
//            r!.lineCapType = kMALineCapArrow
//            r!.isGradient = true
//            
//            return r
//        }
        if overlay.isKind(of: MAPolyline.self) {
            let r = MAPolylineRenderer(overlay: overlay)
            r?.strokeColor = UIColor("#ff0000")
            r!.lineWidth = 3
//            r!.fillColor = UIColor("#ff0000")
//            r!.loadStrokeTextureImage(UIImage.init(named: "iblack"))
            
            return r!
        }
        return nil
    }
}
