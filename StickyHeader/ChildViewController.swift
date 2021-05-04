//
//  ChildViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit

protocol ChildViewContollerDelegate: AnyObject {
    func childViewScrollViewDidScroll(_ scrollView: UIScrollView, menuTitle: String)
    func childViewScrollViewDidEndDecelerating(_ scrollView: UIScrollView)
}

class ChildViewController: UIViewController {
    private var menuTitle: String
    private lazy var tableview: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self

        return table
    }()

    private var maxHeight: CGFloat
    var currentOffsetY: CGFloat = 0

    weak var delegate: ChildViewContollerDelegate?
    
    init(menuTitle: String, maxHeight: CGFloat) {
        self.menuTitle = menuTitle
        self.maxHeight = maxHeight
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

    func adjustTableViewOffset(offset: CGFloat) {
        tableview.contentOffset.y = -offset
    }

    func adjustTableViewInset(inset: UIEdgeInsets) {
        tableview.contentInset = inset
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
        delegate?.childViewScrollViewDidScroll(scrollView, menuTitle: menuTitle)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.childViewScrollViewDidEndDecelerating(scrollView)
    }

}
