//
// MainTabBarViewController.swift
// LearniOS
//
// Created by DEEP on 2022/6/9
// Copyright © 2022 DEEP. All rights reserved.
//
        

import UIKit
import MapKit
import SnapKit
import CoreLocation

@objc public class MainTabBarViewController: UITabBarController
{
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        
        let vc1 = MainViewController.init()
        do {
            vc1.tabBarItem.title = "首页"
            vc1.tabBarItem.image = UIImage(named: "mapicon")
        }
        
        let vc2 = UIViewController.init()
        do {
            vc2.view.backgroundColor = UIColor.white
            vc2.tabBarItem.title = "我"
            vc2.tabBarItem.image = UIImage(named: "smallbell")
        }
        
        self.viewControllers = [vc1, vc2]
    }
}
