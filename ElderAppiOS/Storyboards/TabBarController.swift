//
//  TabBarController.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/3.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        
//        let selectedImage1 = UIImage(named: "tabbar_home_pre")?.withRenderingMode(.alwaysOriginal)
//        let deSelectedImage1 = UIImage(named: "tabbar_home_n")?.withRenderingMode(.alwaysOriginal)
//        tabBarItem = self.tabBar.items![0]
//        tabBarItem.image = deSelectedImage1
//        tabBarItem.selectedImage = selectedImage1
//        
//        
//        let selectedImage2 = UIImage(named: "tabbar_menu_pre")?.withRenderingMode(.alwaysOriginal)
//        let deSelectedImage2 = UIImage(named: "tabbar_menu_n")?.withRenderingMode(.alwaysOriginal)
//        tabBarItem = self.tabBar.items![1]
//        tabBarItem.image = deSelectedImage2
//        tabBarItem.selectedImage = selectedImage2
//        
//        let selectedImage3 = UIImage(named: "tabbar_cart_pre")?.withRenderingMode(.alwaysOriginal)
//        let deSelectedImage3 = UIImage(named: "tabbar_cart_n")?.withRenderingMode(.alwaysOriginal)
//        tabBarItem = self.tabBar.items![2]
//        tabBarItem.image = deSelectedImage3
//        tabBarItem.selectedImage = selectedImage3
//        tabBarItem.badgeValue = "?"
        
        NotificationCenter.default.addObserver(self, selector: #selector(showEventDetail), name: Notification.Name("showEventDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPostDetail), name: Notification.Name("showPostDetail"), object: nil)
    }
    
    @objc func showEventDetail(){
        print("hello 1")
        self.selectedIndex = 1
    }
    
    @objc func showPostDetail(){
        print("hello 2")
        self.selectedIndex = 2
    }
    


}
