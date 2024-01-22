//
// MainViewController.swift
// LearniOS
//
// Created by DEEP on 2023/12/7
// Copyright © 2023 DEEP. All rights reserved.
//
        

import UIKit
//import SnapKit
import BlocksKit


class MainViewController: UITableViewController
{
    private let cellReuseIdentifier = "MainViewControllerCell"
    private let cellList: [UIViewController.Type] = [MainGLKViewController.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
//        let button = UIButton()
//        do {
//            self.view.addSubview(button)
//            button.setTitle("跳转 xx 页面", for: .normal)
//            
//            button.bk_(whenTapped: { [weak self] in
//                print("")
//            })
//            box.snp.makeConstraints { (make) -> Void in
//                make.width.height.equalTo(200)
//                make.center.equalTo(superview)
//            }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let vcClass = cellList[indexPath.row]
        cell.textLabel?.text = String(describing: vcClass)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vcClass = cellList[safe: indexPath.row] else {
            return
        }
        
        let vc = vcClass.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
