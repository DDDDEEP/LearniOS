//
// PagingCollectionViewController.swift
// Pods
//
// Created by DEEP on 2024/1/24
// Copyright © 2024 DEEP. All rights reserved.
//
        

import Foundation
import UIKit

// MARK: - PagingCollectionViewController

class PagingCollectionViewController : UICollectionViewController
{
    struct Cst {
        static let reuseIdentifier = "PagingCollectionViewControllerCell"
    }
    struct UI {
        static let margin = 10.0
        static let maxVisalbeItem = 3
        static let collectionWidth = itemWidth * Double(maxVisalbeItem) + margin * Double(maxVisalbeItem - 1) + 2 * collectionViewInset
        static let collectionHeight = 100.0
        static let collectionViewInset = 2.0
        static let itemWidth = itemHeight
        static let itemHeight = collectionHeight - 2 * collectionViewInset
        static let itemMinMargin = 10.0
        static let vcBackgroundColor = UIColor.white
        static let collectionBackgroundColor = UIColor.red
        static let itemBackgroundColor = UIColor.lightGray
        static let itemEmojiImageBackgroundColor = UIColor.yellow
    }
    
    public typealias ItemType = String
    let itemList: [ItemType]
    
    public init(withList list: [ItemType]) {
        itemList = list
        
        let flowLayout = UICollectionViewFlowLayout()
        do {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//            flowLayout.estimatedItemSize = CGSize(width: UI.collectionHeight, height: UI.collectionHeight)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = UI.itemMinMargin
            flowLayout.minimumInteritemSpacing = UI.itemMinMargin
        }
        super.init(collectionViewLayout: flowLayout)
    }
    
    convenience public init() {
        let itemList = (1...30).map { String($0) }
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
        view.backgroundColor = UI.vcBackgroundColor
        do {
            collectionView.backgroundColor = UI.collectionBackgroundColor
            collectionView.register(PagingCollectionViewCell.self, forCellWithReuseIdentifier:Cst.reuseIdentifier)
            collectionView.isPagingEnabled = true
        }
        collectionView.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.width.equalTo(UI.collectionWidth)
            m.height.equalTo(UI.collectionHeight)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 要在这里设置
//        collectionView.frame = CGRect(x: 0, y: UI.collectionHeight, width: UI.collectionWidth, height: UI.collectionHeight)
    }
}

// UICollectionViewDelegate, UICollectionViewDataSource
extension PagingCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emptyCell = { UICollectionViewCell.init() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cst.reuseIdentifier, for: indexPath as IndexPath) as? PagingCollectionViewCell else {
            return emptyCell()
        }
        guard let emoji = itemList[safe: indexPath.row] else {
            return emptyCell()
        }
        
        cell.backgroundColor = UI.itemBackgroundColor
        cell.emoji = emoji
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

extension PagingCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(UI.itemWidth, UI.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: UI.collectionViewInset, left: UI.collectionViewInset, bottom: UI.collectionViewInset, right: UI.collectionViewInset)
    }
}

class PagingCollectionViewCell: UICollectionViewCell {
    public var emoji: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    public lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        do {
            var size = self.frame.size

            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            PagingCollectionViewController.UI.itemEmojiImageBackgroundColor.set()
            
            let rect = CGRect(origin: .zero, size: size)
            UIRectFill(CGRect(origin: .zero, size: size))
            var contentSize = size
            contentSize.width /= 2
            contentSize.height /= 2
            var contentRect = CGRect(origin: .zero, size: contentSize)
            
            (self.emoji as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: contentRect.width)])
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imageView.image = image
        }
    }
}


// MARK: - PagingCollectionLayout

//protocol PagingCollectionLayoutDelegate: NSObjectProtocol {
//    func waterFlowLayout(_ waterFlowLayout: PagingCollectionLayout, indexPath: IndexPath) -> CGFloat
//}
//
//extension PagingCollectionViewController: PagingCollectionLayoutDelegate {
//    func waterFlowLayout(_ waterFlowLayout: PagingCollectionLayout, indexPath: IndexPath) -> CGFloat {
//        return CGFloat(indexPath.row * 20)
//    }
//}
//
//class PagingCollectionLayout: UICollectionViewFlowLayout {
//    weak var delegate: PagingCollectionLayoutDelegate?
//    var cols = 4
//    fileprivate lazy var layoutAttributeArray: [UICollectionViewLayoutAttributes] = []
//    // 高度数组
//    fileprivate lazy var curYaxisArray: [CGFloat] = Array(repeating: self.sectionInset.top, count: cols)
//    fileprivate var maxHeight: CGFloat = 0
//    
//    /// 初始化 layoutAttributeArray，设置好它们的 frame
//    override func prepare() {
//        super.prepare()
//        // 计算每个 Cell 的宽度
//        let itemWidth = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
//        let itemCount = collectionView!.numberOfItems(inSection: 0)
//        var minHeightIndex = 0
//        for i in layoutAttributeArray.count ..< itemCount {
//            let indexPath = IndexPath(item: i, section: 0)
//            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            // 获取动态高度
//            let itemHeight = delegate!.waterFlowLayout(self, indexPath: indexPath)
//            
//            // 找到高度最短的那一列
//            let value = curYaxisArray.min()
//            minHeightIndex = curYaxisArray.firstIndex(of: value!)!
//            // 获取该列的 Y 坐标
//            var itemY = curYaxisArray[minHeightIndex]
//            // 判断是否是第一行，如果换行需要加上行间距
//            if i >= cols {
//                itemY += minimumInteritemSpacing
//            }
//            
//            // 计算该索引的 X 坐标
//            let itemX = sectionInset.left + (itemWidth + minimumInteritemSpacing) * CGFloat(minHeightIndex)
//            // 赋值新的位置信息
//            attr.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
//            // 缓存布局属性
//            layoutAttributeArray.append(attr)
//            // 更新最短高度列的数据
//            curYaxisArray[minHeightIndex] = attr.frame.maxY
//        }
//        maxHeight = curYaxisArray.max()! + sectionInset.bottom
//    }
//}
//
//extension PagingCollectionLayout {
//    /// 返回对于一个 rect，应该返回哪些 UICollectionViewLayoutAttributes
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return layoutAttributeArray.filter {
//            $0.frame.intersects(rect)
//        }
//    }
//    
//    /// 返回 collectionView bounds 的实际大小
//    override var collectionViewContentSize: CGSize {
//        return CGSize(width: collectionView!.bounds.width, height: maxHeight)
//    }
//}
