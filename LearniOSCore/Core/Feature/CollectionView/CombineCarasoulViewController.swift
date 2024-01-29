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
        static let changePageTolerance = 0.7
    }
    public struct Layout : Equatable {
        static let textBackgroundColor = UIColor.red
        static let cellBackgroundColor = UIColor.blue
        static let itemSizeNumber = 70.0
        var itemSize = CGSize(width: Self.itemSizeNumber, height: Self.itemSizeNumber)
        var itemMargin = 20.0
        var visibleItemCount = 4
    }
    @OpenCombine.Published
    public var layout = Layout()
    
    // TODO: 改造为 subject
    @OpenCombine.Published
    private var itemList: [String] = (1...12).map { String($0) }
    
    private var currentPageProgress = 0.0
    
    private var _nextCurrentPage = 0.0
    private var nextCurrentPage: CGFloat {
        get { _nextCurrentPage }
        set { _nextCurrentPage = max(0.0, min(CGFloat(calcResult.numberOfPages - 1), newValue)) }
    }
    
    public init() {
        let flowLayout = UICollectionViewFlowLayout()
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
            .sinkUntilFinished { [weak self] layout in
                guard let self = self else { return }
                self.updateLayout()
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
    private struct CalculatePageNumberResult {
        var itemCount = 0
        var visibleItemCount = 0
        var numberOfPages = 0
        /// 最终返回的 itemCount
        /// - Note: 为了实现翻页效果，结果值需要是 visibleItemCount 的整数倍
        var numberOfItems = 0
    }
    private var calcResult = CalculatePageNumberResult()
}

// MARK: BaseCarasoulCollectionView - Update Layout
extension BaseCarasoulCollectionView {
    private func calculatePageNumberResult() {
        let itemCount = itemList.count
        calcResult.itemCount = itemCount
        
        let visibleItemCount = layout.visibleItemCount
        calcResult.visibleItemCount = visibleItemCount
        
        let numberOfPages = (itemCount + visibleItemCount - 1) / visibleItemCount
        let numberOfItems = numberOfPages * visibleItemCount
        calcResult.numberOfPages = numberOfPages
        calcResult.numberOfItems = numberOfItems
    }
    
    private func updateLayout() {
        calculatePageNumberResult()
        
        // 更新可变约束
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
        let width = (layout.itemSize.width + layout.itemMargin) * CGFloat(layout.visibleItemCount) - layout.itemMargin
        constraints?.width?.update(offset: width)
        constraints?.height?.update(offset: layout.itemSize.height)
        
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
        currentPageProgress = offsetX / scrollView.frame.width
        nextCurrentPage = round(currentPageProgress)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("// zymmmmmmmmmmmmmmmmmmm, \(#function), \(velocity), \(targetContentOffset.pointee)")
        targetContentOffset.pointee = scrollView.contentOffset;
        
        if (abs(velocity.x) < CGFloat.ulpOfOne) {
            return
        }
        
        var nextPage: CGFloat, prevPage: CGFloat
        if velocity.x > 0 {
            nextPage = ceil(currentPageProgress)
            prevPage = floor(currentPageProgress)
        } else {
            nextPage = floor(currentPageProgress)
            prevPage = ceil(currentPageProgress)
        }
        nextCurrentPage = abs(nextPage - currentPageProgress) <= Cst.changePageTolerance
                            ? nextPage : prevPage
        print("// zymmmmmmmmmmmmmmmmmmm, \(#function), \(nextCurrentPage), \(currentPageProgress)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        stabilizePageIndex(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stabilizePageIndex(scrollView)
    }
    
    private func stabilizePageIndex(_ scrollView: UIScrollView) {
        var newContentOffsetX: CGFloat
        do {
            let onePageOffset = (layout.itemSize.width + layout.itemMargin) * CGFloat(calcResult.visibleItemCount)
            newContentOffsetX = nextCurrentPage * onePageOffset
//            print("// zymmmmmmmmmmmmmmmmmmm, \(#function), \(currentPage), \(onePageOffset)")
        }
//        scrollView.contentOffset.x = newContentOffsetX
        
        var newContentOffset = scrollView.contentOffset
        newContentOffset.x = newContentOffsetX
        UIView.animate(withDuration: 0.25) {
            scrollView.contentOffset = newContentOffset
        }
//        scrollView.setContentOffset(newContentOffset, animated: true)
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
