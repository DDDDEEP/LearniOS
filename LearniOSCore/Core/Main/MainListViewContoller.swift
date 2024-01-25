//
// MainListViewContoller.swift
// Pods
//
// Created by DEEP on 2024/1/24
// Copyright © 2024 DEEP. All rights reserved.
//
        

import Foundation
import UIKit

// MARK: - MainListViewContoller

class MainListViewContoller : UICollectionViewController
{
    struct Cst {
        static let reuseIdentifier = "MainListViewContollerCell"
        static let itemCountPerLine = 2
    }
    struct UI {
        static let contentMargin: CGFloat = 8.0
        static let itemMargin: CGFloat = 10.0
    }
    
    public typealias ItemType = UIViewController.Type
    let itemList: [ItemType]
    
    public init(withList list: [ItemType]) {
        itemList = list
        
        let flowLayout = UICollectionViewFlowLayout()
        do {
//            flowLayout.itemSize = CGSize(width: 175, height: 50)
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = UI.contentMargin
            flowLayout.minimumInteritemSpacing = UI.contentMargin
        }
        
        super.init(collectionViewLayout: flowLayout)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            collectionView.contentInset = UIEdgeInsets.init(top: 200, left: 0, bottom: 0, right: 0)
            collectionView.backgroundColor = .white
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.alwaysBounceHorizontal = true
            collectionView.register(MainListViewCell.self, forCellWithReuseIdentifier:Cst.reuseIdentifier)
            collectionView.reloadData()
        }
    }
}

extension MainListViewContoller {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emptyCell = UICollectionViewCell.init()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cst.reuseIdentifier, for: indexPath as IndexPath) as? MainListViewCell else {
            return emptyCell
        }
        guard let vcClass = itemList[safe: indexPath.row] else {
            return emptyCell
        }
        
        cell.titleView.text = String(describing: vcClass)
        cell.backgroundColor = .lightGray
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vcClass = itemList[safe: indexPath.row] else {
            return
        }
        
        let vc = vcClass.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainListViewContoller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - CGFloat(UI.contentMargin * CGFloat((Cst.itemCountPerLine - 1)))) / CGFloat(Cst.itemCountPerLine)
        return CGSizeMake(itemWidth, 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

class MainListViewCell: UICollectionViewCell {
    public lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

