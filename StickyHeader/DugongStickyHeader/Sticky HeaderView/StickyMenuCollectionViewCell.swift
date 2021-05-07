//
//  StickyMenuCollectionViewCell.swift
//  StickyHeader
//
//  Created by Dugong on 2021/05/05.
//

import UIKit

class StickyMenuCollectionViewCell: UICollectionViewCell {
    static let identifier = "StickyMenuCollectionViewCell"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setupUI(title: String?) {
        titleLabel.text = title
        titleLabel.sizeToFit()
    }
}
