//
//  AMapRouteRecord.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/15.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class AMapRouteRecord: NSObject, NSCoding {
    
    var locationsArray: [CLLocation] = []
    
    private let distanceFilter: CLLocationDistance = 10
    private var startTime = Date()
    private var endTime: Date?
    private var tracedLocationsArray: [MATracePoint] = []
    
    override init() {
        super.init()
        endTime = startTime
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(endTime, forKey: "endTime")
        aCoder.encode(locationsArray, forKey: "locations")
    }
    
    required init?(coder aDecoder: NSCoder) {
        startTime = aDecoder.decodeObject(forKey: "startTime") as! Date
        endTime = aDecoder.decodeObject(forKey: "endTime") as? Date
        locationsArray = aDecoder.decodeObject(forKey: "locations") as! Array
    }
    
    func addLocation(_ location: CLLocation?) -> Bool {
        if location == nil {
            return false
        }
        
        let lastLocation: CLLocation? = locationsArray.last
        if lastLocation != nil {
            let distance: CLLocationDistance = lastLocation!.distance(from: location!)
            if distance < distanceFilter {
                return false
            }
        }
        
        locationsArray.append(location!)
        endTime = Date()
        
        return true
    }
    
    func title() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        return formatter.string(from: startTime)
    }

}
