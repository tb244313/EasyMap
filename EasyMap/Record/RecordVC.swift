//
//  RecordVC.swift
//  EasyMap
//
//  Created by Jonhory on 2017/5/15.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class RecordVC: BaseViewController {

    var tableView: UITableView?
    var routes: [AMapRouteRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config(leftStr: backImage, leftHelpStr: nil, titleStr: "轨迹记录", rightHelpStr: nil, rightStr: nil)
        
        initTableView()
        loadRoutes()
    }
    
    func loadRoutes() {
        routes = FileHelper.getRoutes()
        tableView?.reloadData()
    }
    
    func initTableView() {
        let f = CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H - 64)
        tableView = UITableView(frame: f, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let cellID = "cellID"
}

extension RecordVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = routes[indexPath.row].title()
        return cell!
    }
}

extension RecordVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if !routes.isEmpty {
            
            let route: AMapRouteRecord = routes[indexPath.row]
            let displayController = DisplayVC()
            displayController.route = route
            
            navigationController!.pushViewController(displayController, animated: true)
        }
    }
}
