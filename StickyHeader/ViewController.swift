//
//  ViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private var maxHeight: CGFloat = 200
    private var minHeight: CGFloat = 50
    private var menuHeight: CGFloat = 50
    private var tabTitle: [String] = ["추천", "커피", "에이드", "디저트", "스위트", "잡다용품", "기타쩌리"]

    private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()

    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemTeal
        return view
    }()
    
    private lazy var stickyHeaderView = StickyHeaderView(menuHeight: menuHeight)
    
    private lazy var pageView: PageViewController = {
        let pages = tabTitle.enumerated().map { (index, title) -> ChildViewController in
            let child = ChildViewController(menuTitle: title, index: index)
            child.delegate = self
            return child
        }
        let pageView = PageViewController(pages: pages, maxHeight: maxHeight)
        pageView.pageViewDelegate = self
        return pageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(container)
        container.addSubview(pageView.view)
        container.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        addChild(pageView)
        pageView.didMove(toParent: self)
        pageView.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(stickyHeaderView)
        stickyHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(maxHeight).priority(.medium)
        }
        stickyHeaderView.menu.delegate = self
        stickyHeaderView.menu.dataSource = self
    }
}

extension ViewController: ChildViewContollerScrollDelegate {
    func childScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        currentHeight = min(stickyHeaderView.frame.height, maxHeight)
    }

    func childViewScrollViewDidScroll(_ scrollView: UIScrollView, menuTitle: String) {
        if scrollView.contentOffset.y == 0 {
            return
        }
        if scrollView.contentOffset.y < 0 {
            stickyHeaderView.snp.updateConstraints { make in
                make.height.equalTo(max(abs(scrollView.contentOffset.y), minHeight))
            }
        } else {
            stickyHeaderView.snp.updateConstraints { make in
                make.height.equalTo(minHeight)
            }
        }
    }
}

extension ViewController: PageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewControllers
            .compactMap({ $0 as? ChildViewController })
            .forEach({ $0.adjustScrollViewOffset(offset: $0.currentOffsetY + stickyHeaderView.bounds.height) })
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickyMenuCollectionViewCell.identifier, for: indexPath) as? StickyMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupUI(title: tabTitle[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == pageView.visiablePageIndex {
            return
        }
        let direction: UIPageViewController.NavigationDirection = indexPath.item > pageView.visiablePageIndex ? .forward : .reverse

        pageView.visiablePageIndex = indexPath.item
        pageView.pagingTo(pageWithAtIndex: indexPath.row, andNavigationDirection: direction, headerViewHeight: stickyHeaderView.bounds.height)
    }
}
