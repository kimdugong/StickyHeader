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
    var menuTitle: String { get }
    var index: Int { get }
    var currentOffsetY: CGFloat { get }
}

class ChildViewController: UIViewController, StickyHeaderChildViewController {
    var menuTitle: String
    var index: Int
    var currentOffsetY: CGFloat = 0
    
    private lazy var tableview: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        
        return table
    }()


    weak var delegate: ChildViewContollerScrollDelegate?
    
    init(menuTitle: String, index: Int) {
        self.menuTitle = menuTitle
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func adjustScrollViewOffset(offset: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.tableview.contentOffset.y = self.currentOffsetY - offset
        }
    }

    func adjustScrollViewInset(inset: UIEdgeInsets) {
        self.tableview.contentInset = inset
    }

}

extension ChildViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "menu \(menuTitle) row : \(indexPath.row)"
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentOffsetY = scrollView.contentOffset.y
        delegate?.childViewScrollViewDidScroll(scrollView)
    }
}
