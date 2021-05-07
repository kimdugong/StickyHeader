//
//  ViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var stickyHeaderView : StickyHeaderViewController?


    override func viewDidLoad() {
        let pages: [StickyHeaderChildViewController] = {
           let tabTitle: [String] = ["추천", "커피", "에이드", "디저트", "스위트", "잡다용품", "기타쩌리"]
           let pages = tabTitle.enumerated().map { (index, title) -> StickyHeaderChildViewController in
               let child = ChildViewController(index: index)
               child.title = title
               return child
           }
           return pages
       }()

        stickyHeaderView = StickyHeaderViewController(pages: pages, maxHeight: 200)
        self.view.addSubview(stickyHeaderView!.view)
        stickyHeaderView?.view.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}
