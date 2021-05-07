//
//  ChildViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit

protocol ChildViewContollerScrollDelegate: AnyObject {
    func childViewScrollViewDidScroll(_ scrollView: UIScrollView)
}

protocol StickyHeaderChildViewController: UIViewController {
    var pageIndex: Int { get }
    var stickyHeaderChildScrollView: UIScrollView? { get }
    var delegate: ChildViewContollerScrollDelegate? { get set }
}
