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
    let pages: [StickyHeaderChildViewController] = {
       let tabTitle: [String] = ["낙타", "추천", "커피", "에이드", "디저트", "스위트", "잡다용품", "기타쩌리"]
       let pages = tabTitle.enumerated().map { (index, title) -> StickyHeaderChildViewController in
           let child = ChildViewController(index: index)
           child.title = title
           return child
       }
       return pages
   }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()
    override func viewDidLoad() {
        let option = DugongStickyHeaderConfiguration(headerMaxHeight: 200, headerMinHeight: 0, menuTabHeight: 50)
        option.containerBackgroundColor = .blue
        option.selectedMenuTabItemUnderlineHeight = 1
        stickyHeaderView = StickyHeaderViewController(pages: pages, headerView: headerView, option: option)
        self.view.addSubview(stickyHeaderView!.view)
        stickyHeaderView?.view.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        headerView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
}
