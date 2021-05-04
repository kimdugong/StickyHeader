//
//  PageViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit

protocol PageViewControllerDelegate: AnyObject {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
}

class PageViewController: UIPageViewController {
    
    private var pages: [UIViewController]
    private var maxHeight: CGFloat
    weak var pageViewDelegate: PageViewControllerDelegate?
    
    init(pages: UIViewController..., maxHeight: CGFloat) {
        self.pages = pages
        self.maxHeight = maxHeight
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        guard let childVC = pages.first as? ChildViewController else {
            return
        }
        childVC.adjustTableViewOffset(offset: maxHeight)
        pages
            .compactMap({ $0 as? ChildViewController })
            .forEach({ $0.adjustTableViewInset(inset: UIEdgeInsets(top: maxHeight, left: 0, bottom: 0, right: 0))})
        self.setViewControllers([childVC], direction: .forward, animated: true, completion: nil)
    }
    
    
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
//        guard previousIndex >= 0 else { return pages.last }
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
//        guard nextIndex < pages.count else { return pages.first }
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageViewDelegate?.pageViewController(pageViewController, willTransitionTo: pendingViewControllers)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewDelegate?.pageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }

}
