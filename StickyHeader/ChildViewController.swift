//
//  ChildViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit

class ChildViewController: UIViewController {
    var backgroundColor: UIColor
    
    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        // Do any additional setup after loading the view.
    }

}
