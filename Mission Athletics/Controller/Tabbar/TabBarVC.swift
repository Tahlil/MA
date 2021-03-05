//
//  TabBarVC.swift
//  Mission Athletics
//
//  Created by MAC  on 18/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate
{
    var isProfileSelected = false
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("changeSelectedIndexForChat"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("changeSelectedIndexForRespondingRequest"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("changeSelectedIndexForHome"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSelectedIndexForChat(notification:)), name: Notification.Name("changeSelectedIndexForChat"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSelectedIndexForRespondingRequest(notification:)), name: Notification.Name("changeSelectedIndexForRespondingRequest"), object: nil)
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSelectedIndexForHome(notification:)), name: Notification.Name("changeSelectedIndexForHome"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.callingViewcontroller(notification:)), name: Notification.Name("callingViewcontroller"), object: nil)

    }
     
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }
    @objc func callingViewcontroller(notification: Notification){

        self.selectedIndex = 0

    }
    @objc func changeSelectedIndexForHome(notification: Notification)
    {
        if self.selectedIndex == 0{
            NotificationCenter.default.post(name: Notification.Name("changeHome"), object: notification)
        }else{
            self.selectedIndex = 0
        }
        
    }
    @objc func changeSelectedIndexForChat(notification: Notification)
    {
        self.selectedIndex = 2
    }
    
    @objc func changeSelectedIndexForRespondingRequest(notification: Notification)
    {
        self.selectedIndex = 1
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.bounds.width / numberOfItems, height: tabBar.bounds.height)
        self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red: 225/255, green: 244/255, blue: 249/255, alpha: 1.0), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        // remove default border
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.shadowImage = UIImage()
        
        if #available(iOS 13, *) {
            for item in self.tabBar.items! {
                item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        } else {
            for item in self.tabBar.items! {
                item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            }
        }
//        self.setNeedsStatusBarAppearanceUpdate()
        //changeTabItemImage(tabBar: self.tabBarController!, index: 1, newNotifications: true)  //If needed to change notification icon.
    }
    
    //MARK:- Delegate methods
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items?.index(of: item)
        if indexOfTab == 3{
            isProfileSelected = true
        }else{
            isProfileSelected = false
        }
        GlobalConstants.appDelegate.getUnreadNotifyCountAPICall()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedIndex == 3{
            if isProfileSelected{
                return false
            }else{
                return true
            }
        }
        return true
    }
}
