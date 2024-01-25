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
    public struct UI {
        static let barColor = UIColor.systemBlue
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tabBar.backgroundColor = UI.barColor
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            do {
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UI.barColor
            }
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }
        
        let mainListVC = MainListViewContoller.init(withList: [
            FeatGLKViewController.self,
            FeatCollectionViewController.self,
            
            // zymmmmmmmmmmmmmmmmmmm
            PagingCollectionViewController.self,
        ])
        let vc1 = UINavigationController.init(rootViewController: mainListVC)
        do {
            vc1.tabBarItem.title = "首页"
            vc1.tabBarItem.image = UIImage(named: "mapicon")
            vc1.isNavigationBarHidden = false
            vc1.navigationBar.backgroundColor = UI.barColor
            vc1.navigationBar.tintColor = .white
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                do {
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UI.barColor
                }
                vc1.navigationBar.standardAppearance = appearance
                vc1.navigationBar.scrollEdgeAppearance = appearance
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
