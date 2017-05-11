//
//  BWTTabBarController.swift
//  BWT_iOS
//
//  Created by Jonhory on 2017/3/2.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class BWTTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeVC()
        setTabBarItem(home, imageName: "shouye", title: "首页")
        let homeNav = BaseNavigationController(rootViewController: home)
        
//        let commodity = CommodityVC()
//        setTabBarItem(commodity, imageName: "fenlei", title: "分类")
//        let commodityNav = BaseNavigationController(rootViewController: commodity)
//        
//        let shop = ShoppingCartVC()
//        setTabBarItem(shop, imageName: "gouwuche", title: "购物车")
//        let shopNav = BaseNavigationController(rootViewController: shop)
//        
//        let mine = MineVC()
//        setTabBarItem(mine, imageName: "wode", title: "我的")
//        let mineNav = BaseNavigationController(rootViewController: mine)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: DeepGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: DeepBlack], for: .selected)
        
//        self.viewControllers = [homeNav, commodityNav, shopNav, mineNav]
        viewControllers = [homeNav]
        delegate = self
        
        addNoti()
    }
    
    private func addNoti() {
        
    }
    
    private func setTabBarItem(_ vc: UIViewController, imageName: String, title: String) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let imageSel = UIImage(named: "\(imageName)dianji")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: imageSel)
    }
    
    func goHome() {
        selectedIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension BWTTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let index = childViewControllers.index(of: viewController)
//
//        if index == 2 || index == 3 {
//            if UserCenter.shared.token == nil {
//                goLogin()
//                return false
//            }
//        }
        
        return true
    }
}
