//
//  ViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private var pageView: PageViewController = {
        let pageView = PageViewController(pages: ChildViewController(backgroundColor: .blue), ChildViewController(backgroundColor: .brown))
        
        return pageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemPink
        view.addSubview(container)
        container.addSubview(pageView.view)
        container.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        addChild(pageView)
        pageView.didMove(toParent: self)
        pageView.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }


}

