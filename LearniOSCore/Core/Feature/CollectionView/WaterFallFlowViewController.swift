//
// WaterFallFlowViewController.swift
// Pods
//
// Created by DEEP on 2024/1/24
// Copyright © 2024 DEEP. All rights reserved.
//
        

import Foundation
import UIKit

// MARK: - WaterFallFlowViewController

class WaterFallFlowViewController : UICollectionViewController
{
    struct Cst {
        static let reuseIdentifier = "WaterFallFlowViewControllerCell"
    }
    struct UI {
        static let margin = 8.0
    }
    
    public typealias ItemType = String
    let itemList: [ItemType]
    
    public init(withList list: [ItemType]) {
        itemList = list
        
        let flowLayout = WaterFallFlowLayout()
        do {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = UI.margin
            flowLayout.minimumInteritemSpacing = UI.margin
        }
        super.init(collectionViewLayout: flowLayout)
        flowLayout.delegate = self
    }
    
    convenience public init() {
        let itemList = (1...30).map { _ in "123456789" }
        self.init(withList: itemList)
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
            collectionView.register(WaterFallFlowViewCell.self, forCellWithReuseIdentifier:Cst.reuseIdentifier)
            collectionView.reloadData()
        }
    }
}

extension WaterFallFlowViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emptyCell = UICollectionViewCell.init()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cst.reuseIdentifier, for: indexPath as IndexPath) as? WaterFallFlowViewCell else {
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
        
//        let vc = vcClass.init()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WaterFallFlowViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
    }
}

class WaterFallFlowViewCell: UICollectionViewCell {
    public lazy var titleView: UILabel = {
        let title = UILabel()
        return title
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


// MARK: - WaterFallLayout

protocol WaterFallLayoutDelegate: NSObjectProtocol {
    func waterFlowLayout(_ waterFlowLayout: WaterFallFlowLayout, indexPath: IndexPath) -> CGFloat
}

extension WaterFallFlowViewController: WaterFallLayoutDelegate {
    func waterFlowLayout(_ waterFlowLayout: WaterFallFlowLayout, indexPath: IndexPath) -> CGFloat {
        return CGFloat(indexPath.row * 20)
    }
}

class WaterFallFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: WaterFallLayoutDelegate?
    var cols = 4
    fileprivate lazy var layoutAttributeArray: [UICollectionViewLayoutAttributes] = []
    // 高度数组
    fileprivate lazy var curYaxisArray: [CGFloat] = Array(repeating: self.sectionInset.top, count: cols)
    fileprivate var maxHeight: CGFloat = 0
    
    /// 初始化 layoutAttributeArray，设置好它们的 frame
    override func prepare() {
        super.prepare()
        // 计算每个 Cell 的宽度
        let itemWidth = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        var minHeightIndex = 0
        for i in layoutAttributeArray.count ..< itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // 获取动态高度
            let itemHeight = delegate!.waterFlowLayout(self, indexPath: indexPath)
            
            // 找到高度最短的那一列
            let value = curYaxisArray.min()
            minHeightIndex = curYaxisArray.firstIndex(of: value!)!
            // 获取该列的 Y 坐标
            var itemY = curYaxisArray[minHeightIndex]
            // 判断是否是第一行，如果换行需要加上行间距
            if i >= cols {
                itemY += minimumInteritemSpacing
            }
            
            // 计算该索引的 X 坐标
            let itemX = sectionInset.left + (itemWidth + minimumInteritemSpacing) * CGFloat(minHeightIndex)
            // 赋值新的位置信息
            attr.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            // 缓存布局属性
            layoutAttributeArray.append(attr)
            // 更新最短高度列的数据
            curYaxisArray[minHeightIndex] = attr.frame.maxY
        }
        maxHeight = curYaxisArray.max()! + sectionInset.bottom
    }
}

extension WaterFallFlowLayout {
    /// 返回对于一个 rect，应该返回哪些 UICollectionViewLayoutAttributes
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributeArray.filter {
            $0.frame.intersects(rect)
        }
    }
    
    /// 返回 collectionView bounds 的实际大小
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: maxHeight)
    }
}
