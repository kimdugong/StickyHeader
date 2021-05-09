//
//  ViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit

class StickyHeaderViewController: UIViewController {
    private var headerView: UIView
    private var pages: [StickyHeaderChildViewController]
    private var option: DugongStickyHeaderConfiguration
    
    init(pages: [StickyHeaderChildViewController], headerView: UIView, option: DugongStickyHeaderConfiguration) {
        self.pages = pages
        self.headerView = headerView
        self.option = option
        super.init(nibName: nil, bundle: nil)
        configuration(option: option)
    }
    
    private func configuration(option: DugongStickyHeaderConfiguration) {
        container.backgroundColor = option.containerBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stickyHeaderView = StickyHeaderView(view: headerView, option: option)
    
    private lazy var pageView: PageViewController = {
        let pageView = PageViewController(pages: pages, option: option)
        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        pageView.pageViewDelegate = self
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(container)
        container.addSubview(pageView.view)
        NSLayoutConstraint.activate([
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        addChild(pageView)
        pageView.didMove(toParent: self)
        NSLayoutConstraint.activate([
            pageView.view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            pageView.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            pageView.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            pageView.view.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        view.addSubview(stickyHeaderView)
        let headerViewHeightConstraint = stickyHeaderView.heightAnchor.constraint(equalToConstant: option.headerMaxHeight)
        headerViewHeightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            stickyHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            stickyHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewHeightConstraint
        ])
        
        stickyHeaderView.menu.delegate = self
        stickyHeaderView.menu.dataSource = self
        
        // initializing first pageview's scrollview inset and offset
        guard let childVC = pageView.viewControllers?.first as? StickyHeaderChildViewController else { return }
        childVC.delegate = self
        childVC.stickyHeaderChildScrollView?.contentOffset.y = -option.headerMaxHeight
        childVC.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: option.headerMaxHeight, left: 0, bottom: 0, right: 0)
    }
}

extension StickyHeaderViewController: ChildViewContollerScrollDelegate {
    func childViewScrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            return
        }
        if scrollView.contentOffset.y < 0 {
            for constraint in stickyHeaderView.constraints {
                guard constraint.firstAttribute == .height  else { continue }
                constraint.constant = max(abs(scrollView.contentOffset.y), option.headerMinHeight)
                break
            }
        } else {
            for constraint in stickyHeaderView.constraints {
                guard constraint.firstAttribute == .height else { continue }
                constraint.constant = option.headerMinHeight
                break
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
            .forEach({ $0.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: option.headerMaxHeight, left: 0, bottom: 0, right: 0) })
        pendingViewControllers
            .compactMap({ $0 as? StickyHeaderChildViewController })
            .filter({ $0.stickyHeaderChildScrollView?.contentOffset.y ?? 0 + stickyHeaderView.bounds.height <= option.headerMaxHeight })
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.cellForItem(at: indexPath) as? StickyMenuCollectionViewCell else {
            return collectionView.bounds.size
        }
        stickyHeaderView.moveSelectedUnderlineView(index: pageView.visiablePageIndex, animated: false)
        return CGSize(width: cell.bounds.width, height: collectionView.bounds.height)
    }
}
