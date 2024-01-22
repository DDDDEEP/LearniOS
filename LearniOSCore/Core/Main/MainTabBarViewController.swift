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
        self.view.backgroundColor = .clear
        self.tabBar.backgroundColor = .systemBlue
        self.tabBar.tintColor = .black
        
        let vc1 = UINavigationController.init(rootViewController: MainViewController.init())
        do {
            vc1.tabBarItem.title = "首页"
            vc1.tabBarItem.image = UIImage(named: "mapicon")
            vc1.isNavigationBarHidden = false
            vc1.navigationBar.backgroundColor = .systemBlue
            vc1.navigationBar.tintColor = .white
            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                do {
                    navBarAppearance.configureWithOpaqueBackground()
                    navBarAppearance.backgroundColor = .systemBlue
                }
                vc1.navigationBar.standardAppearance = navBarAppearance
                vc1.navigationBar.scrollEdgeAppearance = navBarAppearance
            } else {
                vc1.edgesForExtendedLayout = []
            }
        }
        
        let vc2 = UINavigationController.init(rootViewController: UIViewController.init())
        do {
            vc2.view.backgroundColor = UIColor.white
            vc2.tabBarItem.title = "我"
            vc2.tabBarItem.image = UIImage(named: "smallbell")
        }
        
        self.viewControllers = [vc1, vc2]
    }
}
