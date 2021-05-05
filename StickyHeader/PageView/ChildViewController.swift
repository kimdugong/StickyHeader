//
//  ChildViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit

protocol ChildViewContollerScrollDelegate: AnyObject {
    func childViewScrollViewDidScroll(_ scrollView: UIScrollView, menuTitle: String)
    func childScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
}

protocol StickyHeaderChildViewController: UIViewController {
    var menuTitle: String { get }
    var index: Int { get }
}

class ChildViewController: UIViewController, StickyHeaderChildViewController {
    internal var menuTitle: String
    internal var index: Int
    
    private lazy var tableview: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self

        return table
    }()

    var currentOffsetY: CGFloat = 0

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
        UIView.animate(withDuration: 0.25) {
            self.tableview.contentOffset.y -= offset
        }
    }

    func adjustScrollViewInset(inset: UIEdgeInsets) {
        self.tableview.contentInset = inset
    }

}

extension ChildViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "menu \(menuTitle) row : \(indexPath.row)"
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentOffsetY = scrollView.contentOffset.y
        delegate?.childViewScrollViewDidScroll(scrollView, menuTitle: menuTitle)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.childScrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
}
