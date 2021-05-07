//
//  HeaderView.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/05.
//

import UIKit

class StickyHeaderView: UIView {
    var menuHeight: CGFloat
    var bottomLineHeight: CGFloat
    
    private var selectedUnderlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let layout = StickyMenuCollectionViewFlowLayout()

    lazy var menu: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StickyMenuCollectionViewCell.self,
                                forCellWithReuseIdentifier: StickyMenuCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    init(menuHeight: CGFloat, bottomLineHeight: CGFloat, bottomLineColor: UIColor) {
        self.menuHeight = menuHeight
        self.bottomLineHeight = bottomLineHeight
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = .systemPink
        self.addSubview(menu)

        NSLayoutConstraint.activate([
            menu.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            menu.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menu.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            menu.heightAnchor.constraint(equalToConstant: menuHeight)
        ])

        selectedUnderlineView.backgroundColor = bottomLineColor
        self.addSubview(selectedUnderlineView)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let cell = menu.cellForItem(at: IndexPath(item: 0, section: 0)) as? StickyMenuCollectionViewCell else {
            return
        }

        NSLayoutConstraint.activate([
            selectedUnderlineView.widthAnchor.constraint(equalToConstant: cell.frame.width),
            selectedUnderlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            selectedUnderlineView.heightAnchor.constraint(equalToConstant: bottomLineHeight),
            selectedUnderlineView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
        ])
    }
    
    func moveSelectedUnderlineView(index: Int) {
        guard let cell = menu.cellForItem(at: IndexPath(item: index, section: 0)) as? StickyMenuCollectionViewCell else {
            return
        }

        selectedUnderlineView.constraints.first(where: { $0.firstAttribute == .width })?.isActive = false
        selectedUnderlineView.removeFromSuperview()
        self.addSubview(selectedUnderlineView)
        NSLayoutConstraint.activate([
            selectedUnderlineView.widthAnchor.constraint(equalToConstant: cell.frame.width),
            selectedUnderlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            selectedUnderlineView.heightAnchor.constraint(equalToConstant: bottomLineHeight),
            selectedUnderlineView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
        ])
        
        UIView.animate(withDuration: 0.25) {
            super.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
