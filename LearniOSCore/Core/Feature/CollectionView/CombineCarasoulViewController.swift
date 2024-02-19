//
// CombineCarasoulViewController.swift
// Pods
//
// Created by DEEP on 2024/1/28
// Copyright © 2024 DEEP. All rights reserved.
//
        

import Foundation
import SnapKit
import OpenCombine
import OpenCombineDispatch

class CombineCarasoulViewController : UIViewController {
    fileprivate struct UI {
        static let globalBackgroundColor = UIColor.white
        static let carasoulViewBackgroundColor = UIColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UI.globalBackgroundColor
        
        let baseView = BaseCarasoulCollectionView.init()
        do {
            view.addSubview(baseView)
            baseView.backgroundColor = UI.carasoulViewBackgroundColor
            baseView.snp.makeConstraints { (m) in
                m.center.equalToSuperview()
            }
        }
    }
}


// MARK: BaseCarasoulCollectionView
class BaseCarasoulCollectionView : UICollectionView {
    fileprivate struct Cst {
        static let cellReuseIdentifier = "cell"
        static let changePageTolerance = 1.0
        static let defaultPageProgress = 0.5
    }
    public struct Layout : Equatable {
        static let textBackgroundColor = UIColor.red
        static let cellBackgroundColor = UIColor.blue
        static let itemSizeNumber = 70.0
        public var itemSize = CGSize(width: Self.itemSizeNumber, height: Self.itemSizeNumber)
        public var itemMargin = 20.0
        public var visibleItemCount = 4
        public init() {}
    }
    @OpenCombine.Published
    public var layout = Layout()
    
    // TODO: 改造为 subject
    @OpenCombine.Published
    private var itemList: [String] = (1...100).map { String($0) }
    
    public init() {
        let flowLayout = BaseCarasoulCollectionViewLayout()
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        setupLayout()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
        register(BaseCarasoulCollectionViewCell.self, forCellWithReuseIdentifier: Cst.cellReuseIdentifier)
        showsVerticalScrollIndicator = false;
        showsHorizontalScrollIndicator = false;
        isPagingEnabled = true
        delegate = self
        dataSource = self
    }
    
    private func setupBinding() {
        $layout.receive(on: DispatchQueue.main.ocombine)
            .removeDuplicates()
            .scan((old:nil, new:nil), { pairs, newValue in
                return (old:pairs.new, new:newValue)
            })
//            .breakpoint(receiveSubscription: { subscription in
//                return true
//            }, receiveOutput: { output in
//                return true
//            }, receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    return false
//                case .failure:
//                    return true
//                }
//            })
            .sinkUntilFinished { [weak self] pairs in
                guard let self = self else { return }
                self.layoutDidUpdate(old: pairs.old)
            }
    }
    
    // ================== update Layout 相关属性 ==================
    /// 可变化约束的集合
    private struct MutableConstraints {
        struct PageControl {
            var top: Constraint?
            var width: Constraint?
            var height: Constraint?
        }
        var pageControl: PageControl?
    }
    private var mutableConstraints = MutableConstraints()

    /// 翻页相关数值的计算结果
    private struct PaginationProps {
        var itemCount = 0
        var visibleItemCount = 0
        var numberOfPages = 0
        /// 最终返回的 itemCount
        /// - Note: 为了实现翻页效果，结果值需要是 visibleItemCount 的整数倍
        var numberOfItems = 0
        var onePageOffset = 0.0
        var onePageSize = 0.0
        
        /// 中线所对应的翻页进度
        /// 默认为 0.5，即第一页；当进度超过 1.0 时，为第二页
        var currentPageProgress = Cst.defaultPageProgress
        
        var _nextCurrentPage = 0
        var nextCurrentPage: Int {
            get { _nextCurrentPage }
            set { _nextCurrentPage = max(0, min(numberOfPages - 1, newValue)) }
        }
    }
    private var paginationProps = PaginationProps()
}

// MARK: BaseCarasoulCollectionView - Update Layout
extension BaseCarasoulCollectionView {
    private func calculatePageNumberResult() {
        let itemCount = itemList.count
        paginationProps.itemCount = itemCount
        
        let visibleItemCount = layout.visibleItemCount
        paginationProps.visibleItemCount = visibleItemCount
        
        let numberOfPages = (itemCount + visibleItemCount - 1) / visibleItemCount
        let numberOfItems = numberOfPages * visibleItemCount
        paginationProps.numberOfPages = numberOfPages
        paginationProps.numberOfItems = numberOfItems
        
        let onePageOffset = (layout.itemSize.width + layout.itemMargin) * CGFloat(paginationProps.visibleItemCount)
        paginationProps.onePageOffset = onePageOffset
        paginationProps.onePageSize = onePageOffset - layout.itemMargin
    }
    
