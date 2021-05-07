//
//  ViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit
import SnapKit

class StickyHeaderViewController: UIViewController {
    private var maxHeight: CGFloat
    private var minHeight: CGFloat = 50
    private var menuHeight: CGFloat = 50
    private var bottomLineHeight: CGFloat = 2.5
    private var pages: [StickyHeaderChildViewController]

    init(pages: [StickyHeaderChildViewController], maxHeight: CGFloat) {
        self.pages = pages
        self.maxHeight = maxHeight
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private lazy var stickyHeaderView = StickyHeaderView(
        menuHeight: menuHeight,
        bottomLineHeight: bottomLineHeight,
        bottomLineColor: .systemGreen)
    
    private lazy var pageView: PageViewController = {
        let pageView = PageViewController(pages: pages, maxHeight: maxHeight, minHeight: minHeight)
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
            make.height.equalTo(maxHeight)
        }
        stickyHeaderView.menu.delegate = self
        stickyHeaderView.menu.dataSource = self

        // initializing first pageview's scrollview inset and offset
        guard let childVC = pageView.viewControllers?.first as? StickyHeaderChildViewController else { return }
        childVC.delegate = self
        childVC.stickyHeaderChildScrollView?.contentOffset.y = -maxHeight
        childVC.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: maxHeight, left: 0, bottom: 0, right: 0)
    }
}

extension StickyHeaderViewController: ChildViewContollerScrollDelegate {
    func childViewScrollViewDidScroll(_ scrollView: UIScrollView) {
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
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.stickyHeaderView.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension StickyHeaderViewController: PageViewControllerDelegate {
    func pageIndexWillChange(index: Int) {
        stickyHeaderView.moveSelectedUnderlineView(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewController.viewControllers?.compactMap({ $0 as? StickyHeaderChildViewController })
            .forEach({ $0.delegate = self })
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewControllers
            .compactMap({ $0 as? StickyHeaderChildViewController })
            .forEach({ $0.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: maxHeight, left: 0, bottom: 0, right: 0) })
        pendingViewControllers
            .compactMap({ $0 as? StickyHeaderChildViewController })
            .filter({ $0.stickyHeaderChildScrollView?.contentOffset.y ?? 0 + stickyHeaderView.bounds.height <= maxHeight })
            .forEach({ $0.stickyHeaderChildScrollView?.contentOffset.y = -stickyHeaderView.bounds.height })
    }
}

extension StickyHeaderViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickyMenuCollectionViewCell.identifier, for: indexPath) as? StickyMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupUI(title: pages[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == pageView.visiablePageIndex {
            return
        }
        let direction: UIPageViewController.NavigationDirection = indexPath.item > pageView.visiablePageIndex ? .forward : .reverse

        pageView.visiablePageIndex = indexPath.item
        pageView.pagingTo(toIndex: indexPath.row, navigationDirection: direction, headerViewHeight: stickyHeaderView.bounds.height)
    }
}
