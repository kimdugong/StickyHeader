//
//  HeaderView.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/05.
//

import UIKit

class StickyHeaderView: UIView {
    var menuHeight: CGFloat
    
    var menu: UICollectionView = {
        let layout = StickyMenuCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StickyMenuCollectionViewCell.self,
                                forCellWithReuseIdentifier: StickyMenuCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    init(menuHeight: CGFloat) {
        self.menuHeight = menuHeight
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemPink
        self.addSubview(menu)
        menu.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(menuHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
