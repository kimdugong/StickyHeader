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
        view.backgroundColor = .blue
        return view
    }()
    
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
    
    init(menuHeight: CGFloat, bottomLineHeight: CGFloat, bottomLineColor: UIColor) {
        self.menuHeight = menuHeight
        self.bottomLineHeight = bottomLineHeight
        super.init(frame: .zero)
        
        self.backgroundColor = .systemPink
        self.addSubview(menu)
        menu.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(menuHeight)
        }
        
        selectedUnderlineView.backgroundColor = bottomLineColor
        self.addSubview(selectedUnderlineView)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let cell = menu.cellForItem(at: IndexPath(item: 0, section: 0)) as? StickyMenuCollectionViewCell else {
            return
        }
        selectedUnderlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(bottomLineHeight)
            make.left.right.equalTo(cell)
        }
    }
    
    func moveSelectedUnderlineView(index: Int) {
        guard let cell = menu.cellForItem(at: IndexPath(item: index, section: 0)) as? StickyMenuCollectionViewCell else {
            return
        }
        
        selectedUnderlineView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(bottomLineHeight)
            make.left.right.equalTo(cell)
        }
        
        UIView.animate(withDuration: 0.25) {
            super.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
