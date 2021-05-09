//
//  ChildViewController.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/03.
//

import UIKit

class ChildViewController: UIViewController, StickyHeaderChildViewController {
    var stickyHeaderChildScrollView: UIScrollView?
    var pageIndex: Int
    weak var delegate: ChildViewContollerScrollDelegate?

    private lazy var tableview: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self

        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false

        return table
    }()

    
    init(index: Int) {
        self.pageIndex = index
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

        // assign your scroll view for me to handle offset, inset when change page view controller
        stickyHeaderChildScrollView = tableview
    }
}

extension ChildViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "menu \(title ?? "") row : \(indexPath.row)"
        return cell
    }

    // delegate me for sticky header view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.childViewScrollViewDidScroll(scrollView)
    }

}
