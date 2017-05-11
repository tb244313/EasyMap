//
//  ViewController.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/11.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mapView: MAMapView!
    var search: AMapSearchAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initMapView()
        initSearch()
    }
    
    func initMapView() {
        mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
//        mapView.zoomLevel = 
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
        
        let stop = AMapBusStopSearchRequest()
        stop.keywords = "会江"
        stop.city = "guangzhou"
        
        search.aMapBusStopSearch(stop)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: MAMapViewDelegate {
    
}

extension ViewController: AMapSearchDelegate {
    func onBusStopSearchDone(_ request: AMapBusStopSearchRequest!, response: AMapBusStopSearchResponse!) {
        if response.busstops.count == 0 {
            return
        }
        
        print(response)
    }
}
