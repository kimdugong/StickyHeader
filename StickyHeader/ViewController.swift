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
    private var currentHeight: CGFloat = 200
    private var minHeight: CGFloat = 50

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

    private var topMenu: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return collectionView
    }()
    
    private lazy var pageView: PageViewController = {
        let child1 = ChildViewController(menuTitle: "1", maxHeight: maxHeight)
        child1.delegate = self
        let child2 = ChildViewController(menuTitle: "2", maxHeight: maxHeight)
        child2.delegate = self
        let child3 = ChildViewController(menuTitle: "3", maxHeight: maxHeight)
        child3.delegate = self
        let child4 = ChildViewController(menuTitle: "4", maxHeight: maxHeight)
        child4.delegate = self
        let child5 = ChildViewController(menuTitle: "5", maxHeight: maxHeight)
        child5.delegate = self
        let child6 = ChildViewController(menuTitle: "6", maxHeight: maxHeight)
        child6.delegate = self
        let pageView = PageViewController(pages: child1, child2, child3, child4, child5, child6, maxHeight: maxHeight)
        pageView.pageViewDelegate = self
        return pageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemPink

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

        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(maxHeight).priority(.medium)
        }
        
    }
}

extension ViewController: ChildViewContollerDelegate {
    func childViewScrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView)
        currentHeight = headerView.frame.height
    }

    func childViewScrollViewDidScroll(_ scrollView: UIScrollView, menuTitle: String) {
        if scrollView.contentOffset.y == 0 {
            return
        }
        if scrollView.contentOffset.y < 0 {
            headerView.snp.updateConstraints { make in
                make.height.equalTo(max(abs(scrollView.contentOffset.y), minHeight))
            }
        } else {
            headerView.snp.updateConstraints { make in
                make.height.equalTo(minHeight)
            }
        }
    }
}

extension ViewController: PageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if currentHeight <= maxHeight {
            pendingViewControllers
                .compactMap({ $0 as? ChildViewController })
                .forEach({ $0.adjustTableViewOffset(offset: currentHeight)})
        }
    }



}
