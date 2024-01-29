//
// FeatCollectionViewController.swift
// Pods
//
// Created by DEEP on 2024/1/24
// Copyright © 2024 DEEP. All rights reserved.
//
        

import Foundation
import UIKit

class FeatCollectionViewController : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainListVC = MainListViewContoller.init(withList: [
            PagingCollectionViewController.self,
            WaterFallFlowViewController.self,
            CombineCarasoulViewController.self,
        ])
        
        self.addChild(mainListVC)
        view.addSubview(mainListVC.view)
        mainListVC.willMove(toParent: self)
    }
}
