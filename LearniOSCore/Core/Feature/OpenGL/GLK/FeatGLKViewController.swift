//
// FeatGLKViewController.swift
// LearniOS
//
// Created by DEEP on 2023/12/7
// Copyright © 2023 DEEP. All rights reserved.
//
        

import UIKit
import GLKit
import BlocksKit


class FeatGLKViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainListVC = MainListViewContoller.init(withList: [
            ExampleGLKViewController.self,
            CameraGLKViewController.self,
        ])
        
        self.addChild(mainListVC)
        view.addSubview(mainListVC.view)
        mainListVC.willMove(toParent: self)
    }
}