    private func layoutDidUpdate(old oldLayout: Layout?) {
        calculatePageNumberResult()
        
        // 更新可变约束
        if oldLayout?.itemSize != layout.itemSize {
            if mutableConstraints.pageControl == nil {
                ({
                    var constraints = MutableConstraints.PageControl()
                    self.snp.makeConstraints { (m) in
                        constraints.width = m.width.equalTo(0).constraint
                        constraints.height = m.height.equalTo(0).constraint
                    }
                    $0 = constraints
                })(&mutableConstraints.pageControl)
            }
            let constraints = mutableConstraints.pageControl
            let width = paginationProps.onePageSize
            
            constraints?.width?.update(offset: width)
            constraints?.height?.update(offset: layout.itemSize.height)
        }
        
        setNeedsLayout()
        reloadData()
    }
}

extension BaseCarasoulCollectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return layout.itemMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let createEmptyCell = { UICollectionViewCell.init() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cst.cellReuseIdentifier, for: indexPath as IndexPath) as? BaseCarasoulCollectionViewCell else {
            return createEmptyCell()
        }
        guard let item = itemList[safe: indexPath.row] else {
            return createEmptyCell()
        }
        
        let colorAlpha = CGFloat(indexPath.row + 1) / CGFloat(itemList.count)
        cell.layout = BaseCarasoulCollectionViewCell.Layout(titleText: item)
        cell.backgroundColor = Layout.cellBackgroundColor.withAlphaComponent(colorAlpha)
        cell.titleView.backgroundColor = Layout.textBackgroundColor.withAlphaComponent(colorAlpha)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        var currentPageProgress = offsetX / paginationProps.onePageOffset + Cst.defaultPageProgress
        currentPageProgress = (currentPageProgress.isInfinite || currentPageProgress.isNaN) ? 0.0 : currentPageProgress
        paginationProps.currentPageProgress = currentPageProgress
        paginationProps.nextCurrentPage = Int(floor(currentPageProgress))
        print("// zymmmmmmmmmmmmmmmmmmm, \(#function), \(paginationProps.nextCurrentPage), \(paginationProps.currentPageProgress)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("// zymmmmmmmmmmmmmmmmmmm, \(#function), \(velocity), \(targetContentOffset.pointee)")
        targetContentOffset.pointee = scrollView.contentOffset;
        if (abs(velocity.x) < CGFloat.ulpOfOne) {
            return
        }
        
        // 带 tolerance 的逻辑·
//        do {
//            var nextPage: CGFloat, prevPage: CGFloat
//            if velocity.x > 0 {
//                nextPage = ceil(currentPageProgress)
//                prevPage = floor(currentPageProgress)
//            } else {
//                nextPage = floor(currentPageProgress)
//                prevPage = ceil(currentPageProgress)
//            }
//            print("// zymmmmmmmmmmmmmmmmmmm, \(#function), velocity: \(velocity), currentPageProgress:\(currentPageProgress)")
//            nextCurrentPage = abs(nextPage - currentPageProgress) <= Cst.changePageTolerance
//            ? nextPage : prevPage
//        }
        
        // 假设此时 progress = 3.35，currentPage = 3
        // 当 velocity.x > 0 时，则下一页 nextPage = 4；
        // 当 velocity.x < 0 时，则上一页 nextPage = 2；
        let nextPage = (velocity.x > 0 ? ceil(paginationProps.currentPageProgress) : floor(paginationProps.currentPageProgress) - 1)
        paginationProps.nextCurrentPage = Int(nextPage)
        print("// zymmmmmmmmmmmmmmmmmmm, \(#function), \(paginationProps.nextCurrentPage), \(paginationProps.currentPageProgress)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        stabilizePageIndex(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stabilizePageIndex(scrollView)
    }
    
    private func doRepeatAnimation(totalDuration: TimeInterval, totalCount: Int, currentStep: Int = 1, animation: @escaping (() -> Void)) {
        if currentStep > totalCount {
            return
        }

        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: .linear))
        UIView.animate(withDuration: totalDuration / CGFloat(totalCount), animations: {
            animation()
        }, completion: { finished in
            self.doRepeatAnimation(totalDuration: totalDuration, totalCount: totalCount, currentStep: currentStep + 1, animation: animation)
        })
        CATransaction.commit()
    }
    
    /**
     Generate promises at a limited rate and wait for all to fulfill.

     For example:
     
         func downloadFile(url: URL) -> Promise<Data> {
             // ...
         }
     
     No more than three downloads will occur simultaneously.

     - Note: The generator is called *serially* on a *background* queue.
     - Warning: Refer to the warnings on `when(fulfilled:)`
     - Parameter promiseGenerator: Generator of promises.
     - Returns: A new promise that resolves when all the provided promises fulfill or one of the provided promises rejects.
     - SeeAlso: `when(resolved:)`
     */
    private func stabilizePageIndex(_ scrollView: UIScrollView) {
        let onePageOffset = paginationProps.onePageOffset
        let newContentOffsetX = CGFloat(paginationProps.nextCurrentPage) * onePageOffset
//        scrollView.contentOffset.x = newContentOffsetX
        
        // 最原始的动画方式
//        do {
//            var newContentOffset = scrollView.contentOffset
//            newContentOffset.x = newContentOffsetX
//            UIView.animate(withDuration: 0.25) {
//                scrollView.contentOffset = newContentOffset
//            }
//        }
        
        // 拆分 step 的递归动画方式，时 bounds 外的 item 不会一下子消失
        do {
            let step = 2;
            let contentOffsetStep = (newContentOffsetX - scrollView.contentOffset.x) / CGFloat(step);
            doRepeatAnimation(totalDuration: 0.2, totalCount: step) {
                var newContentOffset = scrollView.contentOffset
                newContentOffset.x += contentOffsetStep
                scrollView.contentOffset = newContentOffset
            }
        }
        
        // 拆分 step 的关键帧动画方式，（实际无优化，猜测因为系统直接设置了最终 contentOffset）
//        do {
//            let animationTime = 0.25
//            UIView.animateKeyframes(withDuration: animationTime, delay: 0, options: [], animations: {
//                let step = 2
//                let animationTimeStep = 1.0 / CGFloat(step)
//                
//                for i in 1...step {
//                    UIView.addKeyframe(withRelativeStartTime: animationTimeStep * CGFloat(i - 1), relativeDuration: animationTimeStep, animations: {
//                        
//                    })
//                }
//            }, completion: nil)
//        }
        
        
        // 针对 bounds 的事务动画方式（实际 offset 计算不对）
//        do {
//            var newContentOffset = scrollView.contentOffset
//            newContentOffset.x = newContentOffsetX
//            animateInChunks(totalDuration: 0.25, chunkCount: 2, scrollView: scrollView, targetContentOffset: newContentOffset)
//            return
//            
//            
//            let distanceX = newContentOffsetX - scrollView.contentOffset.x
//            let distanceXStep = (newContentOffsetX - scrollView.contentOffset.x) / CGFloat(layout.visibleItemCount)
//            
//            let oldBounds = scrollView.bounds
//            var newBounds = oldBounds
//            newBounds.origin.x += distanceX
//            var values:[CGRect] = []
//            for i in 0...layout.visibleItemCount {
//                var newBounds = oldBounds
//                newBounds.origin.x += distanceXStep * CGFloat(i)
//                values.append(newBounds)
//            }
//            
//            CATransaction.begin()
//            CATransaction.setDisableActions(true)
//            let animation = CAKeyframeAnimation(keyPath: "bounds")
//            animation.values = values
//            //        animation.fromValue = oldBounds
//            //        animation.toValue = newBounds
//            //        animation.isAdditive = true
//            animation.duration = 1
//            animation.isRemovedOnCompletion = true
//            CATransaction.setCompletionBlock {
//                scrollView.contentOffset = newContentOffset
//            }
//            scrollView.layer.add(animation, forKey: "my_custom")
//            CATransaction.commit()
//        }
    }
}


