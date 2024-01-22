//
// MainGLKViewController.swift
// LearniOS
//
// Created by DEEP on 2023/12/7
// Copyright © 2023 DEEP. All rights reserved.
//
        

import UIKit
import GLKit
import BlocksKit


class MainGLKViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let glkVC = ExampleGLKViewController.init()
        do {
            self.addChild(glkVC)
            self.view.addSubview(glkVC.view)
            glkVC.willMove(toParent: self)
        }
    }
}

