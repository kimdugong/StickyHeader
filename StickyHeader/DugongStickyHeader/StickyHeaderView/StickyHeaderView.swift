//
//  HeaderView.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/05.
//

import UIKit

class StickyHeaderView: UIView {
    let option: DugongStickyHeaderConfiguration
    
    private var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var selectedUnderlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var menu: UICollectionView = {
        let layout = StickyMenuCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
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
    
    init(view: UIView, option: DugongStickyHeaderConfiguration) {
        self.option = option
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerView)
        self.addSubview(menu)
        headerView.addSubview(view)
        
        NSLayoutConstraint.activate([
            menu.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            menu.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menu.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            menu.heightAnchor.constraint(lessThanOrEqualToConstant: option.menuTabHeight)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: menu.topAnchor)
        ])
        
        selectedUnderlineView.backgroundColor = option.selectedMenuTabItemUnderlineColor
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
            selectedUnderlineView.heightAnchor.constraint(equalToConstant: option.selectedMenuTabItemUnderlineHeight),
            selectedUnderlineView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
        ])
//        guard let cell = menu.layoutAttributesForItem(at: IndexPath(item: 0, section: 0)) else { return }
//        NSLayoutConstraint.activate([
//            selectedUnderlineView.widthAnchor.constraint(equalToConstant: cell.frame.width),
//            selectedUnderlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            selectedUnderlineView.heightAnchor.constraint(equalToConstant: option.selectedMenuTabItemUnderlineHeight),
//            selectedUnderlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: cell.frame.minX)
//        ])
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
            selectedUnderlineView.heightAnchor.constraint(equalToConstant: option.selectedMenuTabItemUnderlineHeight),
            selectedUnderlineView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
        ])

//        guard let cell = menu.layoutAttributesForItem(at: IndexPath(item: index, section: 0)) else { return }
//        selectedUnderlineView.constraints.first(where: { $0.firstAttribute == .width })?.isActive = false
//        selectedUnderlineView.removeFromSuperview()
//        self.addSubview(selectedUnderlineView)
//        NSLayoutConstraint.activate([
//            selectedUnderlineView.widthAnchor.constraint(equalToConstant: cell.frame.width),
//            selectedUnderlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            selectedUnderlineView.heightAnchor.constraint(equalToConstant: option.selectedMenuTabItemUnderlineHeight),
//            selectedUnderlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: cell.frame.minX)
//        ])

        UIView.animate(withDuration: 0.25) {
            super.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