fileprivate class BaseCarasoulCollectionViewCell : UICollectionViewCell {
    public struct Layout : Equatable {
        static let cornerRaidus = 10.0
        var titleText: String = "default"
    }
    @OpenCombine.Published
    public var layout = Layout()
    
    private var bindings: Set<AnyCancellable> = []
    
    lazy var titleView: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override var isHidden: Bool {
        get {
            super.isHidden
        }
        set {
            super.isHidden = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = Layout.cornerRaidus
        
        do {
            contentView.addSubview(titleView)
            titleView.snp.makeConstraints { (m) in
                m.width.equalToSuperview()
                m.centerY.equalToSuperview()
            }
            
            $layout.receive(on: DispatchQueue.main.ocombine)
                .removeDuplicates()
                .sinkUntilFinished { [weak self] layout in
                    guard let self = self else { return }
                    self.titleView.text = layout.titleText
                    self.titleView.sizeToFit()
                }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


fileprivate class BaseCarasoulCollectionViewLayout : UICollectionViewFlowLayout {
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
//    
//    /// 返回对于一个 rect，应该返回哪些 UICollectionViewLayoutAttributes
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = super.layoutAttributesForElements(in: rect)
        
        var temp = result?.map { "\($0.indexPath.row)" }
                    .joined(separator:" ")
//        var temp = result?.map { "\($0.indexPath.row)-(\($0.frame.origin.x), \($0.frame.size.width)),\($0.isHidden)" }
//                    .joined(separator:" ")
//        print("// zymmmmmmmmmmmmmmmmmmm, \(#function), rect: \(rect), elements: \(temp ?? "[]")")
        
        return result
    }
//    
//    /// 返回 collectionView bounds 的实际大小
//    override var collectionViewContentSize: CGSize {
//        return CGSize(width: collectionView!.bounds.width, height: maxHeight)
//    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        var result = super.shouldInvalidateLayout(forBoundsChange: newBounds)
//        print("// zymmmmmmmmmmmmmmmmmmm, \(#function), \(result)")
        return result
    }
    
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        var result = super.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
//        print("// zymmmmmmmmmmmmmmmmmmm, \(#function), \(result)")
        return result
    }
}
