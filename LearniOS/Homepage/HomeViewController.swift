//
// HomeViewController.swift
// LearniOS
//
// Created by DEEP on 2023/12/7
// Copyright © 2023 DEEP. All rights reserved.
//
        

import UIKit
import SnapKit
import BlocksKit


class HomeViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        
        let button = UIButton()
        do {
            self.view.addSubview(button)
            button.setTitle("跳转 xx 页面", for: .normal)
            
            button.bk_(whenTapped: { [weak self] in
                print("")
            })
//            box.snp.makeConstraints { (make) -> Void in
//                make.width.height.equalTo(200)
//                make.center.equalTo(superview)
//            }
        }

//            [self adSubview:closeButton];
//            UIImage *icon = [UIImage systemImageNamed:@"multiply"];
//            icon = [self p_image:icon rect:CGRectMake(0, 0, 14.44, 14.44)];
//            [closeButton setBackgroundImage:icon forState:UIControlStateNormal];
//            closeButton.contentMode = UIViewContentModeCenter;
//            BDdMasMaker(closeButton, {
//                make.width.mas_equalTo(24.f);
//                make.left.equalTo(self.mas_left).offset(16.f);
//                
//                make.height.mas_equalTo(24.f);
//                make.bottom.equalTo(self.mas_bottom).offset(-9.f);
//            });
//            
//            [closeButton dep_adActionBlockForTouchUpInside:^(__kindof UIButton * _Nonnull sender) {
//                @strongify(self);
//                IESLIVE_BLOCK_INVOKE(self.closeButtonAction);
//            }];
//        }
        
        
    }
}
