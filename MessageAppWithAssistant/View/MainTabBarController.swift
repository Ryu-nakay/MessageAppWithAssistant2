//
//  MainTabBarController.swift
//  MessageAppWithAssistant
//
//  Created by 中山龍 on 2022/06/13.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().barTintColor = UIColor.black
    }
}
